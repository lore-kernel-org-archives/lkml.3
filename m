Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3KSGRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 01:17:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40885 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3KSGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 01:17:13 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-b0-528b0266d54e
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        ben-linux@fluff.org, grant.likely@secretlab.ca, broonie@kernel.org,
        dianders@chromium.org, cpgs@samsung.com, t.figa@samsung.com
Subject: [PATCH v3] i2c: s3c2410: dont need CPU_FREQ transitions for exynos
 series
Date: Tue, 19 Nov 2013 11:48:35 +0530
Message-id: <1384841915-8264-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkTjeNqTvI4NY0fotJ6w4wWUx9+ITN
	4uUhTYuzyw6yWbw6s5HNouPvF0aLy7vmsFnMOL+PyeLblm2MFutnvGaxWHliFrMDt8fshoss
	Hn9XvWD22LSqk82jb8sqRo+fL3U8Tp56wuLxeZNcAHsUl01Kak5mWWqRvl0CV8bxpXtZCn7y
	VBx7/Y29gfExVxcjJ4eEgInEy+lL2SBsMYkL99YD2VwcQgJLGSWu3m1hgSlauucXWJGQwCJG
	ifNHqiCKepgkbrTPZQZJsAmYSRxctJodxBYRkJVofbCGGaSIWeA9o8S9291gCWGBEIlV7buY
	QGwWAVWJD8cOgTXzCrhIND94BHWGokT3swlgNqeAm8T7roOMXYwcQNtcJbqvq4HMlBA4xi7x
	6tNKqDkCEt8mH2IBqZEAWrzpADPEGEmJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3uDQv
	XS85P3cTIzA+Tv971reD8eYB60OMyUDjJjJLiSbnA+MrryTe0NjMyMLUxNTYyNzSjDRhJXHe
	RQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwFkQrm8XVpE6aypZ4Sbr8jOtUwws1b+et
	ylJflvfnb/zt+G+P50wqtTQ+ZPrEV7LZUqzP9MLRD1n3Wmo/uvuuVmfd8vy44JPbkzN2X0r4
	fvC+29Wzsu/OznR6/3DTglaxqWkhZxbeffJS4MzVpcaTjN8reT23e+4WNfO0Z64sB/vv86oL
	vu789U+JpTgj0VCLuag4EQD7VJ1FpQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jAd00pu4gg0lz2CwmrTvAZDH14RM2
	i5eHNC3OLjvIZvHqzEY2i46/XxgtLu8Cqphxfh+Txbct2xgt1s94zWKx8sQsZgduj9kNF1k8
	/q56weyxaVUnm0ffllWMHj9f6nicPPWExePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/g
	eOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoBuVFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG
	6PqGBMH1GBmggYQ1jBnHl+5lKfjJU3Hs9Tf2BsbHXF2MnBwSAiYSS/f8YoOwxSQu3FsPZgsJ
	LGKUOH+kqouRC8juYZK40T6XGSTBJmAmcXDRanYQW0RAVqL1wRpmkCJmgfeMEvdud4MlhAVC
	JFa172ICsVkEVCU+HDsE1swr4CLR/OAR1DZFie5nE8BsTgE3ifddBxm7GDmAtrlKdF9Xm8DI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcPQ9k97BuKrB4hCjAAejEg/vBPeuICHW
	xLLiytxDjBIczEoivJJXgEK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD0wMeSXxhsYm5qbG
	ppYmFiZmlqQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAmHi+4Djr+29ve7Q6z+8WuaJ3
	PmBPV9jWlz/+TFD0UOxQcIr3+Sd6+1TBgoCjJ7s2FzLo3d/ds3Pznw0rZsw8e+v/yfhX/cZz
	ZOeLGR6YNH+b3+L4K4Vhz8VX3QkV6Dk4bQEH85MPn+4fT3LJbLZXzToWVnadt19wVdaJ/0tP
	V15QEC1elf/ixHklluKMREMt5qLiRAD6V04LAgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Exynos4 and Exynos5 SoCs from Samsung the i2c clock is based
on a fixed 66 MHz peripheral clock, and therefore is completely
independent of the cpu frequency.
Thus, registering for a CPU freq notifier is very wasteful.

This patch modifes the code such that, i2c bus registers to
cpu_freq_transition only if CONFIG_CPU_FREQ_S3C24XX is enabled.

This change should save a bunch of cpufreq transitions calls
which does not apply to exynos SoCs.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
Changes since v2:
None, Rebased on for-next of linux-i2c git repo.

Changes since v1:
Use CONFIG_CPU_FREQ_S3C24XX instead of (CONFIG_CPU_FREQ & !CONFIG_EXYNOS)
As commented by Tomasz

 drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bf8fb94..fa51dff 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -123,7 +123,7 @@ struct s3c24xx_i2c {
 	struct s3c2410_platform_i2c	*pdata;
 	int			gpios[2];
 	struct pinctrl          *pctrl;
-#ifdef CONFIG_CPU_FREQ
+#if defined(CONFIG_CPU_FREQ_S3C24XX)
 	struct notifier_block	freq_transition;
 #endif
 };
@@ -843,7 +843,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c *i2c, unsigned int *got)
 	return 0;
 }
 
-#ifdef CONFIG_CPU_FREQ
+#if defined(CONFIG_CPU_FREQ_S3C24XX)
 
 #define freq_to_i2c(_n) container_of(_n, struct s3c24xx_i2c, freq_transition)
 
-- 
1.7.10.4

