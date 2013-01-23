Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3AWPb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:31:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111Ab3AWPbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:31:08 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] MODSIGN: Add option to not sign modules during modules_install
Date: Wed, 23 Jan 2013 16:30:44 +0100
Message-Id: <1358955044-27407-5-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358955044-27407-1-git-send-email-mmarek@suse.cz>
References: <1358955044-27407-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow the builder to sign only a subset of modules, or to sign the
modules using a key that is not available on the build machine, add
CONFIG_MODULE_SIG_ALL. If this option is unset, no modules will be
signed during build. The default is 'y', to preserve the current
behavior.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile     |    2 +-
 init/Kconfig |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 860dc21..e3a00de 100644
--- a/Makefile
+++ b/Makefile
@@ -719,7 +719,7 @@ endif # INSTALL_MOD_STRIP
 export mod_strip_cmd
 
 
-ifeq ($(CONFIG_MODULE_SIG),y)
+ifdef CONFIG_MODULE_SIG_ALL
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
 export MODPUBKEY
diff --git a/init/Kconfig b/init/Kconfig
index ba7d1c1..d2db2e7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1602,6 +1602,17 @@ config MODULE_SIG_FORCE
 	  Reject unsigned modules or signed modules for which we don't have a
 	  key.  Without this, such modules will simply taint the kernel.
 
+config MODULE_SIG_ALL
+	bool "Automatically sign all modules"
+	default y
+	depends on MODULE_SIG
+	help
+	  Sign all modules during make modules_install. Without this option,
+	  modules must be signed manually, using the scripts/sign-file tool.
+
+comment "Do not forget to sign required modules with scripts/sign-file"
+	depends on MODULE_SIG_FORCE && !MODULE_SIG_ALL
+
 choice
 	prompt "Which hash algorithm should modules be signed with?"
 	depends on MODULE_SIG
-- 
1.7.10.4

