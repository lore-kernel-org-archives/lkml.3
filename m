Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaDRJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:26:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46061 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbaDRJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 71/72] ARC: [nsimosci] Unbork console
Date: Fri, 18 Apr 2014 11:22:44 +0200
Message-Id: <9fc22da2d59cfdfd15655a97d54269d910471c31.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 61fb4bfc010b0d2940f7fd87acbce6a0f03217cb upstream.

Despite the switch to right UART driver (prev patch), serial console
still doesn't work due to missing CONFIG_SERIAL_OF_PLATFORM

Also fix the default cmdline in DT to not refer to out-of-tree
ARC framebuffer driver for console.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Francois Bedard <Francois.Bedard@synopsys.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
1.9.2

