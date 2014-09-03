Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaICQOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:14:32 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:52523 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaICQOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:14:30 -0400
MIME-Version: 1.0
In-Reply-To: <1409742329-17411-1-git-send-email-linus.walleij@linaro.org>
References: <1409742329-17411-1-git-send-email-linus.walleij@linaro.org>
Date: Wed, 3 Sep 2014 09:14:25 -0700
Message-ID: <CAJAp7OgyriJHCLmF4EkdqVV-9_-ve4wRb-jQER9y9-Q4nhd81A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: clean up after enable refactoring
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-gpio@vger.kernel.org, Fan Wu <fwu@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 4:05 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
[..]
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 80a64cad907d..01eab47a746f 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -134,9 +134,9 @@ static int msm_get_function_groups(struct pinctrl_dev *pctldev,
>         return 0;
>  }
>
> -static int msm_pinmux_enable(struct pinctrl_dev *pctldev,
> -                            unsigned function,
> -                            unsigned group)
> +static int msm_pinmux_set_mux(struct pinctrl_dev *pctldev,
> +                             unsigned function,
> +                             unsigned group)
>  {
>         struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
>         const struct msm_pingroup *g;
> @@ -170,7 +170,7 @@ static const struct pinmux_ops msm_pinmux_ops = {
>         .get_functions_count    = msm_get_functions_count,
>         .get_function_name      = msm_get_function_name,
>         .get_function_groups    = msm_get_function_groups,
> -       .enable                 = msm_pinmux_enable,
> +       .set_mux                = msm_pinmux_set_mux,
>  };
>
>  static int msm_config_reg(struct msm_pinctrl *pctrl,

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
