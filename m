Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaCVPvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 11:51:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63945 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaCVPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 11:51:03 -0400
From: behanw@converseincode.com
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] LLVMLinux: Change DWARF flag to support gcc and clang
Date: Sat, 22 Mar 2014 08:50:47 -0700
Message-Id: <1395503447-17003-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Both gcc (well, actually gnu as) and clang support the "-Wa,-gdwarf-2" option
(though clang does not support "-Wa,--gdwarf-2"). Since these flags are equivalent
in meaning, this patch uses the one which is better supported across compilers.

Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index ef779ec..dc88989 100644
--- a/Makefile
+++ b/Makefile
@@ -641,7 +641,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+= -g
-KBUILD_AFLAGS	+= -Wa,--gdwarf-2
+KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 
 ifdef CONFIG_DEBUG_INFO_REDUCED
-- 
1.8.3.2

