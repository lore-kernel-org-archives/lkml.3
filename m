Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3CKNNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:13:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab3CKNNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:13:06 -0400
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MODSIGN: Support for signing_key.{x509,priv} in the M= directory
Date: Mon, 11 Mar 2013 14:12:42 +0100
Message-Id: <1363007562-16166-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow for the module signing keypair to be supplied when building an
external module.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Makefile b/Makefile
index a05ea42..a0c5436 100644
--- a/Makefile
+++ b/Makefile
@@ -721,8 +721,13 @@ export mod_strip_cmd
 
 
 ifdef CONFIG_MODULE_SIG_ALL
+ifeq ($(KBUILD_EXTMOD),)
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
+else
+MODSECKEY = $(firstword $(wildcard $(KBUILD_EXTMOD)/signing_key.priv) ./signing_key.priv)
+MODPUBKEY = $(firstword $(wildcard $(KBUILD_EXTMOD)/signing_key.x509) ./signing_key.x509)
+endif
 export MODPUBKEY
 mod_sign_cmd = perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
 else
-- 
1.7.10.4

