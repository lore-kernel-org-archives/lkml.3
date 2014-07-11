Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaGKKXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:23:08 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:18108 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751897AbaGKKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:23:07 -0400
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>, <boris.brezillon@free-electrons.com>,
        <jiri.prchal@aksignal.cz>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] ARM: at91: at91sam9x5: add clocks for usb device
Date: Fri, 11 Jul 2014 18:22:55 +0800
Message-ID: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clocks for usb device, or else switch to CCF, the gadget
won't work.

Reported-by: Jiří Prchal <jiri.prchal@aksignal.cz>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index d6133f4..2ebc421 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -1045,6 +1045,8 @@
 				reg = <0x00500000 0x80000
 				       0xf803c000 0x400>;
 				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&usb>, <&udphs_clk>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 
 				ep0 {
-- 
1.8.5.2

