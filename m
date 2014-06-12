Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbaFLKeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:34:11 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:51887 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443AbaFLKeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:34:05 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 9/9] serial/arc: Add DT based earlycon support
Date: Thu, 12 Jun 2014 16:01:39 +0530
Message-ID: <1402569099-9900-10-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/boot/dts/angel4.dts  | 3 ++-
 drivers/tty/serial/arc_uart.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
index 6b57475967a6..e9fc270d1e0b 100644
--- a/arch/arc/boot/dts/angel4.dts
+++ b/arch/arc/boot/dts/angel4.dts
@@ -17,7 +17,8 @@
 	interrupt-parent = <&intc>;
 
 	chosen {
-		bootargs = "earlycon=arc_uart,mmio32,0xc0fc1000,115200n8 console=ttyARC0,115200n8";
+		bootargs = "earlycon console=ttyARC0,115200n8";
+		stdout-path = &arcuart0;
 	};
 
 	aliases {
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 435de4f2af3b..d9900cb3e7b6 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -579,6 +579,7 @@ static int __init arc_early_console_setup(struct earlycon_device *dev,
 	return 0;
 }
 EARLYCON_DECLARE(arc_uart, arc_early_console_setup);
+OF_EARLYCON_DECLARE(arc_uart, "snps,arc-uart", arc_early_console_setup);
 
 #endif	/* CONFIG_SERIAL_ARC_CONSOLE */
 
-- 
1.8.3.2

