Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3BUIhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:37:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48404 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3BUIhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:37:12 -0500
X-AuditID: cbfee68e-b7fc26d000001938-6e-5125dcb74a3f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 10/12] rtc: rtc-max8907: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:37:11 +0900
Message-id: <00d501ce100e$a4554000$ecffc000$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAKaNQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ93td1QDDTZMMLa4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZRybMYSw4wFHR3TKRrYGxmb2LkZNDQsBE4uWhfSwQtpjEhXvr
	2boYuTiEBJYxSkz5+IOxi5EDrGj2hjCQGiGB6YwSv34LQ9TMZpI4dP8jWDObgJrEly+H2UHq
	RQT0JdpaNEBqmAV6GSXO9O5mh2i2lZjz4RoziM0pYCdxedsXVhBbWMBDYsn/c2A1LAKqErdO
	PgaL8wLVv9g4EcoWlPgx+R7YLmYBLYn1O48zQdjyEpvXvGWGuFNd4tFfXZCwiICRxPv905gh
	SkQk9r14xwhyj4TAInage7awQOwSkPg2+RALRK+sxKYDzJBwkJQ4uOIGywRGiVlINs9CsnkW
	ks2zkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkrvp2MN48YH2IMRlo/URmKdHk
	fGBc5pXEGxobm5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	I8/++ZdPFEYFSf9f9/rNxLTjou9Dn0kLF7I3+Ls8ueZ9zcnK8N929bYJc7yOR8h7n3VYY3Rz
	UuexT6f+/rjlfIn3VrSw4vcnAucY+G/ff/+lREnpey/ng006s7pU+SKvbl/0ZubRJ6uWrtdZ
	Nfnv1yXq619aPHXX+j550YwCf48EiXmXOG933z6rxFKckWioxVxUnAgA+oi7UMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO72O6qBBve6dS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpEJcxgLDnBUdLdMZGtg
	bGbvYuTgkBAwkZi9IayLkRPIFJO4cG89G4gtJDCdUeLXb+EuRi4gezaTxKH7H1lAEmwCahJf
	vhwG6xUR0Jdoa9EAqWEW6GWUONO7mx2i2VZizodrzCA2p4CdxOVtX1hBbGEBD4kl/8+B1bAI
	qErcOvkYLM4LVP9i40QoW1Dix+R7YLuYBbQk1u88zgRhy0tsXvOWGeJmdYlHf3VBwiICRhLv
	909jhigRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERy1z6R2MK5ssDjEKMDBqMTDu+ClSqAQa2JZcWXuIUYJDmYlEV7F26qBQrwpiZVVqUX5
	8UWlOanFhxiTgR6dyCwlmpwPTCh5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2a
	WpBaBLOFiYNTqoFxTj2T0r6gqb3c0k/umenVfDRYMnW6/PHQ6yuevttputJWqTfP6I7Rl1U7
	J1TNvrD2LnPfIfH7/k2eLYaHass4eifMTpfNn+9deIqx4cYVA93LcTnMk1yM5uY33Hmj6Bnd
	vtblikbCHsNdyx0Psl0pkX/3dkVOyIe3k6Ld2qYHPZLRj7hzb9MFJZbijERDLeai4kQA30+C
	8h4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max8907.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-max8907.c b/drivers/rtc/rtc-max8907.c
index 1d049da..31ca8fa 100644
--- a/drivers/rtc/rtc-max8907.c
+++ b/drivers/rtc/rtc-max8907.c
@@ -205,8 +205,9 @@ static int max8907_rtc_probe(struct platform_device *pdev)
 		goto err_unregister;
 	}
 
-	ret = request_threaded_irq(rtc->irq, NULL, max8907_irq_handler,
-				   IRQF_ONESHOT, "max8907-alarm0", rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				max8907_irq_handler,
+				IRQF_ONESHOT, "max8907-alarm0", rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request IRQ%d: %d\n",
 			rtc->irq, ret);
@@ -224,7 +225,6 @@ static int max8907_rtc_remove(struct platform_device *pdev)
 {
 	struct max8907_rtc *rtc = platform_get_drvdata(pdev);
 
-	free_irq(rtc->irq, rtc);
 	rtc_device_unregister(rtc->rtc_dev);
 
 	return 0;
-- 
1.7.2.5


