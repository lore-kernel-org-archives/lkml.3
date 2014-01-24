Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaAXNix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:38:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46309 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaAXNiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:38:21 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e9-52e26ccb0b91
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v3 2/2] regulator: s5m8767: Document new binding for Buck9 GPIO
 control
Date: Fri, 24 Jan 2014 14:37:58 +0100
Message-id: <1390570678-30686-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
References: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xK7qncx4FGcyZy2KxccZ6VoupD5+w
	Wcw/co7V4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CxmnN/HZLH2yF12i5N/ehktTnezWlxc
	8YXJgddj56y77B6bVnWyedy5tofNY97JQI++LasYPT5vkgtgi+KySUnNySxLLdK3S+DK+LPv
	LWNBN3/FznmnGBsY1/F0MXJySAiYSDTdfcEOYYtJXLi3nq2LkYtDSGApo8Ti/3+gnD4mia57
	zWBVbALGEpuXLwFLiAgcZJI4+r0HzGEWOMoosb31BQtIlbBApMSk+ZuYQWwWAVWJxVNWM4HY
	vALuEtuenweKcwDtU5CYM8kGxOQU8JC4cksGpEIIqGLa2+vMExh5FzAyrGIUTS1NLihOSs81
	1CtOzC0uzUvXS87P3cQICcsvOxgXH7M6xCjAwajEwzsj8GGQEGtiWXFl7iFGCQ5mJRHerQGP
	goR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwpk6aoLMxiu9kcQb3K5HTkmdc7sqd5laa3fQ3hKHn
	2kPGEOUzBe+3rFRT1at8eXZzueqt048Tds/0XC2x+1vvwwmS/0LWaXleNN1/fypLUDHHsdqe
	lMseOdf3/ctreX7S88VLo+SoW6cj/WOYOerv+k33evrT68mB4un914JWKJqquV42W2V9XYml
	OCPRUIu5qDgRAH/quI4pAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for new binding for controlling (enable/disable) the
Buck9 Converter by GPIO (BUCK9EN).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 .../bindings/regulator/s5m8767-regulator.txt       |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
index fc6b38f035bd..d290988ed975 100644
--- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -69,13 +69,16 @@ sub-node should be of the format as listed below.
 		};
 	};
 The above regulator entries are defined in regulator bindings documentation
-except op_mode description.
+except these properties:
 	- op_mode: describes the different operating modes of the LDO's with
 		power mode change in SOC. The different possible values are,
 		0 - always off mode
 		1 - on in normal mode
 		2 - low power mode
 		3 - suspend mode
+	- s5m8767,pmic-ext-control-gpios: (optional) GPIO specifier for one
+		GPIO controlling this regulator (enable/disable); This is
+		valid only for buck9.
 
 The following are the names of the regulators that the s5m8767 pmic block
 supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
@@ -148,5 +151,13 @@ Example:
 				regulator-always-on;
 				regulator-boot-on;
 			};
+
+			vemmc_reg: BUCK9 {
+				regulator-name = "VMEM_VDD_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				op_mode = <3>; /* Standby Mode */
+				s5m8767,pmic-ext-control-gpios = <&gpk0 2 0>;
+			};
 		};
 	};
-- 
1.7.9.5

