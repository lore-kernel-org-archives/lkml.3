Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbaFKOER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:04:17 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41204 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaFKOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:04:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAGb2v64f8Wju6dtVuVN2x=9YVGA-=RXozzhpJZNspKZ05f=jtA@mail.gmail.com>
References: <1400582523-22684-1-git-send-email-grygorii.strashko@ti.com>
	<20140523080333.66720C4176E@trevor.secretlab.ca>
	<CAGa+x85mOHtNAj-UHgK2_z8zWAF=qwFcRcUgHTR-byNiX7heHA@mail.gmail.com>
	<CAL_JsqLm3wfVS+au+JUbhBhxz=LuVpepH6GxabCQhPowhbw77g@mail.gmail.com>
	<20140528071855.GJ4227@lee--X1>
	<CACRpkdYgkEOjLamYu5uKSgs3iTNJ-w5XkbeygKjRdR-bNdETfg@mail.gmail.com>
	<CAGb2v64f8Wju6dtVuVN2x=9YVGA-=RXozzhpJZNspKZ05f=jtA@mail.gmail.com>
Date: Wed, 11 Jun 2014 16:04:14 +0200
Message-ID: <CACRpkdadSYFG-KaVYmUnf+gKzFKgEQBhABK7RWVgUv=sX-Up-g@mail.gmail.com>
Subject: Re: [PATCH v1] of/irq: do irq resolution in platform_get_irq_byname()
From: Linus Walleij <linus.walleij@linaro.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:49 AM, Chen-Yu Tsai <wens@csie.org> wrote:

> Log says musb is wrestling control over some pins with some other driver:
>
> [    1.441497] pinctrl-nomadik soc:pinctrl: pin GPIO256_AF28 already
> requested by a03e0000.usb_per5; cannot claim for musb-hdrc.0.auto
> [    1.453369] pinctrl-nomadik soc:pinctrl: pin-256 (musb-hdrc.0.auto)
> status -22
> [    1.460571] pinctrl-nomadik soc:pinctrl: could not request pin 256
> (GPIO256_AF28) from group usb_a_1  on device pinctrl-nomadik
> [    1.472076] musb-hdrc musb-hdrc.0.auto: Error applying setting,
> reverse things back
> [    1.479827] HS USB OTG: no transceiver configured
> [    1.484558] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed
> with status -517
> [    1.492309] platform musb-hdrc.0.auto: Driver musb-hdrc requests
> probe deferral
> [    1.500183] pinctrl-nomadik soc:pinctrl: pin GPIO256_AF28 already
> requested by a03e0000.usb_per5; cannot claim for musb-hdrc.0.auto
> [    1.512023] pinctrl-nomadik soc:pinctrl: pin-256 (musb-hdrc.0.auto)
> status -22
> [    1.519226] pinctrl-nomadik soc:pinctrl: could not request pin 256
> (GPIO256_AF28) from group usb_a_1  on device pinctrl-nomadik
> [    1.530731] musb-ux500 musb-hdrc.0.auto: Error applying setting,
> reverse things back
> [    1.539184] pinctrl-nomadik soc:pinctrl: pin GPIO256_AF28 already
> requested by a03e0000.usb_per5; cannot claim for musb-hdrc.1.auto
> [    1.551025] pinctrl-nomadik soc:pinctrl: pin-256 (musb-hdrc.1.auto)
> status -22
> [    1.558258] pinctrl-nomadik soc:pinctrl: could not request pin 256
> (GPIO256_AF28) from group usb_a_1  on device pinctrl-nomadik
> [    1.569732] musb-hdrc musb-hdrc.1.auto: Error applying setting,
> reverse things back
> [    1.577453] HS USB OTG: no transceiver configured
>
> [ .. repeats until the end .. ]
>
> I think this is not related to this patch.

No that is fixed i this patch:
http://marc.info/?l=linux-usb&m=140239049219096&w=2

Yours,
Linus Walleij
