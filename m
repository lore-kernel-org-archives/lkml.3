Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaH1OzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:55:16 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:39783 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbaH1OzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:55:11 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH 2/4] ARM: DT: APQ8064: Add node for ps_hold function in pinctrl
Date: Thu, 28 Aug 2014 20:22:48 -0700
Message-Id: <1409282570-27299-3-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409282570-27299-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409282570-27299-1-git-send-email-pramod.gurav@smartplayin.com>
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
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index e23303e..35c1907 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -82,6 +82,16 @@
 			interrupt-controller;
 			#interrupt-cells = <2>;
 			interrupts = <0 16 IRQ_TYPE_LEVEL_HIGH>;
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
1.7.0.4

