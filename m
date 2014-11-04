Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaKDPCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:02:04 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57078 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaKDPBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:01:52 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-29-5458ea5da3cf
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 4/8] power: ab8500: Use power_supply_*() API for
 accessing function attrs
Date: Tue, 04 Nov 2014 16:01:37 +0100
Message-id: <1415113301-25661-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xy7qxryJCDJbdtrI4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4Mu6+bGMr2CFR
	8frMK+YGxrMiXYycHBICJhIPv5xkgrDFJC7cW8/WxcjFISSwlFFi+ffpLBBOH5PEkd49zCBV
	bALGEpuXLwGrEhG4ziTRuWICWBWzQCOzxLuGZrBZwgKpEp+Wz2MDsVkEVCVmr/3ICmLzCrhL
	7F61lR1in5zEyWOTweKcAh4SDVf/gNlCQDUretvZJjDyLmBkWMUomlqaXFCclJ5rpFecmFtc
	mpeul5yfu4kREvZfdzAuPWZ1iFGAg1GJh3dFfESIEGtiWXFl7iFGCQ5mJRFe9cdAId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYwRHNm/96f2T7iYqmTdLvOPZ8Z5nda3TyuPuTgL8PT8/Mj7teGe
	RvJ7pbs1Qi6nd7cZL0xeJ6Sslsy+glvXu3z691Uc/SUzJKawaD7W8Vhh5SvB8PzmhEzmF2sv
	x/LXqlj94fc3PPqJ6/XSQqnJS+SLvp4JYv41/ZzxhOKUv79+beyt2NR3z1mJpTgj0VCLuag4
	EQC3CV2tWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/power/ab8500_btemp.c    | 2 +-
 drivers/power/ab8500_charger.c  | 2 +-
 drivers/power/ab8500_fg.c       | 2 +-
 drivers/power/abx500_chargalg.c | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 7f9a4547dccd..8161960ee78c 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -938,7 +938,7 @@ static int ab8500_btemp_get_ext_psy_data(struct device *dev, void *data)
 		enum power_supply_property prop;
 		prop = ext->properties[j];
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 
 		switch (prop) {
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 19110aa613a1..38d61523227f 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1957,7 +1957,7 @@ static int ab8500_charger_get_ext_psy_data(struct device *dev, void *data)
 		enum power_supply_property prop;
 		prop = ext->properties[j];
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 
 		switch (prop) {
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 99a78d365ceb..3ea208e36fa6 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2200,7 +2200,7 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 		enum power_supply_property prop;
 		prop = ext->properties[j];
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 
 		switch (prop) {
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d2723664a01..f3d9dbac3568 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1001,7 +1001,7 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 	 * property because of handling that sysfs entry on its own, this is
 	 * the place to get the battery capacity.
 	 */
-	if (!ext->get_property(ext, POWER_SUPPLY_PROP_CAPACITY, &ret)) {
+	if (!power_supply_get_property(ext, POWER_SUPPLY_PROP_CAPACITY, &ret)) {
 		di->batt_data.percent = ret.intval;
 		capacity_updated = true;
 	}
@@ -1019,7 +1019,7 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 			ext->type == POWER_SUPPLY_TYPE_USB)
 			di->usb_chg = psy_to_ux500_charger(ext);
 
-		if (ext->get_property(ext, prop, &ret))
+		if (power_supply_get_property(ext, prop, &ret))
 			continue;
 		switch (prop) {
 		case POWER_SUPPLY_PROP_PRESENT:
-- 
1.9.1

