Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbbANSnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:43:22 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33902 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbbANSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <1421243519-6257-3-git-send-email-geert+renesas@glider.be>
References: <1421243519-6257-1-git-send-email-geert+renesas@glider.be> <1421243519-6257-3-git-send-email-geert+renesas@glider.be>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 14 Jan 2015 10:42:59 -0800
Message-ID: <CAK5ve-K2aKzSFB__bJ5Znd=-iYbHJX7JkBmiH9ndf9S4kNs+9g@mail.gmail.com>
Subject: Re: [PATCH 2/3] leds: leds-mc13783: Use of_get_child_by_name()
 instead of refcount hack
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 5:51 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> of_find_node_by_name() calls of_node_put() on its "from" parameter.
> To counter this, mc13xxx_led_probe_dt() calls of_node_get() first.
>
> Use of_get_child_by_name() instead to get rid of the refcount hack.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: linux-leds@vger.kernel.org

Looks good, applied to my tree.
Thanks,
-Bryan


> ---
> Compile-tested only
> ---
>  drivers/leds/leds-mc13783.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
> index 85c3714e1b5aabba..e2b847fe22a1c934 100644
> --- a/drivers/leds/leds-mc13783.c
> +++ b/drivers/leds/leds-mc13783.c
> @@ -134,9 +134,7 @@ static struct mc13xxx_leds_platform_data __init *mc13xxx_led_probe_dt(
>         if (!pdata)
>                 return ERR_PTR(-ENOMEM);
>
> -       of_node_get(dev->parent->of_node);
> -
> -       parent = of_find_node_by_name(dev->parent->of_node, "leds");
> +       parent = of_get_child_by_name(dev->parent->of_node, "leds");
>         if (!parent)
>                 goto out_node_put;
>
> --
> 1.9.1
>
