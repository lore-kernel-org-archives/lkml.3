Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab3FMILc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:11:32 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64193 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3FMIL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <201306130022.29341.heiko@sntech.de>
References: <201306102139.32444.heiko@sntech.de>
	<201306102140.29918.heiko@sntech.de>
	<51B88BD0.805@imgtec.com>
	<201306130022.29341.heiko@sntech.de>
Date: Thu, 13 Jun 2013 10:11:28 +0200
Message-ID: <CACRpkdb-vbdQJOeZvCEsKLatK-0BhEfUTJqmGURJGf1NWx__Ew@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig
 properties from a dt node
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: James Hogan <james.hogan@imgtec.com>,
        Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tisdagen den 13:e Juni 2013 klock 12:22 AM, skrev Heiko Stübner
<heiko@sntech.de>:
> Am Mittwoch, 12. Juni 2013, 16:55:12 schrieb James Hogan:

>> > +static struct pinconf_generic_dt_params dt_params[] = {
>> > +   { "bias-disable", PIN_CONFIG_BIAS_DISABLE, 0 },
>> > +   { "bias-high-impedance", PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0 },
>> > +   { "bias-bus-hold", PIN_CONFIG_BIAS_BUS_HOLD, 0 },
>> > +   { "bias-pull-up", PIN_CONFIG_BIAS_PULL_UP, 0 },
>> > +   { "bias-pull-down", PIN_CONFIG_BIAS_PULL_DOWN, 0 },
>> > +   { "bias-pull-pin-default", PIN_CONFIG_BIAS_PULL_PIN_DEFAULT, 0 },
>> > +   { "drive-push-pull", PIN_CONFIG_DRIVE_PUSH_PULL, 0 },
>> > +   { "drive-open-drain", PIN_CONFIG_DRIVE_OPEN_DRAIN, 0 },
>> > +   { "drive-open-source", PIN_CONFIG_DRIVE_OPEN_SOURCE, 0 },
>> > +   { "drive-strength", PIN_CONFIG_DRIVE_STRENGTH, 0 },
>> > +   { "input-schmitt-enable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 1 },
>> > +   { "input-schmitt-disable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 0 },
>> > +   { "input-schmitt", PIN_CONFIG_INPUT_SCHMITT, 0 },
>> > +   { "input-debounce", PIN_CONFIG_INPUT_DEBOUNCE, 0 },
>> > +   { "power-source", PIN_CONFIG_POWER_SOURCE, 0 },
>> > +   { "slew-rate", PIN_CONFIG_SLEW_RATE, 0 },
>> > +   { "low-power-mode", PIN_CONFIG_LOW_POWER_MODE, 0 },
>> > +   { "output-low", PIN_CONFIG_OUTPUT, 0, },
>> > +   { "output-high", PIN_CONFIG_OUTPUT, 1, },
>>
>> shouldn't half of these default to 1 instead of 0? i.e. it's much nicer
>> for the lone flag "bias-pull-up" to enable pull up rather than disable
>> it (you even do this in the DT example in the bindings doc).
>
> on closer inspection it seems that you may be right.

Heiko can you write a patch for this? You can hit both this code and
the Rockchip driver at the same time for sure. Please check that
the bindings are consistent.

> The documentation to the
> options in the pinconf-generic header even tells that for example the pull
> options do have a 0 or 1 argument.

Yeah. Well.

Actually there has been plans to have the argument represent the
number of Ohms on the pull-up, but we haven't seen any hardware
that can actually select that.

Maybe we should add that now? It will still be that != 0 implies
enablement on platforms that does not support specifying the
pull up/down resistance.

> But I'm not sure if I understand everything correctly :-) ... isn't the bias-
> disable the opposite of turning on a pull (like the sh-pfc/pinctrl does) and
> same with switching from one pull type to another, i.e. activating a pull up
> would turn off a pull down and on the whole making the argument redundant?

This is true, and the plan is surely for the core to not allow or print
a big fat warning if someone does something really stupid like
activate pull up and pull down at the same time (unless s/he's
constructing a heater radiator or something).

Currently we don't make any sanity checks like that, BUT your
generic parser could actually be extended to do that.

Patches welcome ;-)

> The only other candidate I could find was low-power-mode which really could
> use a "1" as default. All the other pinconf options either use custom
> arguments or ignore teir argument.

A "1" for what? Not quite following....

Yours,
Linus Walleij
