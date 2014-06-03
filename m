Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaFCR6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:58:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52891 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaFCR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:58:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v5 0/4] ima: extending secure boot certificate chain of trust
Date: Tue,  3 Jun 2014 13:58:34 -0400
Message-Id: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060317-8236-0000-0000-000002D41F5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original patches extended the secure boot signature chain of trust
to IMA-appraisal, by allowing only certificates signed by a 'trusted'
key on the system_trusted_keyring to be added to the IMA keyring.

Instead of allowing public keys, with certificates signed by any
key on the system trusted keyring, to be added to a trusted
keyring, the last patch in this patch set further restricts the
certificates to those signed by a particular key on the system keyring.
(This is a total rewrite of the previous version.)

All comments have been addressed aside from the issue of requiring
procfs for loading a key on the ima keyring.

Mimi

Mimi Zohar (4):
  KEYS: special dot prefixed keyring name bug fix
  KEYS: verify a certificate is signed by a 'trusted' key
  ima: define '.ima' as a builtin 'trusted' keyring
  KEYS: define an owner trusted keyring

 Documentation/kernel-parameters.txt      |  5 ++
 crypto/asymmetric_keys/x509_public_key.c | 86 +++++++++++++++++++++++++++++++-
 include/keys/owner_keyring.h             | 27 ++++++++++
 include/keys/system_keyring.h            | 10 +++-
 init/Kconfig                             | 10 ++++
 kernel/Makefile                          |  1 +
 kernel/owner_keyring.c                   | 85 +++++++++++++++++++++++++++++++
 security/integrity/digsig.c              | 26 ++++++++++
 security/integrity/ima/Kconfig           |  8 +++
 security/integrity/ima/ima_main.c        | 12 ++++-
 security/integrity/integrity.h           |  5 ++
 security/keys/keyctl.c                   |  6 ++-
 12 files changed, 275 insertions(+), 6 deletions(-)
 create mode 100644 include/keys/owner_keyring.h
 create mode 100644 kernel/owner_keyring.c

-- 
1.8.1.4

