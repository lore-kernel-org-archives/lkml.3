Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3J3O60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:58:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43226 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3J3O6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:58:23 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, <r.sricharan@ti.com>
CC: Benoit Cousson <bcousson@baylibre.com>
Subject: [PATCH V2 3/7] ARM: DTS: DRA: Add crossbar device binding
Date: Wed, 30 Oct 2013 20:27:16 +0530
Message-ID: <1383145040-15852-4-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
References: <1383145040-15852-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the irq crossbar device node.

There is a IRQ crossbar device in the soc, which
maps the irq requests from the peripherals to the
mpu interrupt controller's inputs. The Peripheral irq
requests are connected to only one crossbar
input and the output of the crossbar is connected to only one
controller's input line. The crossbar device is used to map
a peripheral input to a free mpu's interrupt controller line.

Cc: Benoit Cousson <bcousson@baylibre.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 [V2] Renamed the bindings as per Kumar Gala <galak@codeaurora.org>
      comments.

 arch/arm/boot/dts/dra7.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 5c1f929..008396f 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -701,4 +701,12 @@
 			clocks = <&dpll_usb_ck>;
 		};
 	};
+
+	crossbar_mpu: crossbar@4a020000 {
+		compatible = "ti,irq-crossbar";
+		reg = <0x4a002a48 0x130>;
+		ti,max-irqs = <160>;
+		ti,reg-size = <2>;
+		ti,irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
+	};
 };
-- 
1.7.9.5

