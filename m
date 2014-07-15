Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaGORMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:14 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53467 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaGORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:19 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 66/94] m68k: Export mach_random_get_entropy to modules
Date: Tue, 15 Jul 2014 20:01:21 +0300
Message-Id: <1405443709-15288-66-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

When a module calls random_get_entropy():

    ERROR: "mach_random_get_entropy" [crypto/drbg.ko] undefined!
    make[1]: *** [__modpost] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/m68k/kernel/time.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 958f1ad..3857737 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
@@ -30,6 +31,7 @@
 
 
 unsigned long (*mach_random_get_entropy)(void);
+EXPORT_SYMBOL_GPL(mach_random_get_entropy);
 
 
 /*
-- 
1.7.10.4

