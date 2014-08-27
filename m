Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbaH0Jkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:40:33 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:34718 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756215AbaH0Jka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:40:30 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] ARM: DT: APQ8064: Add node for ps_hold function in pinctrl
Date: Wed, 27 Aug 2014 15:13:54 +0530
Message-Id: <1409132634-15208-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409132634-15208-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409132634-15208-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT support to configure GPIO_78 as function ps_hold
on apq8064.

CC: Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 681e194..0873b24 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -82,6 +82,16 @@
 			interrupt-controller;
 			#interrupt-cells = <2>;
 			interrupts = <0 32 0x4>;
+
+			pinctrl-names = "default";
+			pinctrl-0 = <&ps_hold>;
+
+			ps_hold: ps_hold {
+				mux {
+					pins = "gpio78";
+					function = "ps_hold";
+				};
+			};
 		};
 
 		intc: interrupt-controller@2000000 {
-- 
1.7.9.5

