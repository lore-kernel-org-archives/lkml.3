Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaDXJhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:37:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaDXIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vineet Gupta <vgupta@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 132/182] ARC: [nsimosci] Unbork console
Date: Thu, 24 Apr 2014 09:50:57 +0100
Message-Id: <1398329507-5911-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 61fb4bfc010b0d2940f7fd87acbce6a0f03217cb upstream.

Despite the switch to right UART driver (prev patch), serial console
still doesn't work due to missing CONFIG_SERIAL_OF_PLATFORM

Also fix the default cmdline in DT to not refer to out-of-tree
ARC framebuffer driver for console.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arc/boot/dts/nsimosci.dts      | 5 ++++-
 arch/arc/configs/nsimosci_defconfig | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arc/boot/dts/nsimosci.dts b/arch/arc/boot/dts/nsimosci.dts
index 8bd238c..4f31b2e 100644
--- a/arch/arc/boot/dts/nsimosci.dts
+++ b/arch/arc/boot/dts/nsimosci.dts
@@ -17,7 +17,10 @@
 	interrupt-parent = <&intc>;
 
 	chosen {
-		bootargs = "console=tty0 consoleblank=0";
+		/* this is for console on PGU */
+		/* bootargs = "console=tty0 consoleblank=0"; */
+		/* this is for console on serial */
+		bootargs = "earlycon=uart8250,mmio32,0xc0000000,115200n8 console=ttyS0,115200n8 consoleblank=0 debug";
 	};
 
 	aliases {
diff --git a/arch/arc/configs/nsimosci_defconfig b/arch/arc/configs/nsimosci_defconfig
index 451af30..c01ba35 100644
--- a/arch/arc/configs/nsimosci_defconfig
+++ b/arch/arc/configs/nsimosci_defconfig
@@ -54,6 +54,7 @@ CONFIG_SERIO_ARC_PS2=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_DW=y
+CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_SERIAL_ARC=y
 CONFIG_SERIAL_ARC_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
-- 
1.9.1

