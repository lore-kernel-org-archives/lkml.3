Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaJTWEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:04:44 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52502 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaJTWEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:04:43 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Rob Landley <rob@landley.net>,
        Frank Rowand <frowand.list@gmail.com>, linux-kernel@vger.kernel.org,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] init: Remove CONFIG_INIT_FALLBACK
Date: Mon, 20 Oct 2014 15:04:36 -0700
Message-Id: <a6b3d86db6f5d19f7130b8dba2703dda68cb14d5.1413842560.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <20141020144448.59e2e067d632c70353296e56@linux-foundation.org>
References: <20141020144448.59e2e067d632c70353296e56@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_INIT_FALLBACK adds config bloat without an obvious use case
that makes it worth keeping around.  Delete it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Bring on the blame :)

 init/Kconfig | 16 ----------------
 init/main.c  |  5 -----
 2 files changed, 21 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index ebbd5846478e..e84c6423a2e5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1299,22 +1299,6 @@ source "usr/Kconfig"
 
 endif
 
-config INIT_FALLBACK
-	bool "Fall back to defaults if init= parameter is bad"
-	default y
-	help
-	  If enabled, the kernel will try the default init binaries if an
-	  explicit request from the init= parameter fails.
-
-	  This can have unexpected effects.  For example, booting
-	  with init=/sbin/kiosk_app will run /sbin/init or even /bin/sh
-	  if /sbin/kiosk_app cannot be executed.
-
-	  The default value of Y is consistent with historical behavior.
-	  Selecting N is likely to be more appropriate for most uses,
-	  especially on kiosks and on kernels that are indended to be
-	  run under the control of a script.
-
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
 	help
diff --git a/init/main.c b/init/main.c
index 2bd6105e5dc5..39dd52a3b78a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -960,13 +960,8 @@ static int __ref kernel_init(void *unused)
 		ret = run_init_process(execute_command);
 		if (!ret)
 			return 0;
-#ifndef CONFIG_INIT_FALLBACK
 		panic("Requested init %s failed (error %d).",
 		      execute_command, ret);
-#else
-		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
-		       execute_command, ret);
-#endif
 	}
 	if (!try_to_run_init_process("/sbin/init") ||
 	    !try_to_run_init_process("/etc/init") ||
-- 
1.9.3

