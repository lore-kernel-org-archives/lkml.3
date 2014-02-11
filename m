Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaBKNFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:05:35 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39619 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaBKNET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:19 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-b2-52fa1fd29325
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 12/14] Documentation: mfd/regulator: s2mps11: Document the
 "op_mode" bindings
Date: Tue, 11 Feb 2014 14:03:55 +0100
Message-id: <1392123837-5517-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xK7qX5H8FGbx7J2OxccZ6VoupD5+w
	WVz/8pzVYv6Rc6wW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaPHtSgeTxeVdc9gsZpzfx2Sx
	9shddoul1y8yWUyYvpbFonXvEXaL092sFhdXfGGyWD/jNYuDsMeaeWsYPS739TJ57Jx1l91j
	5fIvbB6bVnWyedy5tofNY97JQI++LasYPT5vkgvgjOKySUnNySxLLdK3S+DK2HO7m6ngrVjF
	7PNdjA2M+4W6GDk4JARMJBYd0exi5AQyxSQu3FvPBhIWEljKKLHXt4uRC8jsY5L403WNBaSG
	TcBYYvPyJWwgCRGBzYwSi79fZQVxmAU2sUjMXXWXDaRKWCBeYsbstewgNouAqsT9abPAbF4B
	d4lTa2+yQSxWkJgzyQYkzAkU7vv0H2qxm8Ty/tgJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfm
	pesl5+duYoSE+pcdjIuPWR1iFOBgVOLh3aD4M0iINbGsuDL3EKMEB7OSCO8X4V9BQrwpiZVV
	qUX58UWlOanFhxiZODilGhj59sWX1dxuYOhwDjy1YLPUGYNfSXLPG521jwhuz399qPne5OPn
	jbUyWxgOuKp5bP9lZ1I3/ecP5yenq6OPLTiv6S0pvaPd+UbNNNVbV/Yk3bhvHPKVP2lG+6rO
	F0ELJmzraGHStlxd57UlqY/pskDeUuE3jLv3n7j+/b/GWoa9uvcOBbxK3uuqxFKckWioxVxU
	nAgANvDbcVMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the "op_mode" properties parsed from DTS by s2mps11 driver.

S2MPS11/S2MPS14 regulators support different modes of operation:
 - Always off;
 - On/Off controlled by pin/GPIO (PWREN/LDOEN/EMMCEN);
 - Always on;

This is very similar to S5M8767 regulator driver which also supports
opmodes (although S5M8767 have also low-power mode).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt |   46 +++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index f69bec294f02..ffad6bfe2ebf 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -54,6 +54,15 @@ BUCK[3, 4], and BUCK[7, 8, 10]
 The regulator constraints inside the regulator nodes use the standard regulator
 bindings which are documented elsewhere.
 
+On S2MPS14 chipset the driver additionally supports "op_mode" properties for
+each regulator.
+ - op_mode: describes the different operating modes of the regulators with
+	power mode change in SOC. The different possible values are,
+		0 - always off mode
+		1 - on in normal mode
+		3 - suspend mode
+		(NOTE: value of 2 is reserved)
+
 The following are the names of the regulators that the s2mps11 pmic block
 supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
 as per the datasheet of s2mps11.
@@ -112,3 +121,40 @@ Example:
 			};
 		};
 	};
+
+	s2mps14_pmic@66 {
+		compatible = "samsung,s2mps14-pmic";
+		reg = <0x66>;
+
+		s2m_osc: clocks {
+			compatible = "samsung,s2mps14-clk";
+			#clock-cells = 1;
+			clock-output-names = "xx", "", "zz";
+		};
+
+		regulators {
+			ldo1_reg: LDO1 {
+				regulator-name = "VAP_ALIVE_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+				op_mode = <1>; /* Normal Mode */
+			};
+
+			ldo2_reg: LDO2 {
+				regulator-name = "VAP_M1_1.2V";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				op_mode = <1>; /* Normal Mode */
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "VAP_MIF_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+				op_mode = <3>; /* Standby Mode */
+			};
+		};
+	};
-- 
1.7.9.5

