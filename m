Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaI3VWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:22:31 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:39098 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaI3VWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:22:09 -0400
MIME-Version: 1.0
In-Reply-To: <1412087707-8313-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412087707-8313-1-git-send-email-pramod.gurav@smartplayin.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 30 Sep 2014 14:21:45 -0700
Message-ID: <CAK5ve-KCYHySjs4f+rd+kAvKQmTkJqsq87Muq_j-D0nB7WSYjQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] led: remove use of gpiochip_remove() retval
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 7:35 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:
> Get rid of using return value from gpiochip_remove() as it returns
> void.
>

Looks good to me. I will merge it.

But what's in the first patch. I just got this second patch in my email inbox.

-Bryan

> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: linux-leds@vger.kernel.org
>
> Cc: linux-gpio@vger.kernel.org
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/leds/leds-pca9532.c |   10 ++--------
>  drivers/leds/leds-tca6507.c |    7 ++-----
>  2 files changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
> index 4a0e786..5a6363d 100644
> --- a/drivers/leds/leds-pca9532.c
> +++ b/drivers/leds/leds-pca9532.c
> @@ -319,14 +319,8 @@ static int pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
>         }
>
>  #ifdef CONFIG_LEDS_PCA9532_GPIO
> -       if (data->gpio.dev) {
> -               int err = gpiochip_remove(&data->gpio);
> -               if (err) {
> -                       dev_err(&data->client->dev, "%s failed, %d\n",
> -                                               "gpiochip_remove()", err);
> -                       return err;
> -               }
> -       }
> +       if (data->gpio.dev)
> +               gpiochip_remove(&data->gpio);
>  #endif
>
>         return 0;
> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> index 3d9e267..20fa8e7 100644
> --- a/drivers/leds/leds-tca6507.c
> +++ b/drivers/leds/leds-tca6507.c
> @@ -667,11 +667,8 @@ static int tca6507_probe_gpios(struct i2c_client *client,
>
>  static void tca6507_remove_gpio(struct tca6507_chip *tca)
>  {
> -       if (tca->gpio.ngpio) {
> -               int err = gpiochip_remove(&tca->gpio);
> -               dev_err(&tca->client->dev, "%s failed, %d\n",
> -                       "gpiochip_remove()", err);
> -       }
> +       if (tca->gpio.ngpio)
> +               gpiochip_remove(&tca->gpio);
>  }
>  #else /* CONFIG_GPIOLIB */
>  static int tca6507_probe_gpios(struct i2c_client *client,
> --
> 1.7.9.5
>
