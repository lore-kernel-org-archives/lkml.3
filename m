Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaJASnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:43:14 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35335 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaJASnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:43:09 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 1/4] integrity: add missing '__init' keyword for integrity_init_keyring()
Date: Wed,  1 Oct 2014 21:43:07 +0300
Message-Id: <67d079341460adba5732d593fc856116ad55e626.1412188590.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

integrity_init_keyring() is used only from kernel '__init'
functions. Add it there as well.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/digsig.c    | 2 +-
 security/integrity/integrity.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 8d4fbff..4f643d1 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -63,7 +63,7 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 	return -EOPNOTSUPP;
 }
 
-int integrity_init_keyring(const unsigned int id)
+int __init integrity_init_keyring(const unsigned int id)
 {
 	const struct cred *cred = current_cred();
 	int err = 0;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index c0379d1..aafb468 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -129,7 +129,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
-int integrity_init_keyring(const unsigned int id);
+int __init integrity_init_keyring(const unsigned int id);
 #else
 
 static inline int integrity_digsig_verify(const unsigned int id,
-- 
1.9.1

