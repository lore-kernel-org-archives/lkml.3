Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3AKUWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:22:13 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:41288 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3AKUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:22:11 -0500
MIME-Version: 1.0
In-Reply-To: <50EF3BAF.4010200@wwwdotorg.org>
References: <1355343907-11535-1-git-send-email-linus.walleij@stericsson.com>
	<50EF27B4.60608@wwwdotorg.org>
	<50EF3BAF.4010200@wwwdotorg.org>
Date: Fri, 11 Jan 2013 21:22:10 +0100
Message-ID: <CACRpkdaHL=fj6f6a0AH0DaYzxRCen28rUv46O8yZ00gu81n1+Q@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Kevin Hilman <khilman@ti.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mitch Bradley <wmb@firmworks.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 11:07 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> I see that an attempt was made to solve this problem, in the patch
> immediately preceding this one (at least, as applied in the pinctrl
> tree). However, that patch only addresses the case where the pin
> controller is being looked up in the map, and not the case when
> converting device tree to the map in the first place. The patch below
> solves this:
>
> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
> index fe2d1af..fd40a11 100644
> --- a/drivers/pinctrl/devicetree.c
> +++ b/drivers/pinctrl/devicetree.c
> @@ -141,6 +141,11 @@ static int dt_to_map_one_config(struct pinctrl *p,
> const char *statename,
>                 pctldev = find_pinctrl_by_of_node(np_pctldev);
>                 if (pctldev)
>                         break;
> +               /* Do not defer probing of hogs (circular loop) */
> +               if (np_pctldev == p->dev->of_node) {
> +                       of_node_put(np_pctldev);
> +                       return -ENODEV;
> +               }
>         }
>         of_node_put(np_pctldev);

OK I've duplicated this, will send out as patch.

Yours,
Linus Walleij
