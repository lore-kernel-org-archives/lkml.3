Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab3C3D5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:57:50 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46339 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab3C3D5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:57:49 -0400
MIME-Version: 1.0
In-Reply-To: <1364615166.3771.1.camel@phoenix>
References: <1364615166.3771.1.camel@phoenix>
Date: Sat, 30 Mar 2013 09:27:49 +0530
Message-ID: <CAKohpomWNH1XNMTc_BCMw-m7gf3200LD=h2ARuUV2670fHj+Pg@mail.gmail.com>
Subject: Re: [PATCH] pwm: spear: Fix enable pwm output
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2013 09:16, Axel Lin <axel.lin@ingics.com> wrote:
> The logic to check return value of clk_enable() is reversed, thus
> when clek_enable() success PWMCR_PWM_ENABLE bit is never set. Fix it.

s/clek/clk

And write it as:

The logic to check return value of clk_enable() is reversed, thus
when clk_enable() passes PWMCR_PWM_ENABLE bit is not set. Fix it.

>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-spear.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> index 69a2d9e..cccb430 100644
> --- a/drivers/pwm/pwm-spear.c
> +++ b/drivers/pwm/pwm-spear.c
> @@ -143,7 +143,7 @@ static int spear_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>         u32 val;
>
>         rc = clk_enable(pc->clk);
> -       if (!rc)
> +       if (rc)
>                 return rc;

This is okay but there is one more mistake like this in this driver.
Fix that too.
