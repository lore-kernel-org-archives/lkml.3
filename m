Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3D2J0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:26:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24915 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3D2J0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:26:14 -0400
X-AuditID: cbfee690-b7f136d000000fea-ad-517e3cb43606
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND 1/2] watchdog: s3c2410_wdt: use dev_err()/dev_info()
 instead of pr_err()/pr_info()
Date: Mon, 29 Apr 2013 18:26:12 +0900
Message-id: <000701ce44bb$96f4ecd0$c4dec670$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Eu5YDELJI9Bl9SPmrAv0m6ldHZA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zY90tNnWBBn9/yFrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	/DrZy1TQwVGxZ/40pgbGW2xdjJwcEgImEu0rG5ghbDGJC/fWA8W5OIQEljFKXH+9lRGmaNm0
	n8wQiemMEst2LmOHcH4xSly7vpgJpIpNQE3iy5fDQAkODhEBfYm2Fg2QGmaBLkaJvc//sIPU
	CAtkS9x8d5sFxGYRUJX4NPsUWC+vgKVEw+wPzBC2oMSPyffAapgFtCTW7zzOBGHLS2xe8xbq
	VAWJHWdfg10nIqAn8e30ZkaIGhGJfS/eMYIslhDYxy7x6vFpdohlAhLfJh9iATlOQkBWYtMB
	qDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525i
	hETchB2M9w5YH2JMBlo/kVlKNDkfGLF5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamDUfbBGIrVoeh/DoZ7Dm+c/ddousWyZk07ZSd7GRRL7elvU
	AuMvnRXubGfbaG37VCZg+Tzvm1fnZ9/Vs2WI2fBbUGrWpfBZlzmOB96JPJEpv/C68Iyi5Hre
	eW+cFq07qyp4gXWmwvp5c3wu5VyO6vgX/9I4ZkLt5zM7VacdXndxvqHXTfZKoRepSizFGYmG
	WsxFxYkA88V/cc4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQd0tNnWBBvsnSlnMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZvw62ctU0MFRsWf+NKYGxltsXYycHBICJhLLpv1khrDF
	JC7cWw8U5+IQEpjOKLFs5zJ2COcXo8S164uZQKrYBNQkvnw5DJTg4BAR0Jdoa9EAqWEW6GKU
	2Pv8DztIjbBAtsTNd7dZQGwWAVWJT7NPgfXyClhKNMz+wAxhC0r8mHwPrIZZQEti/c7jTBC2
	vMTmNW+hLlKQ2HH2NSOILSKgJ/Ht9GZGiBoRiX0v3jFOYBSYhWTULCSjZiEZNQtJywJGllWM
	oqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfH8THoH46oGi0OMAhyMSjy8AZtrA4VYE8uKK3MP
	MUpwMCuJ8K6wrAsU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgqskriTc0NjEzsjQyszAy
	MTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk4pYGpSe3VM6tgdLre8OxG7ZsY7bkrt/CG2
	trH0itMpJwYfr8tCYeon5LpPe9aeLf/mdTtd4uMUs20Xu0r2hjm71gscMHuqVizVOcNSY73K
	OvsnGsl/92y0lC++ukp17+OJweaXfjAmzllW8+nSvADVRmGhue6fNkdujem5t371S4s96lpL
	JzyO9FNiKc5INNRiLipOBACr9jUlKwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_err()/dev_info() are more preferred than pr_err()/pr_info().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/s3c2410_wdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index ee03135..c9f480d 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -349,7 +349,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	ret = s3c2410wdt_cpufreq_register();
 	if (ret < 0) {
-		pr_err("failed to register cpufreq\n");
+		dev_err(dev, "failed to register cpufreq\n");
 		goto err_clk;
 	}
 
@@ -464,7 +464,7 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 	writel(wtdat_save, wdt_base + S3C2410_WTCNT); /* Reset count */
 	writel(wtcon_save, wdt_base + S3C2410_WTCON);
 
-	pr_info("watchdog %sabled\n",
+	dev_info(&dev->dev, "watchdog %sabled\n",
 		(wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
 	return 0;
-- 
1.7.2.5


