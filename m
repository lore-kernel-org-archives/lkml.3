Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3KZEV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:21:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54657 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KZEVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:21:54 -0500
X-AuditID: cbfee691-b7f666d0000048b0-35-529421c9a173
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        ben-linux@fluff.org, grant.likely@secretlab.ca, broonie@kernel.org,
        dianders@chromium.org, cpgs@samsung.com, t.figa@samsung.com
Subject: [PATCH v4] i2c: s3c2410: dont need CPU_FREQ transitions for exynos
 series
Date: Tue, 26 Nov 2013 09:52:46 +0530
Message-id: <1385439767-18586-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkTvek4pQgg5vPzCwmrTvAZDH14RM2
	i5eHNC3OLjvIZvHqzEY2i46/XxgtLu+aw2Yx4/w+JotvW7YxWqyf8ZrFYuWJWcwO3B6zGy6y
	ePxd9YLZY9OqTjaPvi2rGD1+vtTxOHnqCYvH501yAexRXDYpqTmZZalF+nYJXBkTDmxgKrjN
	WzH1xQemBsY93F2MHBwSAiYSPQcruhg5gUwxiQv31rN1MXJxCAksZZTon7mTDSJhInHt4nEm
	iMR0RolVnSdYIJweJokTy9awglSxCZhJHFy0mh3EFhGQlWh9sIYZpIhZ4D2jxL3b3WAJYYEQ
	iYPT5jOB2CwCqhJnDt4Bi/MKuEqc/3OXHWKdokT3swlgqzkF3CTedx1kBDlVCKim+7oayEwJ
	gVPsEgcaX7FBzBGQ+Db5EAvEO7ISmw4wQ4yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9YoT
	c4tL89L1kvNzNzEC4+P0v2cTdzDeP2B9iDEZaNxEZinR5HxgfOWVxBsamxlZmJqYGhuZW5qR
	Jqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PRKfX1v8RtFTZL7T244u/0V/Xv
	prybW/DAV60v4/Wnju7ZG64a1W/fmvGDYentXMFP7W82mKx0uBdWU9qflZbUzpUjklrv/X+X
	aEP389VzNaR4rfLyrRYHbZz0xfFKauCjhbcFty5NSPpRbpf91nl2i/Ja75W2wRsPn7J1WJT3
	Zu4Ww0khV78rsRRnJBpqMRcVJwIAKV1zWaUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQd2TilOCDBru6lhMWneAyWLqwyds
	Fi8PaVqcXXaQzeLVmY1sFh1/vzBaXN41h81ixvl9TBbftmxjtFg/4zWLxcoTs5gduD1mN1xk
	8fi76gWzx6ZVnWwefVtWMXr8fKnjcfLUExaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8
	g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmTDiwgangNm/F1BcfmBoY93B3MXJySAiYSFy7eJwJwhaTuHBvPVsX
	IxeHkMB0RolVnSdYIJweJokTy9awglSxCZhJHFy0mh3EFhGQlWh9sIYZpIhZ4D2jxL3b3WAJ
	YYEQiYPT5oONZRFQlThz8A5YnFfAVeL8n7vsEOsUJbqfTWADsTkF3CTedx1k7GLkANrmKtF9
	XW0CI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHx90xqB+PKBotDjAIcjEo8vBKd
	k4OEWBPLiitzDzFKcDArifC63gcK8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4wNeSVxBsa
	m5ibGptamliYmFmSJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+PsFOapG9ibLmzqOmc+
	64yctf3DSTM/fY3cGpHg73Pq3I+ZMYs2vj1/dffqqymzo9+9esxR9WiymMcyaTkPdh6X91s0
	pTgYVFzio+p7GmZeeFPAt/KJpb5c+s19iX1LD0hx/d6t+y51qnjcqld6Gw7WsnneenlKikWm
	jLWu+ZNLuPjn4tkLDPYosRRnJBpqMRcVJwIAfmBHqQMDAAA=
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
Changes since v3:
As per discussion at https://patchwork.kernel.org/patch/3235091/
Post f023f8dd59 commit we should be using
ARM_S3C24XX_CPUFREQ instead of CPU_FREQ_S3C24XX

upstrea linux kernel and linuxsamsung already has the commit
f023f8dd59. Hence, rebasing the patch.

 drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bf8fb94..a77ce13 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -123,7 +123,7 @@ struct s3c24xx_i2c {
 	struct s3c2410_platform_i2c	*pdata;
 	int			gpios[2];
 	struct pinctrl          *pctrl;
-#ifdef CONFIG_CPU_FREQ
+#if defined(CONFIG_ARM_S3C24XX_CPUFREQ)
 	struct notifier_block	freq_transition;
 #endif
 };
@@ -843,7 +843,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c *i2c, unsigned int *got)
 	return 0;
 }
 
-#ifdef CONFIG_CPU_FREQ
+#if defined(CONFIG_ARM_S3C24XX_CPUFREQ)
 
 #define freq_to_i2c(_n) container_of(_n, struct s3c24xx_i2c, freq_transition)
 
-- 
1.7.10.4

