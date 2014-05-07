Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaEGGHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:07:30 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36544 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaEGGH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <1399325340-20416-1-git-send-email-b.galvani@gmail.com>
References: <1399325340-20416-1-git-send-email-b.galvani@gmail.com>
Date: Wed, 7 May 2014 11:37:25 +0530
X-Google-Sender-Auth: ogj0fSz1clYyPyJ9s_zEmIqsbmo
Message-ID: <CAOh2x=mWqa=p2d1kRjf0_37DiioJZOJm3Ewv2xpMrNjPy69rvA@mail.gmail.com>
Subject: Re: [PATCH] pwm: spear: fix check on pwmchip_add() return value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 2:59 AM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> pwmchip_add() returns zero on success and a negative value on error,
> so the condition of the check must be inverted.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/pwm/pwm-spear.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> index cb2d4f0..945556d 100644
> --- a/drivers/pwm/pwm-spear.c
> +++ b/drivers/pwm/pwm-spear.c
> @@ -222,7 +222,7 @@ static int spear_pwm_probe(struct platform_device *pdev)
>         }
>
>         ret = pwmchip_add(&pc->chip);
> -       if (!ret) {
> +       if (ret < 0) {
>                 clk_unprepare(pc->clk);
>                 dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
>         }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
