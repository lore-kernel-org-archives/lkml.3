Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaLYR6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 12:58:01 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33878 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaLYR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 12:57:22 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jaedon.shin@gmail.com, abrestic@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V6 14/25] MIPS: Reorder MIPS_L1_CACHE_SHIFT priorities
Date: Thu, 25 Dec 2014 09:49:09 -0800
Message-Id: <1419529760-9520-15-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
References: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling support for more than one BMIPS CPU in the same build may
result in different L1_CACHE_SHIFT values, e.g.

    CPU_BMIPS5000 selects MIPS_L1_CACHE_SHIFT_7
    CPU_BMIPS4380 selects MIPS_L1_CACHE_SHIFT_6
    anything else defaults to MIPS_L1_CACHE_SHIFT_5

Ensure that if more than one MIPS_L1_CACHE_SHIFT_x option is selected,
Kconfig sets CONFIG_MIPS_L1_CACHE_SHIFT to the highest value.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 31bbec0..d28c29e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1193,10 +1193,10 @@ config MIPS_L1_CACHE_SHIFT_7
 
 config MIPS_L1_CACHE_SHIFT
 	int
-	default "4" if MIPS_L1_CACHE_SHIFT_4
-	default "5" if MIPS_L1_CACHE_SHIFT_5
-	default "6" if MIPS_L1_CACHE_SHIFT_6
 	default "7" if MIPS_L1_CACHE_SHIFT_7
+	default "6" if MIPS_L1_CACHE_SHIFT_6
+	default "5" if MIPS_L1_CACHE_SHIFT_5
+	default "4" if MIPS_L1_CACHE_SHIFT_4
 	default "5"
 
 config HAVE_STD_PC_SERIAL_PORT
-- 
2.1.1

