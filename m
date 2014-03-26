Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaCZAED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:04:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaCZAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:04:01 -0400
Date: Tue, 25 Mar 2014 17:03:48 -0700
From: tip-bot for Carlo Caione <tipbot@zytor.com>
Message-ID: <tip-8ff973a26763ef2f2d45c1649c618dfff528a502@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        carlo@caione.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, carlo@caione.org
In-Reply-To: <1395256879-8475-3-git-send-email-carlo@caione.org>
References: <1395256879-8475-3-git-send-email-carlo@caione.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ARM: sun7i/sun6i: dts: Add NMI irqchip support
Git-Commit-ID: 8ff973a26763ef2f2d45c1649c618dfff528a502
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ff973a26763ef2f2d45c1649c618dfff528a502
Gitweb:     http://git.kernel.org/tip/8ff973a26763ef2f2d45c1649c618dfff528a502
Author:     Carlo Caione <carlo@caione.org>
AuthorDate: Wed, 19 Mar 2014 20:21:18 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Mar 2014 01:00:50 +0100

ARM: sun7i/sun6i: dts: Add NMI irqchip support

This patch adds DTS entries for NMI controller as child of GIC.

Signed-off-by: Carlo Caione <carlo@caione.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Cc: mark.rutland@arm.com
Cc: hdegoede@redhat.com
Acked-by: maxime.ripard@free-electrons.com
Link: http://lkml.kernel.org/r/1395256879-8475-3-git-send-email-carlo@caione.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 8 ++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 5256ad9..eea6033 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -190,6 +190,14 @@
 		#size-cells = <1>;
 		ranges;
 
+		nmi_intc: interrupt-controller@01f00c0c {
+			compatible = "allwinner,sun6i-a31-sc-nmi";
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			reg = <0x01f00c0c 0x38>;
+			interrupts = <0 0 4>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun6i-a31-pinctrl";
 			reg = <0x01c20800 0x400>;
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 6f25cf5..7637f12 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -339,6 +339,14 @@
 		#size-cells = <1>;
 		ranges;
 
+		nmi_intc: interrupt-controller@01c00030 {
+			compatible = "allwinner,sun7i-a20-sc-nmi";
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			reg = <0x01c00030 0x0c>;
+			interrupts = <0 0 4>;
+		};
+
 		emac: ethernet@01c0b000 {
 			compatible = "allwinner,sun4i-a10-emac";
 			reg = <0x01c0b000 0x1000>;
