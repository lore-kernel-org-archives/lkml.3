Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaIHVBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:01:11 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60594 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbaIHVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:01:10 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] openrisc: Support both old (or32) and new (or1k) toolchain
Date: Mon,  8 Sep 2014 14:00:49 -0700
Message-Id: <1410210049-30800-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output file format for openrisc has changed from "elf32-or32"
to "elf32-or1k" when using the or1k instead of the older or32 toochain.
Select the correct output format automatically to be able to compile
the kernel with both toolchain variants.

Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Candidate for -stable ?

 arch/openrisc/kernel/vmlinux.lds.S | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/openrisc/kernel/vmlinux.lds.S b/arch/openrisc/kernel/vmlinux.lds.S
index 2d69a85..1c5d21a 100644
--- a/arch/openrisc/kernel/vmlinux.lds.S
+++ b/arch/openrisc/kernel/vmlinux.lds.S
@@ -30,7 +30,13 @@
 #include <asm/cache.h>
 #include <asm-generic/vmlinux.lds.h>
 
-OUTPUT_FORMAT("elf32-or32", "elf32-or32", "elf32-or32")
+#ifdef __OR1K__
+#define __OUTPUT_FORMAT	"elf32-or1k"
+#else
+#define __OUTPUT_FORMAT	"elf32-or32"
+#endif
+
+OUTPUT_FORMAT(__OUTPUT_FORMAT, __OUTPUT_FORMAT, __OUTPUT_FORMAT)
 jiffies = jiffies_64 + 4;
 
 SECTIONS
-- 
1.9.1

