Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaAINMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:12:19 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57007 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaAINMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:12:10 -0500
X-Nat-Received: from [202.181.97.72]:52895 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389273124.9117
To: akpm@linux-foundation.org, hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init: Fix possible format string bug.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201401092212.ABB30294.tJOHFFOFQVLOSM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 9 Jan 2014 22:12:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 09012014 #7285211, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8c8032d179af2aa3841c37d72c18002cd0ba7448 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 9 Jan 2014 21:57:53 +0900
Subject: [PATCH] init: Fix possible format string bug.

Use constant format string in case message changes.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 init/initramfs.c |    2 +-
 init/main.c      |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index a67ef9d..93b6139 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -583,7 +583,7 @@ static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
-		panic(err);	/* Failed to decompress INTERNAL initramfs */
+		panic("%s", err); /* Failed to decompress INTERNAL initramfs */
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
diff --git a/init/main.c b/init/main.c
index 98e3537..f333385 100644
--- a/init/main.c
+++ b/init/main.c
@@ -278,7 +278,7 @@ static int __init unknown_bootoption(char *param, char *val, const char *unused)
 		unsigned int i;
 		for (i = 0; envp_init[i]; i++) {
 			if (i == MAX_INIT_ENVS) {
-				panic_later = "Too many boot env vars at `%s'";
+				panic_later = "env";
 				panic_param = param;
 			}
 			if (!strncmp(param, envp_init[i], val - param))
@@ -290,7 +290,7 @@ static int __init unknown_bootoption(char *param, char *val, const char *unused)
 		unsigned int i;
 		for (i = 0; argv_init[i]; i++) {
 			if (i == MAX_INIT_ARGS) {
-				panic_later = "Too many boot init vars at `%s'";
+				panic_later = "init";
 				panic_param = param;
 			}
 		}
@@ -582,7 +582,8 @@ asmlinkage void __init start_kernel(void)
 	 */
 	console_init();
 	if (panic_later)
-		panic(panic_later, panic_param);
+		panic("Too many boot %s vars at `%s'", panic_later,
+		      panic_param);
 
 	lockdep_info();
 
-- 
1.7.1
