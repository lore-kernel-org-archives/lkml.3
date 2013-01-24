Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007Ab3AXVVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:21:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422682Ab3AXVUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:20:52 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] MODSIGN: Add option to not sign modules during modules_install
Date: Thu, 24 Jan 2013 22:20:29 +0100
Message-Id: <1359062429-27295-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1359062429-27295-1-git-send-email-mmarek@suse.cz>
References: <1359062429-27295-1-git-send-email-mmarek@suse.cz>
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
No changes in v2

---
 Makefile     |    2 +-
 init/Kconfig |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 0e7e736..e2027b2 100644
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
1.7.8.3

