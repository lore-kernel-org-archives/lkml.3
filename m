Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaIWK2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:28:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55849 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754322AbaIWK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:28:43 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/12] Documentation: bindings: add reset bindings docs for Marvell Berlin SoCs
Date: Tue, 23 Sep 2014 12:27:58 +0200
Message-Id: <1411468088-5702-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the reset binding documentation to the SoC binding documentation as
the reset driver in Marvell Berlin SoC is part of the chip/system
control registers. This patch adds the required properties to configure
the reset controller.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/devicetree/bindings/arm/marvell,berlin.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
index 904de5781f44..a99eb9eb14c0 100644
--- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -106,11 +106,21 @@ Required subnode-properties:
 - groups: a list of strings describing the group names.
 - function: a string describing the function used to mux the groups.
 
+* Reset controller binding
+
+A reset controller is part of the chip control registers set. The chip control
+node also provides the reset. The register set is not at the same offset between
+Berlin SoCs.
+
+Required property:
+- #reset-cells: must be set to 2
+
 Example:
 
 chip: chip-control@ea0000 {
 	compatible = "marvell,berlin2-chip-ctrl";
 	#clock-cells = <1>;
+	#reset-cells = <2>;
 	reg = <0xea0000 0x400>;
 	clocks = <&refclk>, <&externaldev 0>;
 	clock-names = "refclk", "video_ext0";
-- 
1.9.1

