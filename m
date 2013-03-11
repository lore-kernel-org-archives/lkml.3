Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3CKGcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:32:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59918 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3CKGcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:32:46 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e6-513d7a8d5306
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 05/14] power: ds2760_battery: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:32:44 +0900
Message-id: <007501ce1e22$3d8104f0$b8830ed0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAADqvg
Content-language: ko
x-cr-hashedpuzzle: bXo= AE4q Biqn JC9z Kc4d PO1A PUIQ Q7Zu V4o2 X+cM Y+BI e0uW
 qU7U uPrA uTn9
 wk1q;4;YQBuAHQAbwBuAEAAZQBuAG8AbQBzAGcALgBvAHIAZwA7AGQAdwBtAHcAMgBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{72981A2D-BF13-4AC8-8356-A486D8A918C2};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 11 Mar 2013 06:32:37
 GMT;WwBQAEEAVABDAEgAIAAwADUALwAxADQAXQAgAHAAbwB3AGUAcgA6ACAAZABzADIANwA2ADAAXwBiAGEAdAB0AGUAcgB5ADoAIAB1AHMAZQAgAGQAZQB2AG0AXwBrAHoAYQBsAGwAbwBjACgAKQA=
x-cr-puzzleid: {72981A2D-BF13-4AC8-8356-A486D8A918C2}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ93eKttAg2mbxC0ObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXx6NlZpoJ5
	nBUzjvxhamB8wN7FyMkhIWAi0bF2PSuELSZx4d56ti5GLg4hgWWMEgc3vWbsYuQAK/p0Vwek
	RkhgOqNEyxl3iJpfjBLt76cygyTYBNQkvnw5DDZUREBDom31FBYQm1kgX+LwocssEM22Ert/
	vmAEsTkF7CRuLLvEBjJfWMBB4tcOHpAwi4CqxL1VH8HG8AKVbzjVyARhC0r8mHwPaqSWxOZt
	TawQtrzE5jVvmSHOVJd49FcXxBQRMJKY8M4dokJEYt+Ld4wgF0sIvGGR+Lb1CgvEu6YSDQ9P
	MUEkHrFLNC5Ywghxg4DEt8mHWCBmykpsOsAMUS8pcXDFDZYJjFKzkFw0C8lFs5BcNAvJ7gWM
	LKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQqJ34g7G+wesDzEmA62fyCwlmpwPjP68knhD
	YzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAWV804pnGY
	61fXonqftuueeguyDIV/Hfy7XvRijK3oDV1mrdePc4qXF98+yZ2aFCAvsjA7f4Zv8bKACZ8t
	7qf++lj76bPYl3+W3sXml6fYPDm1pJ+F3/DGDouvXZd2idpKMq2t0MgyW/nd50ZxX3Zq1bJd
	V29dihP/qKhfN/dkYHxePpOZ7XolluKMREMt5qLiRABHyGQc9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd3eKttAg3WrhS0ObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeY8ejZWaaCeZwVM478YWpgfMDexcjBISFgIvHprk4XIyeQKSZx4d56
	NhBbSGA6o0TLGfcuRi4g+xejRPv7qcwgCTYBNYkvXw6zg9giAhoSbaunsIDYzAL5EocPXWaB
	aLaV2P3zBSOIzSlgJ3Fj2SU2kF3CAg4Sv3bwgIRZBFQl7q36CDaGF6h8w6lGJghbUOLH5HtQ
	I7UkNm9rYoWw5SU2r3nLDHGyusSjv7ogpoiAkcSEd+4QFSIS+168YwS5WELgDYvEt61XWCDe
	MpVoeHiKaQKjyCwkG2Yh2TALyYZZSGYtYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGc
	Gp5J72Bc1WBxiFGAg1GJh3eCjm2gEGtiWXFl7iFGCQ5mJRHelZtsAoV4UxIrq1KL8uOLSnNS
	iw8xJgMDYCKzlGhyPjBt5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhm
	CxMHp1QD44Zp4Tmfsuyn3SvJz3im0hxok9tbnh5ycsa7q06PtV8srrs14XxrSfPCD7JMP16s
	Dezc+k/U4d+BHZmnhM3mX5A/YX4+UuHU3t410wO4df5IfprxJmT/Tr4DN5Keeky5z+oRmLY0
	uPVO/tn2r5JNF3qmcTPukZS94j7flX0y0zFOGfdpETnN65VYijMSDbWYi4oTAVH+t0xRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/ds2760_battery.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 704e652..85b4e6e 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -512,7 +512,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	int retval = 0;
 	struct ds2760_device_info *di;
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
 	if (!di) {
 		retval = -ENOMEM;
 		goto di_alloc_failed;
@@ -576,7 +576,6 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 workqueue_failed:
 	power_supply_unregister(&di->bat);
 batt_failed:
-	kfree(di);
 di_alloc_failed:
 success:
 	return retval;
@@ -590,7 +589,6 @@ static int ds2760_battery_remove(struct platform_device *pdev)
 	cancel_delayed_work_sync(&di->set_charged_work);
 	destroy_workqueue(di->monitor_wqueue);
 	power_supply_unregister(&di->bat);
-	kfree(di);
 
 	return 0;
 }
-- 
1.7.2.5


