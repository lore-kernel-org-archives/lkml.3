Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaICGsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:48:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22592 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaICGsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:48:03 -0400
X-AuditID: cbfee68f-f797f6d000001173-05-5406b9a12dd5
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, r.baldyga@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v2] extcon: max77693: Fix a bug occured at changing ADC
 debounce time.
Date: Wed, 03 Sep 2014 15:47:58 +0900
Message-id: <1409726878-25781-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWyRsSkUHfhTrYQgwcnVC2uf3nOatF59gmz
	xeVdc9gsbjeuYLN4cHgnuwOrR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGWcX7uEreAOd8Xu
	lxINjIc4uxg5OSQETCSOzO5hhLDFJC7cW8/WxcjFISSwlFFi46MljDBFXSuamCAS0xklGu8v
	ZwdJCAm0MUlcXeIIYrMJ6Ej833cTLC4ioCCxufcZK4jNLFAisfjMXzBbWCBC4vbi3WA1LAKq
	EtM2bGMDsXkFPCR+bn8ItIwDaJmCxJxJNiC7JARus0kcOLmGEaJeQOLb5EMsEDWyEpsOMEPc
	JilxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBAbg6X/P+ncw3j1gfYhR
	gINRiYd3QQBbiBBrYllxZe4hRlOgDROZpUST84FhnlcSb2hsZmRhamJqbGRuaaYkzrtQ6mew
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaDt9xV5v5qFFg3eZ1Fzfsjwnn+7QUWp3+Yq02x
	f8a5wMsmS5NP0fPhyuelV/3W/xE2ODXFzCTi7TT2kO4HB2Nim/6XiJWdW6pZcsUok2tltMFh
	icBsuxvRMxX0PTgXzuNQ59zm6bHpxy0Ng/ow/1Xrp1U/ebbufgjPx6lNXHd/Pa/5zfwy+L0S
	S3FGoqEWc1FxIgBjoY1POwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jQd2FO9lCDG4uk7O4/uU5q0Xn2SfM
	Fpd3zWGzuN24gs3iweGd7A6sHn1bVjF6fN4kF8AU1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0TkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Su
	b0gQXI+RARpIWMOYcX7tEraCO9wVu19KNDAe4uxi5OSQEDCR6FrRxARhi0lcuLeerYuRi0NI
	YDqjROP95ewgCSGBNiaJq0scQWw2AR2J//tugsVFBBQkNvc+YwWxmQVKJBaf+QtmCwtESNxe
	vBushkVAVWLahm1sIDavgIfEz+0PGbsYOYCWKUjMmWQzgZF7ASPDKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzg8H4mvYNxVYPFIUYBDkYlHt4FAWwhQqyJZcWVuYcYJTiYlUR4fROBQrwp
	iZVVqUX58UWlOanFhxhNgZZPZJYSTc4Hxl5eSbyhsYmZkaWRuaGFkbG5kjjvwVbrQCGB9MSS
	1OzU1ILUIpg+Jg5OqQZGZc9n2gbqrXOSZae+iz1/NsFb0E672TRDJW52gdEsK77vr1ecKDFU
	sBP6qqTAfTTyiYqwWe5d1v54qRc/+ne2/0wXDTsV4fvTfN6/OrZJUtsePda5Fy62x6l5NTtz
	VtHkAk6lGZ/5T38LKFvN7TjJ+Kfhq7cTF3D5Nx0+75Qv/mJCNftXJiYlluKMREMt5qLiRAD8
	Q7BHhQIAAA==
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
Changes in v2
 - Fix comments.

 drivers/extcon/extcon-max77693.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 77460f2..171f35a 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = regmap_update_bits(info->max77693->regmap_muic,
+		/*
+		 * Don't touch BTLDset, JIGset when you want to change adc
+		 * debounce time. If it writes other than 0 to BTLDset, JIGset
+		 * muic device will be reset and loose current state.
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

