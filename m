Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161088Ab3DEBsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:48:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45662 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab3DEBsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:48:37 -0400
X-AuditID: cbfee68e-b7f946d000001e37-c3-515e2d744444
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
In-reply-to: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
Subject: [PATCH 4/7] rtc: rtc-ds3234: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:48:36 +0900
Message-id: <000401ce319f$affabf90$0ff03eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xn4fH39zvwb7bR32L9HOXANRbigAAB3DQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA90S3bhAg2XH5CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmHZiPlPBKdaKFc+msjUwnmHpYuTkkBAwkWg/+QjKFpO4cG89WxcjF4eQwDJGie/9
	+9lgij7+P8oEkVjEKNF5YBkzhPOLUeLCnOPsIFVsAmoSX74cBrI5OEQE9CXaWjRAapgFehkl
	zvTuBqsRErCVWP2nB2wdp4CdxNd5GxhBbGEBa4k9XXeYQGwWAVWJOw8h6nmB6luWnWCCsAUl
	fky+B9bLLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSfTc+c4KUSIise/FO0aQeyQE
	7rFLvJz5gRlil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG
	0dSC5ILipPQiI73ixNzi0rx0veT83E2MkFjt28F484D1IcZkoPUTmaVEk/OBsZ5XEm9obGZk
	YWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb5rypXktgf/Suw
	5dzKrbtsl+Tp/dmW15sEXa+84nr/xG3b3yMcygUZzEYlibqKP//80FHgLSz+K6V2MF5O9887
	Tq+7TrIcmeli868FWB2KqHz4WNRg3huF8hvfJ9348Ea3Y4fVxwkLIlO7hKRPdb79apJX53Cn
	+cuUi6bWSxNT+XXnz7e7PFeJpTgj0VCLuag4EQCoaU376wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd0S3bhAgy+9UhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZkw7MZ+p4BRrxYpnU9kaGM+wdDFyckgImEh8
	/H+UCcIWk7hwbz1bFyMXh5DAIkaJzgPLmCGcX4wSF+YcZwepYhNQk/jy5TCQzcEhIqAv0dai
	AVLDLNDLKHGmdzdYjZCArcTqPz1gGzgF7CS+ztvACGILC1hL7Om6A7aNRUBV4s5DiHpeoPqW
	ZSeYIGxBiR+T74H1MgtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhI9d76zQpSISOx7
	8Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Ez6R2
	MK5ssDjEKMDBqMTDm9EXGyjEmlhWXJl7iFGCg1lJhHcnX1ygEG9KYmVValF+fFFpTmrxIcZk
	oEcnMkuJJucDk1ReSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBK
	NTAeqyza0uDGI7wg+56rxi/2snD3sMfaIUwH9khWKNZ9YUuzfhw+ZfLybedbbhQ0cWoteLTo
	2IvmfQ3vrU8t/XrUd8+OzBeu1vMcS44/jTx4bB3jh56KOxUMuYsPTNS5Y9O3c9eVLw7GNV/k
	O6cwRv5ftyHT5MXMp/tv7M/8v5DrvnY802OOqb9+KLEUZyQaajEXFScCALQrNqlIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds3234.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index a66efd4..ba98c0e 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -151,7 +151,7 @@ static int ds3234_probe(struct spi_device *spi)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-	dev_set_drvdata(&spi->dev, rtc);
+	spi_set_drvdata(spi, rtc);
 
 	return 0;
 }
-- 
1.7.2.5


