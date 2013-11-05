Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3KEAGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:06:48 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5013 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3KEAGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:06:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 04 Nov 2013 16:01:31 -0800
From: Eric Miao <eric.miao@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: Eric Miao <eric.miao@nvidia.com>, David Howells <dhowells@redhat.com>,
        "Dan Willemsen" <dwillemsen@nvidia.com>
Subject: [PATCH 2/2] MODSIG: use pre-generated X.509 key by MODPUBKEY
Date: Mon, 4 Nov 2013 16:06:35 -0800
Message-ID: <1383609995-8251-2-git-send-email-eric.miao@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1383609995-8251-1-git-send-email-eric.miao@nvidia.com>
References: <1383609995-8251-1-git-send-email-eric.miao@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If MODPUBKEY is specified and other than default ./signing_key.x509, use
that key instead of generating one on-the-fly.

Signed-off-by: Eric Miao <eric.miao@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dan Willemsen <dwillemsen@nvidia.com>
---
 kernel/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce4755..66c7c32 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -165,6 +165,13 @@ ifndef CONFIG_MODULE_SIG_HASH
 $(error Could not determine digest type to use from kernel config)
 endif
 
+ifneq ($(MODPUBKEY),./signing_key.x509)
+signing_key.x509: $(MODPUBKEY)
+	@echo "###"
+	@echo "### Use pre-generated X.509 key pair for signing modules."
+	@echo "###"
+	cp -f $< $@
+else
 signing_key.priv signing_key.x509: x509.genkey
 	@echo "###"
 	@echo "### Now generating an X.509 key pair to be used for signing modules."
@@ -202,3 +209,4 @@ x509.genkey:
 	@echo >>x509.genkey "subjectKeyIdentifier=hash"
 	@echo >>x509.genkey "authorityKeyIdentifier=keyid"
 endif
+endif
-- 
1.8.4.1

