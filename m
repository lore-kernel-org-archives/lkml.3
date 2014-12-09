Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaLITOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:14:09 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:65497 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaLITOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:14:07 -0500
MIME-Version: 1.0
In-Reply-To: <1418142714-29794-1-git-send-email-fabio.estevam@freescale.com>
References: <1418142714-29794-1-git-send-email-fabio.estevam@freescale.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 9 Dec 2014 11:13:45 -0800
Message-ID: <CAK5ve-KHd86BxLhk=JC6vspgE7E_W3A3ArrjHsGp41_iuke7fA@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-gpio: Fix the "default-state" property check
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Fabio Estevam <festevam@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 8:31 AM, Fabio Estevam
<fabio.estevam@freescale.com> wrote:
> Commit a43f2cbbb009f9 ("leds: leds-gpio: Make use of device property API")
> caused a regression by reading the incorrect string for the "default-state"
> property.
>
> Fix the property string check to restore the original behaviour.
>
> Fixes: a43f2cbbb009 (leds: leds-gpio: Make use of device property API)

Thanks, please take my Ack
Acked-by: Bryan Wu <cooloney@gmail.com>

I think Rafael will take this fix with other patches through his tree.


> Reported-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/leds/leds-gpio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 8a8ba11..7ea1ea42 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -203,7 +203,7 @@ static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
>                 fwnode_property_read_string(child, "linux,default-trigger",
>                                             &led.default_trigger);
>
> -               if (!fwnode_property_read_string(child, "linux,default_state",
> +               if (!fwnode_property_read_string(child, "default-state",
>                                                  &state)) {
>                         if (!strcmp(state, "keep"))
>                                 led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
> --
> 1.9.1
>
