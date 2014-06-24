Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaFXKfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:35:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54291 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752714AbaFXKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:35:25 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, p.zabel@pengutronix.de
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/12] Documentation: bindings: add reset bindings docs for Marvell Berlin SoCs
Date: Tue, 24 Jun 2014 12:35:11 +0200
Message-Id: <1403606121-6368-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the reset binding documentation to the SoC binding documentation as
the reset driver in Marvell Berlin SoC is part of the chip/system
control registers. This patch adds the required properties to configure
the reset controller.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/arm/marvell,berlin.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
index 94013a9a8769..32a1a8a652ad 100644
--- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -90,11 +90,21 @@ Required subnode-properties:
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

