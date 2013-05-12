Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3ELPKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:10:23 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52261 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3ELPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <1368173847-5661-20-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	<1368173847-5661-20-git-send-email-wsa@the-dreams.de>
Date: Sun, 12 May 2013 20:40:21 +0530
X-Google-Sender-Auth: DRk5egqlaRSGw6zqfZPyttaiD7U
Message-ID: <CAOh2x=koaTpBCKqXUtzzx6HbENfTT=mhZvr03LT_QYbiGKgrmw@mail.gmail.com>
Subject: Re: [RFC 19/42] drivers/pinctrl/spear: don't check resource with devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 1:47 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/pinctrl/spear/pinctrl-plgpio.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
> index 3e5a887..6b090be 100644
> --- a/drivers/pinctrl/spear/pinctrl-plgpio.c
> +++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
> @@ -528,18 +528,13 @@ static int plgpio_probe(struct platform_device *pdev)
>         struct resource *res;
>         int ret, irq, i;
>
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res) {
> -               dev_err(&pdev->dev, "invalid IORESOURCE_MEM\n");
> -               return -EBUSY;
> -       }
> -
>         plgpio = devm_kzalloc(&pdev->dev, sizeof(*plgpio), GFP_KERNEL);
>         if (!plgpio) {
>                 dev_err(&pdev->dev, "memory allocation fail\n");
>                 return -ENOMEM;
>         }
>
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         plgpio->base = devm_ioremap_resource(&pdev->dev, res);
>         if (IS_ERR(plgpio->base))
>                 return PTR_ERR(plgpio->base);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
