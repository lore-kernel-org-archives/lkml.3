Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbaKPAWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:22:37 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35942 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaKPATl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:41 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 13/22] MIPS: Allow MIPS_CPU_SCACHE to be used with different line sizes
Date: Sat, 15 Nov 2014 16:17:37 -0800
Message-Id: <1416097066-20452-14-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MIPS_CPU_SCACHE determines whether to build sc-mips.c.  However,
it is currently hardwired to use an L1_SHIFT of 6 (64 bytes).  Move the
L1_SHIFT selection into the CPU or SoC section so that other SoCs can
select different values.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 92033b7..3d56928 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -326,6 +326,7 @@ config MIPS_MALTA
 	select I8259
 	select MIPS_BONITO64
 	select MIPS_CPU_SCACHE
+	select MIPS_L1_CACHE_SHIFT_6
 	select PCI_GT64XXX_PCI0
 	select MIPS_MSC
 	select SWAP_IO_SPACE
@@ -1909,7 +1910,6 @@ config IP22_CPU_SCACHE
 config MIPS_CPU_SCACHE
 	bool
 	select BOARD_SCACHE
-	select MIPS_L1_CACHE_SHIFT_6
 
 config R5000_CPU_SCACHE
 	bool
-- 
2.1.1

