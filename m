Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaE0GbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:31:00 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40600 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaE0Ga6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <1401110423-5647-3-git-send-email-k.kozlowski@samsung.com>
References: <1401110423-5647-1-git-send-email-k.kozlowski@samsung.com>
	<1401110423-5647-3-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 27 May 2014 12:00:57 +0530
Message-ID: <CAKew6eXdmif5-A+sb7-HEd3fP739RNy8SbzpCVRJ6uDgkyFvoQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: s2mps11: Merge S2MPA01 driver
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 6:50 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Add S2MPA01 support to the s2mps11 regulator driver. This obsoletes the
> s2mpa01 regulator driver.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

> @@ -216,30 +250,20 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>                         ramp_delay = s2mps11->ramp_delay16;
>                 break;
>         case S2MPX_BUCK2:
> -               if (!ramp_delay) {
> -                       ramp_enable = 0;
> -                       break;
> -               }
> -

What if we want to disable ramp_delay from DT ?

> -               s2mps11->ramp_delay2 = ramp_delay;
> +               if (s2mps11->dev_type == S2MPS11X ||
> +                               ramp_delay > s2mps11->ramp_delay2)
> +                       s2mps11->ramp_delay2 = ramp_delay;
> +               else /* S2MPA01 && ramp_delay <= s2mpa01->ramp_delay24 */
> +                       ramp_delay = s2mps11->ramp_delay2;

Here ramp_delay = 0(ramp_disable case) is also getting over written,
if required to take care of it later.

>                 break;
>         case S2MPX_BUCK3:
> -               if (!ramp_delay) {
> -                       ramp_enable = 0;
> -                       break;
> -               }

[snip]

>
> -       if (!ramp_enable)
> -               goto ramp_disable;
> -
> -       /* Ramp delay can be enabled/disabled only for buck[2346] */
>         if (ramp_reg->enable_supported) {
> +               if (ramp_disable)

typo ?    if (!ramp_enable) / if (!ramp_delay) ?

> +                       goto ramp_disable;
> +


Also TBH, I can't get rationale behind this merge, As i can't see
considerable reduction in no of C code lines in comp of added
complexity.
 Is there considerable advantage in binary stats of single driver as
compare to independent drivers?


Regards,
Yadwinder
