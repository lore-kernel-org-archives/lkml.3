Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3CKGeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:34:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60258 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3CKGeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:34:23 -0400
X-AuditID: cbfee68d-b7f786d000005188-fa-513d7ae79e7e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 08/14] power: isp1704_charger: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:34:15 +0900
Message-id: <007801ce1e22$73830210$5a890630$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAHCMA
Content-language: ko
x-cr-hashedpuzzle: BJnm FwRn JMh/ JM0U OrAO O09s Qxhs SYUX T4B4 XZGh ckx4 ey03
 hUwx hcMh rZ5D
 tUMN;4;YQBuAHQAbwBuAEAAZQBuAG8AbQBzAGcALgBvAHIAZwA7AGQAdwBtAHcAMgBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{31B50BF8-4F49-4317-92C9-1B62D85716E0};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 11 Mar 2013 06:34:08
 GMT;WwBQAEEAVABDAEgAIAAwADgALwAxADQAXQAgAHAAbwB3AGUAcgA6ACAAaQBzAHAAMQA3ADAANABfAGMAaABhAHIAZwBlAHIAOgAgAHUAcwBlACAAZABlAHYAbQBfAGsAegBhAGwAbABvAGMAKAApAA==
x-cr-puzzleid: {31B50BF8-4F49-4317-92C9-1B62D85716E0}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zA93nVbaBBn1dehYHt2paTFw5mdni
	8sJLrBaXd81hc2DxmND/idFj8wotj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MqYvOMeY8EH
	joqu4x0sDYyr2LsYOTkkBEwk3vfdZoawxSQu3FvPBmILCSxjlPi0hhGm5uOft0A2F1B8OqPE
	s71TmCCcX4wSi1f8ZwKpYhNQk/jy5TDYVBEBDYm21VNYQGxmgXyJw4cus0BMtZXY/fMF2FRO
	ATuJG8sugW0TFnCU2LboBZjNIqAqMfnucrCLeIHql899yAphC0r8mHwPaqaWxOZtTawQtrzE
	5jVvgeo5gC5Vl3j0VxfiBCOJx7ta2CBKRCT2vXgH9oCEwAcWiXNvH7FCfGYq0bVwBjNE4hG7
	xOSV39khjhCQ+Db5EAvEUFmJTQegISQpcXDFDZYJjFKzkJw0C8lJs5CcNAvJ7gWMLKsYRVML
	kguKk9KLDPWKE3OLS/PS9ZLzczcxQmK4dwfj7QPWhxiTgdZPZJYSTc4HpoC8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDu73sxb/4HFSGHO2rr
	uLas1D+6L/5a16pr5TfaTM/nbtmxR+2SuM+joMpnzLvKH7y2v/PD+9jVHatFRK6sWu46OyYy
	zu/Wh8tv/m7duSvcQPaywH0ZxQxGkQ0aub/XsyR42q1/2O8mLNO/2MFok5uBn8JNRz+Xd1rV
	vX+W1rP0iF4MT9fiq85SYinOSDTUYi4qTgQAattPxfcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jQd3nVbaBBu9/aVoc3KppMXHlZGaL
	ywsvsVpc3jWHzYHFY0L/J0aPzSu0PPq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY/KOe4wFHzgquo53sDQwrmLvYuTkkBAwkfj45y0jhC0mceHeerYu
	Ri4OIYHpjBLP9k5hgnB+MUosXvGfCaSKTUBN4suXw2DdIgIaEm2rp7CA2MwC+RKHD10Gs4UE
	bCV2/3wBNpVTwE7ixrJLbCC2sICjxLZFL8BsFgFVicl3lzOD2LxA9cvnPmSFsAUlfky+BzVT
	S2LztiZWCFteYvOat0D1HECXqks8+qsLcYKRxONdLWwQJSIS+168YwS5WULgA4vEubePWCE+
	M5XoWjiDeQKjyCwkK2YhWTELyYpZSGYtYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGc
	Ip5J72Bc1WBxiFGAg1GJh3eCjm2gEGtiWXFl7iFGCQ5mJRHelZtsAoV4UxIrq1KL8uOLSnNS
	iw8xJgNDYCKzlGhyPjB95ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhm
	CxMHp1QD4+wcXY7ZrVsetE+dr/pczuz7cxWe+285mAP/SsfMXbhe6k5TlkdrpNRjuVO/LBNs
	v+3+8HXhCfeH1+K2WlTPfNq5XjjCWE8r6YJTZWIKp7D9WnbLql8PaufeKj33h/GUSG9mpvBj
	0z1F+eGcPwXaVrY+EVQ7Km7uochsJnRkUZ6HLYuJwJV+JZbijERDLeai4kQAin3rslUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/isp1704_charger.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 176ad59..fc04d19 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -411,7 +411,7 @@ static int isp1704_charger_probe(struct platform_device *pdev)
 	struct isp1704_charger	*isp;
 	int			ret = -ENODEV;
 
-	isp = kzalloc(sizeof *isp, GFP_KERNEL);
+	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
 	if (!isp)
 		return -ENOMEM;
 
@@ -477,8 +477,6 @@ fail1:
 	isp1704_charger_set_power(isp, 0);
 	usb_put_phy(isp->phy);
 fail0:
-	kfree(isp);
-
 	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
 
 	return ret;
@@ -492,7 +490,6 @@ static int isp1704_charger_remove(struct platform_device *pdev)
 	power_supply_unregister(&isp->psy);
 	usb_put_phy(isp->phy);
 	isp1704_charger_set_power(isp, 0);
-	kfree(isp);
 
 	return 0;
 }
-- 
1.7.2.5


