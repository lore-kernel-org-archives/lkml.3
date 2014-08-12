Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaHLQpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:45:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38298 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaHLQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:45:17 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 5/6] ARM: dts: Improve cros-tps65090 power scheme
Date: Tue, 12 Aug 2014 18:44:27 +0200
Message-Id: <1407861868-20097-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DeviceTree files for the Peach Pit and Pi machines have
a simplistic model of the connections between the different
regulators since not all the tps65090 regulators get their
input supply voltage from the VDC. DCDC1-3, LD0-1 and fet7
parent supply is indded VDC but the fet1-6 get their input
supply from the DCDC1 and DCDC2 output voltage rails.

Update the DeviceTree to better reflect the real connections
between tps65090 regulators. Having this information in the
DTS is useful since FETs are switches that don't provide an
output voltage so the regulator core needs to fetch the FET
parent output voltage if the child voltage is queried.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/cros-tps65090.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/cros-tps65090.dtsi b/arch/arm/boot/dts/cros-tps65090.dtsi
index 99df15e..14418b0 100644
--- a/arch/arm/boot/dts/cros-tps65090.dtsi
+++ b/arch/arm/boot/dts/cros-tps65090.dtsi
@@ -30,12 +30,12 @@
 	vsys2-supply = <&vbat>;
 	vsys3-supply = <&vbat>;
 	infet1-supply = <&vbat>;
-	infet2-supply = <&vbat>;
-	infet3-supply = <&vbat>;
-	infet4-supply = <&vbat>;
-	infet5-supply = <&vbat>;
-	infet6-supply = <&vbat>;
-	infet7-supply = <&vbat>;
+	infet2-supply = <&tps65090_dcdc1>;
+	infet3-supply = <&tps65090_dcdc2>;
+	infet4-supply = <&tps65090_dcdc2>;
+	infet5-supply = <&tps65090_dcdc2>;
+	infet6-supply = <&tps65090_dcdc2>;
+	infet7-supply = <&tps65090_dcdc1>;
 	vsys-l1-supply = <&vbat>;
 	vsys-l2-supply = <&vbat>;
 };
-- 
2.0.0.rc2

