Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3JOG4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:56:30 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59241 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3JOG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <1381818232-12542-1-git-send-email-ch.naveen@samsung.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
	<1381818232-12542-1-git-send-email-ch.naveen@samsung.com>
Date: Tue, 15 Oct 2013 15:56:27 +0900
X-Google-Sender-Auth: hUIGqsGLfwJ2_0xRY9dfH2Mm_2Y
Message-ID: <CAH9JG2Xo2UgbP+VA=s908FSusELERh8kvSVyiyMX1H1Ue8uPSg@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: s3c2410: dont need CPU_FREQ transitions for
 exynos series
From: Kyungmin Park <kmpark@infradead.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, t.figa@samsung.com, sjg@chromium.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        wsa@the-dreams.de, ben-linux@fluff.org, grant.likely@secretlab.ca,
        broonie@kernel.org, dianders@chromium.org, cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 3:23 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> For Exynos4 and Exynos5 SoCs from Samsung the i2c clock is based
> on a fixed 66 MHz peripheral clock, and therefore is completely
> independent of the cpu frequency.
> Thus, registering for a CPU freq notifier is very wasteful.
>
> This patch modifes the code such that, i2c bus registers to
> cpu_freq_transition only if CONFIG_CPU_FREQ_S3C24XX is enabled.
>
> This change should save a bunch of cpufreq transitions calls
> which does not apply to exynos SoCs.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v1:
> Use CONFIG_CPU_FREQ_S3C24XX instead of (CONFIG_CPU_FREQ & !CONFIG_EXYNOS)
> As commented by Tomasz
>
>  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index cab1c91..97f14f7 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -123,7 +123,7 @@ struct s3c24xx_i2c {
>         struct s3c2410_platform_i2c     *pdata;
>         int                     gpios[2];
>         struct pinctrl          *pctrl;
> -#ifdef CONFIG_CPU_FREQ
> +#if defined(CONFIG_CPU_FREQ_S3C24XX)
>         struct notifier_block   freq_transition;
>  #endif
>  };
> @@ -843,7 +843,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c *i2c, unsigned int *got)
>         return 0;
>  }
>
> -#ifdef CONFIG_CPU_FREQ
> +#if defined(CONFIG_CPU_FREQ_S3C24XX)
>
>  #define freq_to_i2c(_n) container_of(_n, struct s3c24xx_i2c, freq_transition)
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
