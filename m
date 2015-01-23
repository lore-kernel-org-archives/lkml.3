Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbbAWApx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:45:53 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54964 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbbAWApr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:45:47 -0500
MIME-Version: 1.0
In-Reply-To: <1421973429-9663-1-git-send-email-mopsfelder@gmail.com>
References: <1421973429-9663-1-git-send-email-mopsfelder@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 23 Jan 2015 09:45:26 +0900
Message-ID: <CAAVeFuJxSmdP09s_kLMx2_+qc=XLHX65jMbAWy66vmADsswRgg@mail.gmail.com>
Subject: Re: [PATCH] gpio: sx150x: Fix compile issue when CONFIG_OF_GPIO is
 not defined
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, Wei.Chen@csr.com,
        Baohua.Song@csr.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 9:37 AM, Murilo Opsfelder Araujo
<mopsfelder@gmail.com> wrote:
> Without this patch, the compilation of gpio-sx150x.c fails because
> struct gpio_chip members 'of_node' and 'of_gpio_n_cells' do not exist
> when CONFIG_OF_GPIO is not defined:
>
> drivers/gpio/gpio-sx150x.c: In function ‘sx150x_init_chip’:
> drivers/gpio/gpio-sx150x.c:487:17: error: ‘struct gpio_chip’ has no member named ‘of_node’
>   chip->gpio_chip.of_node          = client->dev.of_node;
>                  ^
> drivers/gpio/gpio-sx150x.c:488:17: error: ‘struct gpio_chip’ has no member named ‘of_gpio_n_cells’
>   chip->gpio_chip.of_gpio_n_cells  = 2;
>                  ^
>
> This issue was introduced by the commit
> 04d2264c3bf07f5c3d18165ba78de0a93360c6c0 "gpio: sx150x: add dts support for sx150x driver".
>
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> ---
>  drivers/gpio/gpio-sx150x.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpio/gpio-sx150x.c b/drivers/gpio/gpio-sx150x.c
> index 88012e2..b1e2f1c 100644
> --- a/drivers/gpio/gpio-sx150x.c
> +++ b/drivers/gpio/gpio-sx150x.c
> @@ -484,8 +484,10 @@ static void sx150x_init_chip(struct sx150x_chip *chip,
>         chip->gpio_chip.base             = pdata->gpio_base;
>         chip->gpio_chip.can_sleep        = true;
>         chip->gpio_chip.ngpio            = chip->dev_cfg->ngpios;
> +#ifdef CONFIG_OF_GPIO
>         chip->gpio_chip.of_node          = client->dev.of_node;
>         chip->gpio_chip.of_gpio_n_cells  = 2;
> +#endif
>         if (pdata->oscio_is_gpo)
>                 ++chip->gpio_chip.ngpio;

Linus just sent a patch to fix this, see
http://patchwork.ozlabs.org/patch/431704/
