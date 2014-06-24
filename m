Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaFXOlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:41:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35039 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaFXOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:41:04 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH v6 0/6] ima: extending secure boot certificate chain of trust
Date: Tue, 24 Jun 2014 10:40:46 -0400
Message-Id: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062414-1344-0000-0000-00000264AC50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original patches extended the secure boot signature chain of trust
to IMA-appraisal, by allowing only certificates signed by a 'trusted'
key on the system_trusted_keyring to be added to the IMA keyring.

Instead of allowing public keys, with certificates signed by any key
on the system trusted keyring, to be added to a trusted keyring, this
patch set further restricts the certificates to those signed by a
particular key, or the builtin keys, on the system keyring.

Other than the "KEYS: validate certificate trust only with builtin keys"
patch, which is included in this patch set for completeness, but can be
deferred until the UEFI key patches are upstreamed, these patches are
ready to be upstreamed.  David, how do you want to go forward with
this patchset.  Did you want to take them?

thanks,

Mimi

Dmitry Kasatkin (3):
  KEYS: make partial key id matching as a dedicated function
  KEYS: validate certificate trust only with selected owner key
  KEYS: validate certificate trust only with builtin keys

Mimi Zohar (3):
  KEYS: special dot prefixed keyring name bug fix
  KEYS: verify a certificate is signed by a 'trusted' key
  ima: define '.ima' as a builtin 'trusted' keyring

 Documentation/kernel-parameters.txt      |   5 ++
 crypto/asymmetric_keys/asymmetric_keys.h |   2 +
 crypto/asymmetric_keys/asymmetric_type.c |  51 +++++++++------
 crypto/asymmetric_keys/x509_public_key.c | 109 ++++++++++++++++++++++++++++++-
 include/keys/system_keyring.h            |  10 ++-
 include/linux/key.h                      |   1 +
 kernel/system_keyring.c                  |   1 +
 security/integrity/digsig.c              |  28 ++++++++
 security/integrity/ima/Kconfig           |  10 +++
 security/integrity/ima/ima.h             |  12 ++++
 security/integrity/ima/ima_main.c        |  10 ++-
 security/integrity/integrity.h           |   5 ++
 security/keys/keyctl.c                   |   6 +-
 13 files changed, 225 insertions(+), 25 deletions(-)

-- 
1.8.1.4

