Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbaFYLNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:13:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37763 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaFYLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:13:26 -0400
X-AuditID: cbfee68f-b7fef6d000003970-7e-53aaaec79b0a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Wolfram Sang'" <wsa@the-dreams.de>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>, javier.martinez@collabora.co.uk,
        ch.naveen@samsung.com, jg1.han@samsung.com, jdelvare@suse.de,
        sjg@google.com, paul.gortmaker@windriver.com, standby24x7@gmail.com,
        sachin.kamat@linaro.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1403654093-24134-1-git-send-email-dianders@chromium.org>
In-reply-to: <1403654093-24134-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v2] i2c: exynos5: Properly use the "noirq" variants of
 suspend/resume
Date: Wed, 25 Jun 2014 20:13:10 +0900
Message-id: <02e701cf9066$7332b280$59981780$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGyiE8TS+613P5fHuR1PgZLY1yu/Ju7u5kw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zI93j61YFG3z5IWtx9/lhRouzyw6y
	WRz9XWCx9O4nNovLCy+xWmx6fI3VouPvF0aLy7vmsFnMOL+PyeLa3uPMFif/9DJa/Dz2ndni
	0ozr7Bardv1htFh5YhazA7/H7IaLLB5/n19n8dg56y67x4JNpR53ru1h89i8pN6jb8sqRo/N
	p6s9Tp56wuLxeZOcx/otW5kCuKO4bFJSczLLUov07RK4Ml4/281UMEew4sGb08wNjDP5uhg5
	OSQETCT+vm1mh7DFJC7cW88GYgsJLGOUeLtUCKbm9JT3TF2MXEDxRYwSryf9Z4Fw/jJKfH56
	gAmkik1AQ+Lw+2dgk0QE/CUuLVnOBlLELPCBSeLM8mNQY10lLj05wApicwq4SZz9sgjMFhaI
	llg+axpYDYuAqsTdZYuYQWxeAUuJc3ua2SBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGq
	gsSOs68Zuxg5gI4wkni5KQGiRERi34t3jCD3SAhc4JBYf/g2I8QuAYlvkw+xgNRLCMhKbDoA
	NUZS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2M
	kBTSv4Px7gHrQ4zJQOsnMkuJJucDU1BeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamDk+BRZPo13+euLwvsfmO++yZI0RVJK0v7FQ2vRrvLsF6+W
	yzRpyZ/0+GZT9Ml02k/Ttfc3VsjMvKJd+8x9SZ5VyNc3fVZXrX9aTZpw8XqJ2pql961FzObN
	uF18yu/lwgvcU+uL9j4rnLV2vzDvus3Nv5yzE1JcvrRzuu7U4GeqmJo2W8xM0KNUiaU4I9FQ
	i7moOBEAiOJqQzcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jAd3j61YFG0z/LGFx9/lhRouzyw6y
	WRz9XWCx9O4nNovLCy+xWmx6fI3VouPvF0aLy7vmsFnMOL+PyeLa3uPMFif/9DJa/Dz2ndni
	0ozr7Bardv1htFh5YhazA7/H7IaLLB5/n19n8dg56y67x4JNpR53ru1h89i8pN6jb8sqRo/N
	p6s9Tp56wuLxeZOcx/otW5kCuKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgD5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MWa8frabqWCOYMWDN6eZGxhn8nUxcnJICJhInJ7yngnCFpO4cG89WxcjF4eQwCJGideT/rNA
	OH8ZJT4/PQBWxSagIXH4/TN2EFtEwF/i0pLlYB3MAh+YJM4sP8YGkhAScJW49OQAK4jNKeAm
	cfbLIjBbWCBaYvmsaWA1LAKqEneXLWIGsXkFLCXO7Wlmg7AFJX5MvscCYjMLaEms33mcCcKW
	l9i85i0zxKkKEjvOvmbsYuQAOsJI4uWmBIgSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEp6pn0DsZVDRaHGAU4GJV4eC/MXhksxJpYVlyZ
	e4hRgoNZSYTXcc6qYCHelMTKqtSi/Pii0pzU4kOMpkCPTmSWEk3OB6bPvJJ4Q2MTMyNLIzML
	IxNzcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFLAdCMjkfFTf8+dtMdHM78fnOfe8/ivqPdU
	jtAfidsVBX7l2tjufnLEdhWDFY+HoZq69e8cnn/ORapXSx++//e76nyyyYeqnteNP7Zweax0
	2nmzNHne4Q81365/Lj2UqGYfZjZlxW0F3veGLI5XvsTy9exuKpju6trrc1p4qdC5YNOvbz7s
	4197QImlOCPRUIu5qDgRAFGnfcFnAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> The original code for the exynos i2c controller registered for the
> "noirq" variants.  However during review feedback it was moved to
> SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
> longer actually "noirq" (despite functions named
> exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).
> 
> i2c controllers that might have wakeup sources on them seem to need to
> resume at noirq time so that the individual drivers can actually read
> the i2c bus to handle their wakeup.
> 
> NOTE: I took the original review feedback from Wolfram and added
> poweroff, thaw, freeze, restore.
> 
Yeah I'm not sure except .suspend_noirq and .resume_noirq but I'm fine if
Wolfram suggested ;-)

> This patch has only been compile-tested since I don't have all the
> patches needed to make my machine using this i2c driver actually
> suspend/resume.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Added missing CONFIG_PM_SLEEP
> 
>  drivers/i2c/busses/i2c-exynos5.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-
> exynos5.c
> index 63d2292..348b1cd 100644
> --- a/drivers/i2c/busses/i2c-exynos5.c
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -789,8 +789,16 @@ static int exynos5_i2c_resume_noirq(struct device *dev)
>  }
>  #endif
> 
> -static SIMPLE_DEV_PM_OPS(exynos5_i2c_dev_pm_ops, exynos5_i2c_suspend_noirq,
> -			 exynos5_i2c_resume_noirq);
> +const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {

Maybe static const struct...?

> +#ifdef CONFIG_PM_SLEEP
> +	.suspend_noirq = exynos5_i2c_suspend_noirq,
> +	.resume_noirq = exynos5_i2c_resume_noirq,
> +	.freeze_noirq = exynos5_i2c_suspend_noirq,
> +	.thaw_noirq = exynos5_i2c_resume_noirq,
> +	.poweroff_noirq = exynos5_i2c_suspend_noirq,
> +	.restore_noirq = exynos5_i2c_resume_noirq,
> +#endif
> +};
> 
>  static struct platform_driver exynos5_i2c_driver = {
>  	.probe		= exynos5_i2c_probe,
> --
> 2.0.0.526.g5318336

Others look good to me,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

