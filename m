Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaDNIMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:12:05 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47753 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaDNIJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:09:28 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b7-534b97b500d2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/4] Documentation: regulator: s2mps11: Document external GPIO
 control
Date: Mon, 14 Apr 2014 10:09:08 +0200
Message-id: <1397462949-22379-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7rbpnsHG1xStdg4Yz2rxdSHT9gs
	5h85x2rR/2Yhq8W5VysZLV6/MLQ42/SG3eL+16OMFt+udDBZXN41h81ixvl9TBZrj9xlt1h6
	/SKTxYTpa1ksWvceYbc43c1qcXHFFyaL9TNeszgIeayZt4bR43JfL5PHzll32T1WLv/C5rFp
	VSebx51re9g85p0M9OjbsorR4/MmuQDOKC6blNSczLLUIn27BK6M80/uMxX856nouP2JtYGx
	g7uLkZNDQsBEYmL/KRYIW0ziwr31bF2MXBxCAksZJZ5d38kK4fQxSSw9/5YZpIpNwFhi8/Il
	YFUiAjeYJSYu28UEkmAWeM4o8fR7OIgtLBAhMXHTdlYQm0VAVeL39H2MXYwcHLwC7hJ/NsdC
	bFOQWPZlLTNImFPAQ+LNTTaQsBBQxdffs5gmMPIuYGRYxSiaWppcUJyUnmukV5yYW1yal66X
	nJ+7iRES4l93MC49ZnWIUYCDUYmHl2OrZ7AQa2JZcWXuIUYJDmYlEd5tGV7BQrwpiZVVqUX5
	8UWlOanFhxiZODilGhj7Mn5p71qvLJ4m/OX3XCV/ee/7LwwKjB4I3VgScfn++pxcy62CMyWO
	XPhnsKxu2iGuHW8kf/JvvTLt9YxVE39n7ZKbdLJpwpRUNc47MkKNnCsN7gjl1OxeubX34J7W
	mTu9ldI/XzAt85kbb/fiwauEtHU7r064EZoRFBR18WIES6L+4rfa4QYJSizFGYmGWsxFxYkA
	kvcIeU8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for new property for controlling (enable/disable) some
of the S2MPS14 regulators by GPIO.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index 802e839b0829..d81ba30c0d8b 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -56,6 +56,20 @@ for a particular group of BUCKs. So provide same regulator-ramp-delay<value>.
 Grouping of BUCKs sharing ramp rate setting is as follow : BUCK[1, 6],
 BUCK[3, 4], and BUCK[7, 8, 10]
 
+On S2MPS14 the LDO10, LDO11 and LDO12 can be configured to external control
+over GPIO. To turn this feature on this property must be added to the regulator
+sub-node:
+	- samsung,ext-control-gpios: GPIO specifier for one GPIO
+		controlling this regulator (enable/disable);
+Example:
+	LDO12 {
+		regulator-name = "V_EMMC_2.8V";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		samsung,ext-control-gpios = <&gpk0 2 0>;
+	};
+
+
 The regulator constraints inside the regulator nodes use the standard regulator
 bindings which are documented elsewhere.
 
-- 
1.8.3.2

