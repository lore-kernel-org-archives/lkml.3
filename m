Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaICFuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:50:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15544 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaICFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:50:15 -0400
X-AuditID: cbfee68e-f79536d000000fd1-7e-5406ac11312d
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, r.baldyga@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] extcon: max77693: Fix a bug occured at changing ADC debounce
 time.
Date: Wed, 03 Sep 2014 14:50:07 +0900
Message-id: <1409723407-21221-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsWyRsSkRFdoDVuIwYOtTBbXvzxnteg8+4TZ
	4vKuOWwWtxtXsFk8OLyT3YHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDLOXWlmKZjHXfGt
	t4GpgXE6ZxcjJ4eEgInE6sszmSBsMYkL99azdTFycQgJLGWUeDthDTtM0Z/9jawQiemMErOu
	PoNy2pgkHh76wgpSxSagI/F/302wDhEBBYnNvc/A4swCJRKLz/wFs4UFQiV+rdkHZHNwsAio
	Snza4QQS5hXwkOjuewkWlgBqnTPJBmS8hMB1NomuN2fArmMREJD4NvkQC0SNrMSmA8wQt0lK
	HFxxg2UCo+ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIEhePrfs74djDcPWB9iFOBg
	VOLhXRDAFiLEmlhWXJl7iNEUaMNEZinR5HxgoOeVxBsamxlZmJqYGhuZW5opifMmSP0MFhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cDIJ66ou7dsq+F+I17Xmp/f7rhEanxRf9/x9eSLuA3m
	rfUJ0overNd4H8AyOzK3cbbq7WQN7uNnH1h0W1xo/Rhnef5y6rRYjc4t3AfnrdmoFKAwKXdr
	wuuPJdN7Iq42Rqt8sE2v+CN7Ltte26jfvuLf1dxvh4J0Dq4TDtMMmrvXuJ2dbapsxVQlluKM
	REMt5qLiRADX/AdJPAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQV3BNWwhBit+Wlhc//Kc1aLz7BNm
	i8u75rBZ3G5cwWbx4PBOdgdWj74tqxg9Pm+SC2CKamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMOHelmaVgHnfFt94GpgbG6ZxdjJwcEgImEn/2N7JC2GISF+6tZ+ti5OIQ
	EpjOKDHr6jNWCKeNSeLhoS9gVWwCOhL/991kB7FFBBQkNvc+A4szC5RILD7zF8wWFgiV+LVm
	H5DNwcEioCrxaYcTSJhXwEOiu+8lWFgCqHXOJJsJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgQH+DOpHYwrGywOMQpwMCrx8C4IYAsRYk0sK67MPcQowcGsJMLrmwgU4k1JrKxK
	LcqPLyrNSS0+xGgKtHsis5Rocj4w+vJK4g2NTcyMLI3MDS2MjM2VxHkPtFoHCgmkJ5akZqem
	FqQWwfQxcXBKNTA2Tl7I9sW9Y7rBgrfPp7VkP9no3VSSuPBwzOTa+ea8rTtuv5O8LjApaYrz
	t+rlQcofl9nViSexmC689sSt0DyHT3relxVXvvRv8//GtqH3hVlCv3zD2tu3PjTkRUo+Z1SX
	viBZsaTEXbHVwGT2Qnufh8unut53PbfHU845LUJ+5UGFs7qBly4rsRRnJBpqMRcVJwIALcgR
	Q4YCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it writes some value other than 0 to BTLDset and JIGset, muic device
will be reset automatically. And it happens during updating ADC debounce time,
because it shares same register. To update ADC debounce time without reset,
set value only to ADCDbset and 0 to BTLDset and JIGset.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/extcon/extcon-max77693.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 77460f2..661a3bb 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = regmap_update_bits(info->max77693->regmap_muic,
+		/*
+		 * Don't touch BTLDset, JIGset when you want to change adc
+		 * debounce time. BTLDset, JIGset reflects actual pin status
+		 * and are not configurable.
+		 */
+		ret = regmap_write_bits(info->max77693->regmap_muic,
 					  MAX77693_MUIC_REG_CTRL3,
-					  CONTROL3_ADCDBSET_MASK,
-					  time << CONTROL3_ADCDBSET_SHIFT);
+					  (CONTROL3_ADCDBSET_MASK &
+					  time << CONTROL3_ADCDBSET_SHIFT));
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
 			return ret;
-- 
1.7.9.5

