Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3CNINa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:13:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24230 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNIN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:13:28 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-79-514186a871c1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 07/30] rtc: rtc-ds3234: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:13:27 +0900
Message-id: <008a01ce208b$ce90eb70$6bb2c250$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAGUYg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zA90VbY6BBj2vmSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3g0vmAvmcVQc3qTdwPiWrYuRg0NCwERi1k/PLkZOIFNM4sK9
	9UBhLg4hgWWMEhtuTmKCSJhI3N+7GyqxCCixZAojhDObSeLVpsksIFVsAmoSX74cZgeZKiKg
	L9HWogFSwyzQyyhxpnc3WFxIwFbi+n87EJNTwE5iw3oxkE5hATeJU0/2sYPYLAKqEk0P1oNN
	5AWqvrrmKiuELSjxY/I9sDizgJbE+p3HmSBseYnNa94yQ/yiLvHory5IWETASGLatB9QJSIS
	+168A7tYQmAeu8SVmcugdglIfJt8iAWiV1Zi0wFmiHclJQ6uuMEygVFiFpLNs5BsnoVk8ywk
	KxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECImpiTsY7x+wPsSYDLR+IrOUaHI+MCbz
	SuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI1Pyh
	ebvK7qJfYc2TrM4umiGUoiL0Wezkmu7pZvkr+5qbk9vTJBS3x7xT5nWwvbqIa1fUyVP6l4IL
	HAv+rLiYPJNhu7/bO+24eX5vw6NW8mxI5nmfVttdpncv4fKBg6xfXyVKOLFP4lFt0n9xRC7D
	klPpkZvUmQMnj81vq4zNq3qxOXlNnJMSS3FGoqEWc1FxIgCKLhVDvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO7yNsdAg3OrrCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxt4NL5gL5nFUHN6k3cD4
	lq2LkZNDQsBE4v7e3VC2mMSFe+uBbC4OIYFFjBIblkxhhHBmM0m82jSZBaSKTUBN4suXw+xd
	jBwcIgL6Em0tGiA1zAK9jBJneneDxYUEbCWu/7cDMTkF7CQ2rBcD6RQWcJM49WQfO4jNIqAq
	0fRgPdhEXqDqq2uuskLYghI/Jt8DizMLaEms33mcCcKWl9i85i0zyEgJAXWJR391QcIiAkYS
	06b9gCoRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERyzz6R3MK5qsDjEKMDBqMTDGyHqGCjEmlhWXJl7iFGCg1lJhNfTCyjEm5JYWZValB9f
	VJqTWnyIMRno0YnMUqLJ+cB0klcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC
	1CKYLUwcnFLAFHZWi3/OhGnL9JjswzMviSwvjLws/enzevEFrzQTJFcfzT36pzF93o2Chpgp
	D23TLBb9fFPr9Ppd1cEVzodu77Z7XhVjt+n2bu2cGgkV5TleZme257Lf6rzLKMH05kL4JM3p
	m5Yy5yUYynBwJB4IjtmQu1cx4SnD36jkat2+73M+yidf2dT6QomlOCPRUIu5qDgRAKT6Y14d	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds3234.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index 7a4495e..a66efd4 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -146,8 +146,8 @@ static int ds3234_probe(struct spi_device *spi)
 	ds3234_get_reg(&spi->dev, DS3234_REG_CONT_STAT, &tmp);
 	dev_info(&spi->dev, "Ctrl/Stat Reg: 0x%02x\n", tmp);
 
-	rtc = rtc_device_register("ds3234",
-				&spi->dev, &ds3234_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "ds3234",
+				&ds3234_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -158,9 +158,6 @@ static int ds3234_probe(struct spi_device *spi)
 
 static int ds3234_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = spi_get_drvdata(spi);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
-- 
1.7.2.5


