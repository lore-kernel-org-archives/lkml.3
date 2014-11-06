Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaKFRWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:22:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbaKFRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:22:20 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        <stable@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ARM: dts: zynq: Enable PL clocks for Parallella
Date: Thu,  6 Nov 2014 18:22:10 +0100
Message-Id: <1415294531-8942-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Parallella board comes with a U-Boot bootloader that loads one of
two predefined FPGA bitstreams before booting the kernel. Both define an
AXI interface to the on-board Epiphany processor.

Enable clocks FCLK0..FCLK3 for the Programmable Logic by default.

Otherwise accessing, e.g., the ESYSRESET register freezes the board,
as seen with the Epiphany SDK tools e-reset and e-hw-rev, using /dev/mem.

Cc: <stable@vger.kernel.org> # 3.17.x
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 Michal/Olof, please consider this trivial patch as a fix for 3.18.

 arch/arm/boot/dts/zynq-parallella.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
index e1f51ca127fe..0429bbd89fba 100644
--- a/arch/arm/boot/dts/zynq-parallella.dts
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -34,6 +34,10 @@
 	};
 };
 
+&clkc {
+	fclk-enable = <0xf>;
+};
+
 &gem0 {
 	status = "okay";
 	phy-mode = "rgmii-id";
-- 
2.1.2

