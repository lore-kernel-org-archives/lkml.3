Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3FCJFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:05:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47034 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3FCJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:05:08 -0400
X-AuditID: cbfee68f-b7f436d000000f81-2d-51ac5c416e28
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <cbou@mail.ru>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V2] power: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 18:05:05 +0900
Message-id: <000901ce6039$7071c670$51555350$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5gOWs+3JYf8JRjQReQHIrCdRxWNg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zA13HmDWBBu8eG1m8nHCY0WLv1btM
	Fr92bmO2mLhyMrPF5YWXWC0u75rD5sDmsXPWXXaPzSu0PKbMPcLqMefYPBaPvi2rGD0+b5IL
	YIvisklJzcksSy3St0vgypg/eRdjwTKBiqffrjE1MC7i7WLk5JAQMJG427ibCcIWk7hwbz1b
	FyMXh5DAMkaJXSsXssIUXTv1lhkisYhRYtmNI2AdQgK/GCUOb84GsdkE1CS+fDnMDmKLCKhI
	zLx3iAmkgVngFKPE/u3LGUESwgLOEmv23GEBsVkEVCWaf70HG8QrYCkx7etTRghbUOLH5Htg
	NcwCWhLrdx5ngrDlJTavAbkC5CIFiR1nXzNCLNOTeLL6LCNEjYjEvhfvGEEWSwhcYpdoOjET
	apmAxLfJh4BsDqCErMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5K
	LzLWK07MLS7NS9dLzs/dxAiJx/4djHcPWB9iTAZaP5FZSjQ5HxjPeSXxhsZmRhamJqbGRuaW
	ZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgzFwUMFvYTFafr3Bbr13L6RVG
	BYebj1361bSeh7dR3vJQs+h+YV7Z2QsOfZma8VR5ecr2+a/sTvWJzIsVv9FisOeDp8TXhZsk
	RX5NFxZebMGY9nu68YQSpWf/FTXbgq5uFVt9PlUhd13WmRUKl7ti9StNbLj4j/7v2eV44LzE
	zemVd4SXKczTUmIpzkg01GIuKk4EAIRlkjfdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV3HmDWBBp9P6Vm8nHCY0WLv1btM
	Fr92bmO2mLhyMrPF5YWXWC0u75rD5sDmsXPWXXaPzSu0PKbMPcLqMefYPBaPvi2rGD0+b5IL
	YItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpD
	SaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5gxf/IuxoJlAhVPv11jamBc
	xNvFyMkhIWAice3UW2YIW0ziwr31bF2MXBxCAosYJZbdOMIEkhAS+MUocXhzNojNJqAm8eXL
	YXYQW0RARWLmvUNMIA3MAqcYJfZvX84IkhAWcJZYs+cOC4jNIqAq0fzrPdggXgFLiWlfnzJC
	2IISPybfA6thFtCSWL/zOBOELS+xeQ3MRQoSO86+ZoRYpifxZPVZRogaEYl9L94xTmAUmIVk
	1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR/kx6B+OqBotDjAIc
	jEo8vAEeawKFWBPLiitzDzFKcDArifBeCQQK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w
	EeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+Mk6ZxPDH0X
	TT7tedvwZaedutlmvhChiHX3brOuFZjCGJEXECV9zyPgkf8PhshfU3fEbzU9U1EqsfNl/6+J
	M/NklnGJrGVmnir0JV1MbJpV06MzNesepjTdklrAbfbyxyL2m3wf/3l4iNySXCVn1ScVymZf
	68QvxTkp8OZZozUz532vuM/EzKvEUpyRaKjFXFScCAB7UeCAOgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Used return code from kstrtoul().

 drivers/power/ab8500_fg.c        |    6 +++---
 drivers/power/pcf50633-charger.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c5391f5..308e511 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2465,9 +2465,9 @@ static ssize_t charge_full_store(struct ab8500_fg *di, const char *buf,
 				 size_t count)
 {
 	unsigned long charge_full;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
 
-	ret = strict_strtoul(buf, 10, &charge_full);
+	ret = kstrtoul(buf, 10, &charge_full);
 
 	dev_dbg(di->dev, "Ret %zd charge_full %lu", ret, charge_full);
 
@@ -2489,7 +2489,7 @@ static ssize_t charge_now_store(struct ab8500_fg *di, const char *buf,
 	unsigned long charge_now;
 	ssize_t ret;
 
-	ret = strict_strtoul(buf, 10, &charge_now);
+	ret = kstrtoul(buf, 10, &charge_now);
 
 	dev_dbg(di->dev, "Ret %zd charge_now %lu was %d",
 		ret, charge_now, di->bat_cap.prev_mah);
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 17fd77f..771c4f0 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -191,9 +191,9 @@ static ssize_t set_usblim(struct device *dev,
 	unsigned long ma;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &ma);
+	ret = kstrtoul(buf, 10, &ma);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	pcf50633_mbc_usb_curlim_set(mbc->pcf, ma);
 
@@ -228,9 +228,9 @@ static ssize_t set_chglim(struct device *dev,
 	if (!mbc->pcf->pdata->charger_reference_current_ma)
 		return -ENODEV;
 
-	ret = strict_strtoul(buf, 10, &ma);
+	ret = kstrtoul(buf, 10, &ma);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	mbcc5 = (ma << 8) / mbc->pcf->pdata->charger_reference_current_ma;
 	if (mbcc5 > 255)
-- 
1.7.10.4


