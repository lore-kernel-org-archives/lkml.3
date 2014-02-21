Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaBUKYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:24:40 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38022 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaBUKYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <1392909541-10285-1-git-send-email-k.kozlowski@samsung.com>
References: <1392909541-10285-1-git-send-email-k.kozlowski@samsung.com>
Date: Fri, 21 Feb 2014 15:54:38 +0530
Message-ID: <CAK9yfHxQOroe2JZVs8roBVGxLXMMKdtA21JVjVW7z6Ndf-mytg@mail.gmail.com>
Subject: Re: [PATCH] regulator: max14577: Fix invalid return value on DT parse success
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 20 February 2014 20:49, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> This fixes bug introduced in 667a6b7a (regulator: max14577: Add missing
> of_node_put). The DTS parsing function returned number of matched
> regulators as success status which then was compared against 0 in probe.
>
> Result was a probe fail after successful parsing the DTS:
> max14577-regulator: probe of max14577-regulator failed with error 2
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/regulator/max14577.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
> index 186df8785a91..6ba11a8dd23d 100644
> --- a/drivers/regulator/max14577.c
> +++ b/drivers/regulator/max14577.c
> @@ -168,11 +168,13 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
>                         MAX14577_REG_MAX);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
> +               of_node_put(np);
> +               return ret;
>         }
>
>         of_node_put(np);
>
> -       return ret;
> +       return 0;
>  }

Instead of so many changes here, you could simply make the following change
in the max14577_regulator_probe function.

ret = max14577_regulator_dt_parse_pdata(pdev);
if (ret < 0)
        return ret;

-- 
With warm regards,
Sachin
