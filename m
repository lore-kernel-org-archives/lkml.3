Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaA3Lql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 06:46:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51729 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaA3Lqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 06:46:39 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <robh+dt@kernel.org>, <galak@codeaurora.org>
CC: <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH] ARM: keystone: dts: disable "msmcsram" clock
Date: Thu, 30 Jan 2014 13:45:43 +0200
Message-ID: <1391082343-13371-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At late init all unused clocks are disabled. So clocks that were not
get before will be gated. In Keysone 2 SoC we have at least one
necessary clock that is not used by any driver - "msmcsram". This
clock is necessary, because it supplies the Multicore Shared Memory
Controller (MSMC). The MSMC provides memory protection for accesses to
the MSMC SRAM and DDR3 memory from system masters. It also manages
traffic among mastering peripherals and the EMIF.

This means that MSMC clock is always needed by SoC and cannot be gated.
It is only one from necessary clocks that was not used by any driver.
So to avoid its gating at late init we have to disable it in DT.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/keystone-clocks.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/keystone-clocks.dtsi b/arch/arm/boot/dts/keystone-clocks.dtsi
index 2363593..e7aea2e 100644
--- a/arch/arm/boot/dts/keystone-clocks.dtsi
+++ b/arch/arm/boot/dts/keystone-clocks.dtsi
@@ -332,6 +332,7 @@ clocks {
 		compatible = "ti,keystone,psc-clock";
 		clocks = <&chipclk1>;
 		clock-output-names = "msmcsram";
+		status = "disabled";
 		reg = <0x02350038 0xb00>, <0x0235001c 0x400>;
 		reg-names = "control", "domain";
 		domain-id = <7>;
-- 
1.8.3.2

