Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597Ab3ECI2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:28:31 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:49620 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3ECI23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:28:29 -0400
MIME-Version: 1.0
In-Reply-To: <1367509690-24022-3-git-send-email-lee.jones@linaro.org>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
	<1367509690-24022-3-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 10:28:28 +0200
Message-ID: <CACRpkdaf75sQduyfw58PFmC1ZyNDMxpwAf0OSyRLPP6vFc+wBQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] mfd: ab8500-gpadc: Suppress 'ignoring
 regulator_enable() return value' warning
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 5:48 PM, Lee Jones <lee.jones@linaro.org> wrote:
> drivers/mfd/ab8500-gpadc.c: In function ‘ab8500_gpadc_resume’:
> drivers/mfd/ab8500-gpadc.c:911:18: warning: ignoring return value of
>         ‘regulator_enable’, declared with attribute warn_unused_result
>         [-Wunused-result]
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-gpadc.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
> index 5e65b28..7278e53 100644
> --- a/drivers/mfd/ab8500-gpadc.c
> +++ b/drivers/mfd/ab8500-gpadc.c
> @@ -907,8 +907,11 @@ static int ab8500_gpadc_suspend(struct device *dev)
>  static int ab8500_gpadc_resume(struct device *dev)
>  {
>         struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> +       int ret;
>
> -       regulator_enable(gpadc->regu);
> +       ret = regulator_enable(gpadc->regu);
> +       if (ret < 0)
> +               return ret;
>
>         pm_runtime_mark_last_busy(gpadc->dev);
>         pm_runtime_put_autosuspend(gpadc->dev);
> --
> 1.7.10.4

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
