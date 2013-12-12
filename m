Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3LLRgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:36:05 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:34451 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LLRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:36:01 -0500
MIME-Version: 1.0
In-Reply-To: <1386807102-15397-1-git-send-email-olof@lixom.net>
References: <1386807102-15397-1-git-send-email-olof@lixom.net>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 12 Dec 2013 09:35:39 -0800
Message-ID: <CAK5ve-J9LB3ESCnuT9euqO9JUCHeK6DZUVFJK4cJEG2fhXXBvQ@mail.gmail.com>
Subject: Re: [PATCH] leds: pwm: Remove a warning on non-DT platforms
To: Olof Johansson <olof@lixom.net>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 4:11 PM, Olof Johansson <olof@lixom.net> wrote:
> This removes a warning on non-DT-enabled platforms:
>
> drivers/leds/leds-pwm.c: In function 'led_pwm_create_of':
> drivers/leds/leds-pwm.c:88:22: warning: unused variable 'node'
>
> Really caused by the local variable that is assigned to and then never
> used. Just do away with the local var, it's not needed.
>
> Technically this code path can never be entered without DT enabled,
> since there's an earlier check about number of children in the calling
> function, but the compiler can't see that.
>

Great, actually we got an 0-Day kbuild warning about this. I'll merge
this fixing.

Thanks,
-Bryan

> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/leds/leds-pwm.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index b31d8e99..bf49547 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -85,11 +85,10 @@ static inline size_t sizeof_pwm_leds_priv(int num_leds)
>  static int led_pwm_create_of(struct platform_device *pdev,
>                              struct led_pwm_priv *priv)
>  {
> -       struct device_node *node = pdev->dev.of_node;
>         struct device_node *child;
>         int ret;
>
> -       for_each_child_of_node(node, child) {
> +       for_each_child_of_node(pdev->dev.of_node, child) {
>                 struct led_pwm_data *led_dat = &priv->leds[priv->num_leds];
>
>                 led_dat->cdev.name = of_get_property(child, "label",
> --
> 1.7.10.4
>
