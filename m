Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3KZL3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:29:45 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53616 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3KZL3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:29:42 -0500
MIME-Version: 1.0
In-Reply-To: <1385439977-19077-1-git-send-email-ch.naveen@samsung.com>
References: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
	<1385439977-19077-1-git-send-email-ch.naveen@samsung.com>
Date: Tue, 26 Nov 2013 16:59:42 +0530
Message-ID: <CAK9yfHz1HL65megQ9vDZovZr9oBo8UsrgGS+umWiT9FmHrnK3Q@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, sjg@chromium.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        cpgs@samsung.com, Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2013 09:56, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch adds new compatible to support HSI2C module on Exynos5260
> HSI2C module on Exynos5260 needs to be reset during during initialization.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
[snip]
>
>  Required properties:
>    - compatible: value should be.
> -      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
> +       -> "samsung,exynos5-hsi2c", for i2c compatible with HSI2C available on
> +                               Exynos5250/5420 SoCs.

This string could be made more specific ("samsung,exynos5250-hsi2c")
now that we have variants for this.

> +       -> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
> +                               on Exynos5260 SoCs.
> +
>    - reg: physical base address of the controller and length of memory mapped
>      region.
>    - interrupts: interrupt number to the cpu.
> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
> index da39ff0..497ff91 100644
> --- a/drivers/i2c/busses/i2c-exynos5.c
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -184,14 +184,35 @@ struct exynos5_i2c {
>          * 2. Fast speed upto 1Mbps
>          */
>         int                     speed_mode;
> +
> +       /* Version of HS-I2C Hardware */
> +       unsigned int            version;
> +};
> +
> +enum hsi2c_version {
> +       EXYNOS_5,

ditto.

> +       EXYNOS_5260
>  };
>

-- 
With warm regards,
Sachin
