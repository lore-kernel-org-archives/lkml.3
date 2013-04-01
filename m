Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab3DAEsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 00:48:35 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33994 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3DAEse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 00:48:34 -0400
MIME-Version: 1.0
In-Reply-To: <1364784565.7725.2.camel@phoenix>
References: <1364784493.7725.1.camel@phoenix>
	<1364784565.7725.2.camel@phoenix>
Date: Mon, 1 Apr 2013 10:18:33 +0530
Message-ID: <CAKohponR=1=nobZYJAG5BNCme5K2wZ7j3=zvFs1E_mK_cupU0w@mail.gmail.com>
Subject: Re: [PATCH 2/2] pwm: mxs: Remove unused *dev from struct spear_pwm_chip
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 April 2013 08:19, Axel Lin <axel.lin@ingics.com> wrote:

Apart from fixing subject you need to write something in logs too..

> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-spear.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> index 3223b57..9563599 100644
> --- a/drivers/pwm/pwm-spear.c
> +++ b/drivers/pwm/pwm-spear.c
> @@ -49,13 +49,11 @@
>   * @mmio_base: base address of pwm chip
>   * @clk: pointer to clk structure of pwm chip
>   * @chip: linux pwm chip representation
> - * @dev: pointer to device structure of pwm chip
>   */
>  struct spear_pwm_chip {
>         void __iomem *mmio_base;
>         struct clk *clk;
>         struct pwm_chip chip;
> -       struct device *dev;
>  };
>
>  static inline struct spear_pwm_chip *to_spear_pwm_chip(struct pwm_chip *chip)
> @@ -200,7 +198,6 @@ static int spear_pwm_probe(struct platform_device *pdev)
>         if (IS_ERR(pc->clk))
>                 return PTR_ERR(pc->clk);
>
> -       pc->dev = &pdev->dev;
>         platform_set_drvdata(pdev, pc);
>
>         pc->chip.dev = &pdev->dev;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
