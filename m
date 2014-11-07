Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaKGLsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:48:22 -0500
Received: from dotsec.net ([62.75.224.215]:54073 "EHLO styx.dotsec.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaKGLsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:48:19 -0500
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Alban Bedel <albeu@free.fr>
Subject: [PATCH 2/2] MIPS: ath79: Read the initrd address from the firmware environment
Date: Fri,  7 Nov 2014 12:44:36 +0100
Message-Id: <1415360676-28064-2-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1415360676-28064-1-git-send-email-albeu@free.fr>
References: <1415360676-28064-1-git-send-email-albeu@free.fr>
X-SA-Score: -1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow loading an initrd passed by the firmware.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
 arch/mips/ath79/prom.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/mips/ath79/prom.c b/arch/mips/ath79/prom.c
index 80a0bff..e1fe630 100644
--- a/arch/mips/ath79/prom.c
+++ b/arch/mips/ath79/prom.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/string.h>
+#include <linux/initrd.h>
 
 #include <asm/bootinfo.h>
 #include <asm/addrspace.h>
@@ -23,6 +24,13 @@
 void __init prom_init(void)
 {
 	fw_init_cmdline();
+
+	/* Read the initrd address from the firmware environment */
+	initrd_start = fw_getenvl("initrd_start");
+	if (initrd_start) {
+		initrd_start = KSEG0ADDR(initrd_start);
+		initrd_end = initrd_start + fw_getenvl("initrd_size");
+	}
 }
 
 void __init prom_free_prom_memory(void)
-- 
2.0.0

