Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaKRMXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:23:25 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33921 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaKRMXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:23:20 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 07/14] of: document external-memory-controller property in tegra124-car
Date: Tue, 18 Nov 2014 13:13:09 +0100
Message-Id: <1416312860-4446-8-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property contains a phandle to the EMC driver that is needed by the
EMC clock to request the EMC driver to do its part of the clock change
sequence.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
index 2197ffd..a7000db 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
@@ -18,6 +18,7 @@ Required properties :
 - #reset-cells : Should be 1.
   In clock consumers, this cell represents the bit number in the CAR's
   array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
+- nvidia,external-memory-controller : phandle of the EMC driver.
 
 The node should contain a "emc-timings" subnode for each supported RAM type (see
 field RAM_CODE in register PMC_STRAPPING_OPT_A).
@@ -48,6 +49,7 @@ Example SoC include file:
 		reg = <0x60006000 0x1000>;
 		#clock-cells = <1>;
 		#reset-cells = <1>;
+		nvidia,external-memory-controller = <&emc>;
 	};
 
 	usb@c5004000 {
-- 
1.9.3

