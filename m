Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaE1PJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:09:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37456 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaE1PJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:09:54 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 0/4] ima: extending secure boot certificate chain
Date: Wed, 28 May 2014 11:09:40 -0400
Message-Id: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052815-0928-0000-0000-0000023BF79E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original patches extended the secure boot signature chain of trust
to IMA-appraisal, by allowing only certificates signed by a 'trusted'
key on the system_trusted_keyring to be added to the IMA keyring.

There were a number of issues with the original patch set, including
kbuild issues, which have been resolved, and with the special dot
prefixed keyrings.  The function key_get_type_from_user(), verfies
the '_type', not the '_description', is dot prefixed.  The previous
version added an additional test, but left the existing check in
key_get_type_from_user().  This patch set removes the unnecessary
dot check.

Previous versions attempted to verify a certificate is signed by a
trusted key, but not necessarily by any key on the system_trusted_keyring.
The first attempt, permitted any key on the targeted trusted keyring
to verify a certificate. This introduced concerns of transitive trust.
The subsequent attempt defined a separate keyring, associated with
each targeted trusted keyring.  This patch set defines a single new
owner_trusted_keyring.

thanks,

Mimi

Mimi Zohar (4):
  KEYS: special dot prefixed keyring name bug fix
  KEYS: verify a certificate is signed by a 'trusted' key
  ima: define '.ima' as a builtin 'trusted' keyring
  KEYS: define an owner trusted keyring

 crypto/asymmetric_keys/x509_public_key.c | 85 +++++++++++++++++++++++++++++++-
 include/keys/system_keyring.h            | 13 +++++
 include/linux/key.h                      |  4 ++
 kernel/system_keyring.c                  | 85 ++++++++++++++++++++++++++++++++
 security/integrity/digsig.c              | 26 +++++++++-
 security/integrity/ima/Kconfig           |  8 +++
 security/integrity/ima/ima_appraise.c    | 11 +++++
 security/integrity/integrity.h           |  5 ++
 security/keys/key.c                      | 20 ++++++++
 security/keys/keyctl.c                   |  6 ++-
 10 files changed, 259 insertions(+), 4 deletions(-)

-- 
1.8.1.4

