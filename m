Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3JOGVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:21:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36826 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3JOGVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:21:48 -0400
X-AuditID: cbfee691-b7fe06d0000008c4-22-525cdefa2e14
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: t.figa@samsung.com, sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        ben-linux@fluff.org, grant.likely@secretlab.ca, broonie@kernel.org,
        dianders@chromium.org, cpgs@samsung.com
Subject: [PATCH v2] i2c: s3c2410: dont need CPU_FREQ transitions for exynos
 series
Date: Tue, 15 Oct 2013 11:53:52 +0530
Message-id: <1381818232-12542-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkRvfXvZgggwn/DS0mrTvAZDH14RM2
	i5eHNC3OLjvIZvHqzEY2i46/XxgtLu+aw2Yx4/w+JotvW7YxWqyf8ZrFYuWJWcwO3B6zGy6y
	ePxd9YLZY9OqTjaPvi2rGD1+vtTxOHnqCYvH501yAexRXDYpqTmZZalF+nYJXBk9cw6wFpzk
	rrjYM4OpgfEMZxcjJ4eEgInEhbdr2SBsMYkL99YD2VwcQgJLGSXeTVnLBFN0bvpfdojEIkaJ
	rkmtjBBOD5PErTvtLCBVbAJmEgcXrWYHsUUEZCVaH6xhBrGZBd4zSpzq0AGxhQVCJKbdOw+2
	jkVAVaLvUSsriM0r4Crx4/dERohtihLdzyaA1XAKuEm87zoIFOcAWuYq0X1dDWSvhMAxdok9
	Z2cxQcwRkPg2+RALSI0E0N5NB5ghxkhKHFxxg2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV5
	6XrJ+bmbGIHxcfrfs4k7GO8fsD7EmAw0biKzlGhyPjC+8kriDY3NjCxMTUyNjcwtzUgTVhLn
	VW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuCOpPFVC/f+Pb9fri111z76Smbd9XdAi
	mY6lv3kbum5lvwybcjRc5ONUbu4oYf+Twp3TXrlc35XFFNewsMAwqvvP/e+XVGa/2jx/gvYB
	KRX+HJFszmfnfq9Y/nN6wQzXlLwjUt4r+Bg0aj/LO7xulAu8+Hrzv65l5xJt5t9/92/iep8N
	989VbFBiKc5INNRiLipOBACFthKXpQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jAd1f92KCDD7/0LCYtO4Ak8XUh0/Y
	LF4e0rQ4u+wgm8WrMxvZLDr+fmG0uLxrDpvFjPP7mCy+bdnGaLF+xmsWi5UnZjE7cHvMbrjI
	4vF31Qtmj02rOtk8+rasYvT4+VLH4+SpJywenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGHM6JlzgLXgJHfFxZ4ZTA2MZzi7GDk5JARMJM5N/8sOYYtJXLi3nq2L
	kYtDSGARo0TXpFZGCKeHSeLWnXYWkCo2ATOJg4tWg3WICMhKtD5YwwxiMwu8Z5Q41aEDYgsL
	hEhMu3eeDcRmEVCV6HvUygpi8wq4Svz4PZERYpuiRPezCWA1nAJuEu+7DgLFOYCWuUp0X1eb
	wMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw9D2T3sG4qsHiEKMAB6MSD+8P3pgg
	IdbEsuLK3EOMEhzMSiK8OdVAId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4HJoa8knhDYxNz
	U2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamB069XW+xNy7c0HWXVFkZ3x
	5hyaFyIOrDh8guntiZe2OxN+3Vm+7tq5SdZVoRvypEX79P+bH5bkldN95totPmny9sklRhdc
	UoMi7s74qdNdsn7+whWX3oZqSn2OqjvH9kr09JaoZ8mJR/oPlnyT5VEtiq12PKTz8rb5vEWu
	+8M43r0+NOPI0gMaSizFGYmGWsxFxYkATBJg6AIDAAA=
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
---
Changes since v1:
Use CONFIG_CPU_FREQ_S3C24XX instead of (CONFIG_CPU_FREQ & !CONFIG_EXYNOS)
As commented by Tomasz

 drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index cab1c91..97f14f7 100644
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

