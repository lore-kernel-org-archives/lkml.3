Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3KZOHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:07:39 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36130 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3KZOHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:07:38 -0500
MIME-Version: 1.0
In-Reply-To: <1385473828-31078-2-git-send-email-k.kozlowski@samsung.com>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
	<1385473828-31078-2-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 26 Nov 2013 15:07:36 +0100
X-Google-Sender-Auth: jZ7RtWbzj1qwt_UFkhMCi0-sV3M
Message-ID: <CAMuHMdWdu2TsvUwmJ4rk3xhMXn4L7MQxdTWRvt80hNttt2sAfA@mail.gmail.com>
Subject: Re: [PATCH 1/5] rtc: s5m: Fix register updating by adding regmap for RTC
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 2:50 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On S5M8767A registers were not properly updated and read due to usage of
> the same regmap as the PMIC. This could be observed in various hangs,
> e.g. in infinite loop during waiting for UDR field change.
>
> On this chip family the RTC has different I2C address than PMIC so
> additional regmap is needed.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/sec-core.c           |   14 ++++++++++++++
>  drivers/rtc/rtc-s5m.c            |    2 +-
>  include/linux/mfd/samsung/core.h |    1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 34c18fb..a1a413a 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -166,6 +166,11 @@ static struct regmap_config s5m8767_regmap_config = {
>         .cache_type = REGCACHE_FLAT,
>  };
>
> +static struct regmap_config sec_rtc_regmap_config = {

const please

> --- a/include/linux/mfd/samsung/core.h
> +++ b/include/linux/mfd/samsung/core.h
> @@ -40,6 +40,7 @@ struct sec_pmic_dev {
>         struct device *dev;
>         struct sec_platform_data *pdata;
>         struct regmap *regmap;
> +       struct regmap *regmap_rtc;

Do you think it makes sense to rename the plain "regmap" to "regmap_pmic"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
