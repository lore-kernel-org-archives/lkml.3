Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaDENJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 09:09:59 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:39987 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaDENJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 09:09:56 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: <arc-linux-dev@synopsys.com>, <stable@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH Resend 2/2] ARC: [nsimosci] Unbork console
Date: Sat, 5 Apr 2014 18:39:11 +0530
Message-ID: <1396703351-8423-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396703351-8423-1-git-send-email-vgupta@synopsys.com>
References: <1396703351-8423-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.226]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite the switch to right UART driver (prev patch), serial console
still doesn't work due to missing CONFIG_SERIAL_OF_PLATFORM

Also fix the default cmdline in DT to not refer to out-of-tree
ARC framebuffer driver for console.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: <stable@vger.kernel.org>   #3.10, 3.12, 3.13, 3.14
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
---
 arch/arc/boot/dts/nsimosci.dts      | 5 ++++-
 arch/arc/configs/nsimosci_defconfig | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arc/boot/dts/nsimosci.dts b/arch/arc/boot/dts/nsimosci.dts
index 8bd238c34c7d..4f31b2eb5cdf 100644
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
index 451af30914f6..c01ba35a4eff 100644
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
1.8.3.2

