Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaLAXVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:21:23 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64378 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaLAXVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:21:09 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 16/16] metag: tz1090: connect Meta core clock
Date: Mon,  1 Dec 2014 23:20:06 +0000
Message-Id: <1417476006-10407-17-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Connect the Meta core clock to the root DT node so that the precise rate
of the Meta timer can be determined.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: linux-metag@vger.kernel.org
Cc: devicetree@vger.kernel.org
---
Changes since v1 (patch 15):
- Split out linking of Meta core clock in DT into this new patch.
---
 arch/metag/boot/dts/tz1090.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index 48aa8b1..9b37642 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -16,6 +16,9 @@
 
 	interrupt-parent = <&intc>;
 
+	clocks = <&top_clks CLK_TOP_META>;
+	clock-names = "core";
+
 	intc: interrupt-controller {
 		compatible = "img,meta-intc";
 		interrupt-controller;
-- 
2.0.4

