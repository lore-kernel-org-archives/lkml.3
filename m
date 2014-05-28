Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaE1JD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:03:57 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:52608 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbaE1JDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAGb2v64f8Wju6dtVuVN2x=9YVGA-=RXozzhpJZNspKZ05f=jtA@mail.gmail.com>
References: <1400582523-22684-1-git-send-email-grygorii.strashko@ti.com>
 <20140523080333.66720C4176E@trevor.secretlab.ca> <CAGa+x85mOHtNAj-UHgK2_z8zWAF=qwFcRcUgHTR-byNiX7heHA@mail.gmail.com>
 <CAL_JsqLm3wfVS+au+JUbhBhxz=LuVpepH6GxabCQhPowhbw77g@mail.gmail.com>
 <20140528071855.GJ4227@lee--X1> <CACRpkdYgkEOjLamYu5uKSgs3iTNJ-w5XkbeygKjRdR-bNdETfg@mail.gmail.com>
 <CAGb2v64f8Wju6dtVuVN2x=9YVGA-=RXozzhpJZNspKZ05f=jtA@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 28 May 2014 10:03:23 +0100
X-Google-Sender-Auth: OHiuB7FAFnHttITuO-shoCyXFfU
Message-ID: <CACxGe6ts-TcSKk2F0-XSxAxeTxVCiyDHgh-O12v+F2OjHUsPyg@mail.gmail.com>
Subject: Re: [PATCH v1] of/irq: do irq resolution in platform_get_irq_byname()
To: Chen-Yu Tsai <wens@csie.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 9:49 AM, Chen-Yu Tsai <wens@csie.org> wrote:
> On Wed, May 28, 2014 at 4:25 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Wed, May 28, 2014 at 9:18 AM, Lee Jones <lee.jones@linaro.org> wrote:
>>> On Tue, 27 May 2014, Rob Herring wrote:
>>>
>>>> On Tue, May 27, 2014 at 3:23 PM, Kevin Hilman <khilman@linaro.org> wrote:
>>>> > On Fri, May 23, 2014 at 1:03 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>>> >> On Tue, 20 May 2014 13:42:02 +0300, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>>>> >>> The commit 9ec36cafe43bf835f8f29273597a5b0cbc8267ef
>>>> >>> "of/irq: do irq resolution in platform_get_irq" from Rob Herring -
>>>> >>> moves resolving of the interrupt resources in platform_get_irq().
>>>> >>> But this solution isn't complete because platform_get_irq_byname()
>>>> >>> need to be modified the same way.
>>>> >>>
>>>> >>> Hence, fix it by adding interrupt resolution code at the
>>>> >>> platform_get_irq_byname() function too.
>>>> >>>
>>>> >>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> >>> Cc: Rob Herring <robh@kernel.org>
>>>> >>> Cc: Tony Lindgren <tony@atomide.com>
>>>> >>> Cc: Grant Likely <grant.likely@linaro.org>
>>>> >>> Cc: Thierry Reding <thierry.reding@gmail.com>
>>>> >>>
>>>> >>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>> >>
>>>> >> Applied, Thanks.
>>>> >
>>>> > As of next-20150526, the ST u8500 Snowball board has been failing boot
>>>> > in linux-next, and was bisected down to this patch (commit
>>>> > ad69674e73a1 in -next).   Full boot failure attached.
>>>> >
>>>> > I have not dug any deeper, but can confirm that next-20140526 with
>>>> > this patch reverted boots again on the snowball board.
>>>>
>>>> There's a patch on the list which fixes it. The problem is stmmac
>>>> driver was expecting only one error code.
>>>
>>> Does Snowball even use stmmac?
>>
>> No.
>>
>> I don't get this...
>
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

The bisected patch causes platform_get_irq() to always parse the
devicetree to obtain the irq instead of using a precalculated value in
the platform_device. There are two possible scenarios for this problem
that I can think of:
1) Platform_get_irq() is getting called multiple times (which would
happen on a deferred probe) but the setup code isn't handling it
properly, like trying to request the GPIO more than once
2) the platform_device was preloaded with an irq number that differs
from what is determined when parsing the tree. This would happen if a
platform_device was created manually.

g.
