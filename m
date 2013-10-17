Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3JQMp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:45:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36055 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JQMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:45:55 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-6c-525fdc01e7de
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] spi: spi-s3c64xx: Add missing pm_runtime_put on setup fail
Date: Thu, 17 Oct 2013 14:45:41 +0200
Message-id: <1382013941-861-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xy7qMd+KDDGaf07WYtO4Ak8XUh0/Y
	LF6/MLToXXCVzWLT42usFpd3zWGzmHF+H5NF48eb7BaH37SzOnB6/F31gtlj06pONo/NS+o9
	+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+PE2bNMBWtYK7b9m8PUwLiLpYuRk0NCwETiyc6v
	7BC2mMSFe+vZuhi5OIQEljJKfD6/jBHC6WOS2PlrAlgHm4CxxOblS9hAbBGBLInb/7YwgxQx
	CzxjlPh78DErSEJYwFtiwc0/zCA2i4CqxIq2bjCbV8BVYuLDf0BTOYDWKUjMmWQzgZF7ASPD
	KkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQsPmyg3HxMatDjAIcjEo8vDOWxwUJsSaWFVfm
	HmKU4GBWEuHdsj0+SIg3JbGyKrUoP76oNCe1+BAjEwenVAOj+sLE6Y7xMnyH18Xw9rOKP5y7
	eHtmc9TOB20S/Y/msx4N2n2J5+W/2yb+cR4+mz0y2xsmG5rrKsbrXX3eN/3tz2VqR0Vrtxuq
	9UycIu1VvujSGtkFof+emhw8Gtbz/PF7xqBVt8/9MitynbFtj8P60hcND8U8DDoitwjw3vSJ
	m31p+ao5/xr9lFiKMxINtZiLihMBcCF8NPkBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_runtime_put() wasn't called if clock rate could not be set up in
s3c64xx_spi_setup() leading to invalid count of device pm_runtime usage.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index a80376d..0ddaff2 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1121,6 +1121,7 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 	return 0;
 
 setup_exit:
+	pm_runtime_put(&sdd->pdev->dev);
 	/* setup() returns with device de-selected */
 	disable_cs(sdd, spi);
 
-- 
1.7.9.5

