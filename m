Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbaKUNo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:44:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14841 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbaKUNoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:44:25 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-41-546f41b699ee
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 01/11] pinctrl: exynos: Add BUS1 pin controller for exynos7
Date: Fri, 21 Nov 2014 19:05:44 +0530
Message-id: <1416576954-11997-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkSnebY36Iwak/NhYH79dbzD9yjtWi
	7cpBdovmxevZLHoXXGWzuPC0h81iyp/lTBaXd81hs5i9pJ/FYsb5fUwWi5a1Mlu07j3CbnH4
	TTurxYTfF9gsVu36w+jA77Fz1l12j02rOtk87lzbw+axf+4ado/Zd38wevRtWcXocfzGdiaP
	z5vkAjiiuGxSUnMyy1KL9O0SuDLau26zF9ziqbg18xlLA+NTri5GTg4JAROJYy8a2CBsMYkL
	99YD2VwcQgJLGSVeTFnNClPUdH4jC4gtJDCdUeLudKiiCUwSE2eeYwJJsAnoSjS93cUIYosI
	zGaUaDsoBFLELNDFJPFu6SGwFcIC3hIXlv1kBrFZBFQlencsB2vgFfCQOPD7HVANB9A2BYk5
	k2xAwpwCnhIt6y8zQSz2kFizazcjyEwJgZfsEi/OzmWHmCMg8W3yIRaIXlmJTQeYIY6WlDi4
	4gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzECY+r0v2cTdjDeO2B9iFGAg1GJ
	h/fD9LwQIdbEsuLK3EOMpkAbJjJLiSbnAyM3ryTe0NjMyMLUxNTYyNzSTEmc97XUz2AhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjKvuGf28KH2z/JKl1/V1uj/kP37hWCGYdePmHcXYGUom
	/Jvnbs9wrVU7uZvvkKwvn03VxY6Nc4y37FMWtL4ygWWeAJ/Fh/8lL38u8Jj3KzTr+ju+O+tf
	yE+TS5KpFsx6YjXv1fOQU4eF8/Pqu6TERRI/uvdLdt3s/PBkZfyXC472SRL1FwI+JSuxFGck
	GmoxFxUnAgC8to5ZpAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd1tjvkhBr8vG1kcvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLKX+WM1lc3jWHzWL2kn4Wixnn9zFZLFrWymzRuvcIu8Xh
	N+2sFhN+X2CzWLXrD6MDv8fOWXfZPTat6mTzuHNtD5vH/rlr2D1m3/3B6NG3ZRWjx/Eb25k8
	Pm+SC+CIamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAG6XkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY0d51m73gFk/FrZnP
	WBoYn3J1MXJySAiYSDSd38gCYYtJXLi3ng3EFhKYzihxdzqQzQVkT2CSmDjzHBNIgk1AV6Lp
	7S5GEFtEYDajRNtBIZAiZoEuJol3Sw+BdQsLeEtcWPaTGcRmEVCV6N2xHKyBV8BD4sDvd0A1
	HEDbFCTmTLIBCXMKeEq0rL/MBLHYQ2LNrt2MExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQIjthnUjsYVzZYHGIU4GBU4uH9MD0vRIg1say4MvcQowQHs5IIb7lwfogQb0piZVVq
	UX58UWlOavEhRlOgoyYyS4km5wOTSV5JvKGxibmpsamliYWJmaWSOO+Nm7khQgLpiSWp2amp
	BalFMH1MHJxSDYxOq8wuZgkvrt7GZmXh27PdUCjBT8dVUMfHxuVRQJgom5xsZXa12tbol5UT
	fD5Ps/M9L52c8rYt/nXl9F+3eDVfOB+dGdXcvq0gXsn7addkxl0LzygaXjcvcrrZ80Q6XbZ1
	6hJt/qz+j0lJlSUvTMMDTvdOs34W8LcwborZnc93nq1f2j1JQImlOCPRUIu5qDgRAEWSpwnu	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB and Power regulator on Exynos7 require gpios available
in BUS1 pin controller block.
So adding the BUS1 pinctrl support.

Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index d5d4cfc..caca5b5 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -1300,6 +1300,13 @@ static const struct samsung_pin_bank_data exynos7_pin_banks7[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr3", 0x0c),
 };
 
+/* pin banks of exynos7 pin-controller - BUS1 */
+static const struct samsung_pin_bank_data exynos7_pin_banks8[] __initconst = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpf0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpf4", 0x10),
+	EXYNOS_PIN_BANK_EINTG(6, 0x120, "gph1", 0x20),
+};
+
 const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 Alive data */
@@ -1342,5 +1349,10 @@ const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
 		.pin_banks	= exynos7_pin_banks7,
 		.nr_banks	= ARRAY_SIZE(exynos7_pin_banks7),
 		.eint_gpio_init = exynos_eint_gpio_init,
+	}, {
+		/* pin-controller instance 8 BUS1 data */
+		.pin_banks	= exynos7_pin_banks8,
+		.nr_banks	= ARRAY_SIZE(exynos7_pin_banks8),
+		.eint_gpio_init = exynos_eint_gpio_init,
 	},
 };
-- 
1.7.10.4

