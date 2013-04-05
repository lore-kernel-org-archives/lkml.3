Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161096Ab3DEBtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:49:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41431 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161025Ab3DEBtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:49:05 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-2c-515e2d860e46
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
In-reply-to: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
Subject: [PATCH 5/7] rtc: rtc-ds1390: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:48:54 +0900
Message-id: <000501ce319f$babfdbe0$303f93a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xn4fH39zvwb7bR32L9HOXANRbigAACuOQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY9023bhAg8Z9ShZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBl9E9bzVKwma3iaud3pgbG5axdjJwcEgImEh+37ICyxSQu3FvP1sXIxSEksIxR4s/U
	fjaYonNvp7BDJBYxSvzcuA2q6hejROOkH4wgVWwCahJfvhwGquLgEBHQl2hr0QCpYRboZZQ4
	07ubHaRGSMBWYvWfHhYQm1PATuLrvA2MIPXCAtYSt17KgoRZBFQlzvQ8AivnBSq/vuEFE4Qt
	KPFj8j2wVmYBLYn1O48zQdjyEpvXvGUGGSMhoC7x6K8uSFhEwEji3NXrjBAlIhL7XrxjBDlH
	QuAeu8SvbV+YIHYJSHybfIgFoldWYtMBZoh/JSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKs
	YhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ1P4djHcPWB9iTAZaP5FZSjQ5HxjpeSXxhsZm
	RhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg5KtXPlG3YNWT
	6GK34+V7yqce3pU3l2Oh0t4jPtJzJ6+/7q5Yofv8meJn1mcrqwLi3fZEZIn2SkRvvDA75Fri
	iZ48+303NvnXykQdnVZ9b/68zLa194+8vZJnzxJYICfZb3iwMsTs4tEDC37nv2AyfrbYzavL
	NHjrIu/vEpWLO/pKZ+1InGato8RSnJFoqMVcVJwIADy6TyDqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd023bhAg20PZC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOiftpqlYDNbxdXO70wNjMtZuxg5OSQETCTO
	vZ3CDmGLSVy4t56ti5GLQ0hgEaPEz43boJxfjBKNk34wglSxCahJfPlyGKiDg0NEQF+irUUD
	pIZZoJdR4kzvbrBJQgK2Eqv/9LCA2JwCdhJf521gBKkXFrCWuPVSFiTMIqAqcabnEVg5L1D5
	9Q0vmCBsQYkfk++BtTILaEms33mcCcKWl9i85i0zyBgJAXWJR391QcIiAkYS565eZ4QoEZHY
	9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcBp5J
	7WBc2WBxiFGAg1GJhzejLzZQiDWxrLgy9xCjBAezkgjvTr64QCHelMTKqtSi/Pii0pzU4kOM
	yUCPTmSWEk3OB6aovJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLg
	lGpg7F6x/cK6lz4+vxuPM3C8tLbQO9C3zjbvgP70jb92O8b1TZNaN0XwuVNOGNdvrRx7HfVt
	tnstSxfb/Lvu2fogtjba+Hmsksj+z+LKV7Yt8bhcqvomcemjmYyfpp/+m3d6RYOj+tGdKU1f
	w9duuf/efutjR+HlpyJKrz1ImvKHpyNI7ts3Qfe5r5RYijMSDbWYi4oTAXRGf9BHAwAA
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
 drivers/rtc/rtc-ds1390.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index f994257..11b7076 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -136,7 +136,7 @@ static int ds1390_probe(struct spi_device *spi)
 		dev_err(&spi->dev, "unable to allocate device memory\n");
 		return -ENOMEM;
 	}
-	dev_set_drvdata(&spi->dev, chip);
+	spi_set_drvdata(spi, chip);
 
 	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
 	if (res != 0) {
-- 
1.7.2.5


