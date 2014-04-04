Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaDDXOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:14:46 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:49003 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaDDXOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:14:41 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v2 1/5] ARM: zynq: DT: Add 'clock-latency' property
Date: Fri,  4 Apr 2014 16:14:12 -0700
Message-Id: <1396653256-28397-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
In-Reply-To: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify the 'clock-latency' property to avoid certain cpufreq governors
from refusing to work with the following error:
  ondemand governor failed, too long transition latency of HW, fallback to performance governor

Reported-by: Mike Looijmans <mike.looijmans@topic.nl>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Mike Looijmans <mike.looijmans@topic.nl>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
This is a fix from our vendor tree

Changes in v2:
 - This patch has been added

---
 arch/arm/boot/dts/zynq-7000.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 789d0bacc110..20a13cba65a3 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -24,6 +24,7 @@
 			device_type = "cpu";
 			reg = <0>;
 			clocks = <&clkc 3>;
+			clock-latency = <1000>;
 			operating-points = <
 				/* kHz    uV */
 				666667  1000000
-- 
1.9.1.1.gbb9f595

