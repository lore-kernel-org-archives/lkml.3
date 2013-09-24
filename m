Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3IXJYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:24:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30471 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3IXJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:24:06 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-fa-52415a3582dd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
In-reply-to: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
Subject: [PATCH 4/8] backlight: lms283gf05: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:24:04 +0900
Message-id: <006501ceb907$d01f87c0$705e9740$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQAADVyQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zY13TKMcgg44DrBZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8af+ZeZ
	CqZzVcz5OIu1gXEjRxcjJ4eEgInE/hdPWSFsMYkL99azdTFycQgJLGOU2Nh0jhmmqGnBMiaI
	xHRGiX/r1jBDOL8YJX5c/MYIUsUmoCbx5cth9i5GDg4RAX2JthYNkDCzQI7E/Sez2EFsIQFb
	idUzr4LZnAJ2Eu+nnmEBsYUFvCSa7+4Cs1kEVCVuLnwAtpgXqH7OxS+MELagxI/J91ggZmpJ
	bN7WxAphy0tsXvOWGWSthIC6xKO/uiBhEQEjiT2HbjJDlIhI7HvxjhHkZAmBS+wSp062Q+0S
	kPg2+RALRK+sxKYDUP9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKpX
	nJhbXJqXrpecn7uJERKVE3cw3j9gfYgxGWj9RGYp0eR8YFTnlcQbGpsZWZiamBobmVuakSas
	JM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoExTl+5Nu5IWcfLDw+NXexjXxuFTH7J
	onA6eOfZv5M8523nfSydu9K9x9FKbitHp3N7z2s+9vcVRdtbTy/LfsW24+Qx/Yg5/n/tew0/
	Sbn5MFnwiu8N1rrjbiT+hP21v1anzOopm/+kMjN4b1S+ZPzDds7dhSf9bur6Lnz067Sze7Jr
	SkihnIkSS3FGoqEWc1FxIgDpWJVU4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQV3TKMcggw+vGS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMP/MvMxVM56qY83EWawPjRo4uRk4OCQETiaYFy5ggbDGJC/fW
	s3UxcnEICUxnlPi3bg0zhPOLUeLHxW+MIFVsAmoSX74cZu9i5OAQEdCXaGvRAAkzC+RI3H8y
	ix3EFhKwlVg98yqYzSlgJ/F+6hkWEFtYwEui+e4uMJtFQFXi5sIHzCA2L1D9nItfGCFsQYkf
	k++xQMzUkti8rYkVwpaX2LzmLTPIWgkBdYlHf3VBwiICRhJ7Dt1khigRkdj34h3jBEahWUgm
	zUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzzz6R2MK5ssDjEKMDB
	qMTDu8PbIUiINbGsuDL3EKMEB7OSCO8NW8cgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4H
	pqO8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamA0eS/cweGd
	1MIdzNnwUdFG7G2xcotrweO0VyGV+V9Xzv8W9URz6rNn/1jtNlRobfJ/kOC7d7bM0i2yyskR
	cxmv6/1O1W+MulexPPbnxqv2TIp/p29qafhmn7Xi/AepjlXNFep6i1U/PedceIAl/FVv7Z7D
	4cfDnNo/3RRMEF3BUh0pcnVlbLgSS3FGoqEWc1FxIgCLgtfNPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms283gf05.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index 80b5929..de88325 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -173,7 +173,8 @@ static int lms283gf05_probe(struct spi_device *spi)
 		return -ENOMEM;
 	}
 
-	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
+	ld = devm_lcd_device_register(&spi->dev, "lms283gf05", &spi->dev, st,
+					&lms_ops);
 	if (IS_ERR(ld))
 		return PTR_ERR(ld);
 
@@ -190,22 +191,12 @@ static int lms283gf05_probe(struct spi_device *spi)
 	return 0;
 }
 
-static int lms283gf05_remove(struct spi_device *spi)
-{
-	struct lms283gf05_state *st = spi_get_drvdata(spi);
-
-	lcd_device_unregister(st->ld);
-
-	return 0;
-}
-
 static struct spi_driver lms283gf05_driver = {
 	.driver = {
 		.name	= "lms283gf05",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= lms283gf05_probe,
-	.remove		= lms283gf05_remove,
 };
 
 module_spi_driver(lms283gf05_driver);
-- 
1.7.10.4


