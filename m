Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbbAIPKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:10:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbbAIPKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:10:16 -0500
From: Michal Marek <mmarek@suse.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-dev-en@lists.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tomoyo: Use bin2c to generate builtin-policy.h
Date: Fri,  9 Jan 2015 16:08:52 +0100
Message-Id: <1420816134-12758-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420816134-12758-1-git-send-email-mmarek@suse.cz>
References: <1420816134-12758-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 security/tomoyo/Kconfig  |  1 +
 security/tomoyo/Makefile | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/security/tomoyo/Kconfig b/security/tomoyo/Kconfig
index 8eb779b9d..f22d115 100644
--- a/security/tomoyo/Kconfig
+++ b/security/tomoyo/Kconfig
@@ -5,6 +5,7 @@ config SECURITY_TOMOYO
 	select SECURITYFS
 	select SECURITY_PATH
 	select SECURITY_NETWORK
+	select BUILD_BIN2C
 	default n
 	help
 	  This selects TOMOYO Linux, pathname-based access control.
diff --git a/security/tomoyo/Makefile b/security/tomoyo/Makefile
index 56a0c7b..a6c02a5 100644
--- a/security/tomoyo/Makefile
+++ b/security/tomoyo/Makefile
@@ -29,20 +29,20 @@ $(obj)/policy/stat.conf:
 $(obj)/builtin-policy.h: $(obj)/policy/profile.conf $(obj)/policy/exception_policy.conf $(obj)/policy/domain_policy.conf $(obj)/policy/manager.conf $(obj)/policy/stat.conf
 	@echo Generating built-in policy for TOMOYO 2.5.x.
 	@echo "static char tomoyo_builtin_profile[] __initdata =" > $@.tmp
-	@sed -e 's/\\/\\\\/g' -e 's/\"/\\"/g' -e 's/\(.*\)/"\1\\n"/' < $(obj)/policy/profile.conf >> $@.tmp
-	@echo "\"\";" >> $@.tmp
+	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/profile.conf >> $@.tmp
+	@echo ";" >> $@.tmp
 	@echo "static char tomoyo_builtin_exception_policy[] __initdata =" >> $@.tmp
-	@sed -e 's/\\/\\\\/g' -e 's/\"/\\"/g' -e 's/\(.*\)/"\1\\n"/' < $(obj)/policy/exception_policy.conf >> $@.tmp
-	@echo "\"\";" >> $@.tmp
+	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/exception_policy.conf >> $@.tmp
+	@echo ";" >> $@.tmp
 	@echo "static char tomoyo_builtin_domain_policy[] __initdata =" >> $@.tmp
-	@sed -e 's/\\/\\\\/g' -e 's/\"/\\"/g' -e 's/\(.*\)/"\1\\n"/' < $(obj)/policy/domain_policy.conf >> $@.tmp
-	@echo "\"\";" >> $@.tmp
+	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/domain_policy.conf >> $@.tmp
+	@echo ";" >> $@.tmp
 	@echo "static char tomoyo_builtin_manager[] __initdata =" >> $@.tmp
-	@sed -e 's/\\/\\\\/g' -e 's/\"/\\"/g' -e 's/\(.*\)/"\1\\n"/' < $(obj)/policy/manager.conf >> $@.tmp
-	@echo "\"\";" >> $@.tmp
+	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/manager.conf >> $@.tmp
+	@echo ";" >> $@.tmp
 	@echo "static char tomoyo_builtin_stat[] __initdata =" >> $@.tmp
-	@sed -e 's/\\/\\\\/g' -e 's/\"/\\"/g' -e 's/\(.*\)/"\1\\n"/' < $(obj)/policy/stat.conf >> $@.tmp
-	@echo "\"\";" >> $@.tmp
+	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/stat.conf >> $@.tmp
+	@echo ";" >> $@.tmp
 	@mv $@.tmp $@
 
 $(obj)/common.o: $(obj)/builtin-policy.h
-- 
2.1.2

