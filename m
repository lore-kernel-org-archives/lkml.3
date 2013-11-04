Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3KDMYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:24:13 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62417 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3KDMYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:24:11 -0500
MIME-Version: 1.0
In-Reply-To: <051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<1380846199-12829-4-git-send-email-syin@broadcom.com>
	<CACRpkdZah4fFuJL2Vh5JmbBCgnekg8MKqMWHzeheOx3N1Kzwng@mail.gmail.com>
	<051069C10411E24D9749790C498526FA1BE027EA@SJEXCHMB12.corp.ad.broadcom.com>
	<CACRpkdarPC+LxAAezT2LRiz=Y2RduUsb75YYHUgq7HqePzkD3Q@mail.gmail.com>
	<051069C10411E24D9749790C498526FA1BE03D43@SJEXCHMB12.corp.ad.broadcom.com>
	<051069C10411E24D9749790C498526FA1BE0841D@SJEXCHMB12.corp.ad.broadcom.com>
	<051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com>
Date: Mon, 4 Nov 2013 13:24:10 +0100
Message-ID: <CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 12:48 AM, Sherman Yin <syin@broadcom.com> wrote:

> So I will go ahead and make the change in pinconf-generic.c and pinctrl-bindings.txt
> to include parsing of the "slew-rate" property and submit it as part of my pinctrl
> changes.

OK, good.

> Question regarding pinctrl-generic: in pinctrl-bindings.txt, this is said about the
> "function" property:
>
> 169- function takes a list of function names/IDs as a required argument. The
> 170  specific binding for the hardware defines:
> 171  - Whether the entries are integers or strings, and their meaning.
> 172  - Whether only a single entry is allowed (which is applied to all entries
> 173    in the pins property), or whether there may alternatively be one entry per
> 174    entry in the pins property, in which case the list lengths must match, and
> 175    for each list index i, the function at list index i is applied to the pin
> 176    at list index i.
>
> (Although it looks like pinconf_generic_dt_subnode_to_map() does not support
> the "one entry per pin feature" for the "function" property yet.)
>
> In my driver, I have the "one entry per pin" support for all my properties instead
> of just the function property, like the "drive_str" property below:
>
> +               grp_1 {
> +                       brcm,pins       = "pin1", "pin2", "pin3";
> +                       brcm,function   = "alt1", "alt2", "alt1";
> +                       brcm,drive_str  = <2 4 6>;
> +                       brcm,slew       = <1>;
> +               };

OK.

> I thought that would be convenient and allow users to group pins together based
> on functionality and without the restriction that the pins must have the same
> properties.  Do you think that's a good idea and are there plans to support that in
> the generic pinconfig?  If so, I can look into porting my implementation to
> pinconf-generic.c - but first I have to figure out how some of the properties would
> work if more than one value could be specified (eg. "bias-disable" which takes no
> values)

Hm I don't quite get it I think. It depends on the old bindings still working
and full compatibility with old device trees. It might be a bit confusing.

I need help from Heiko on this I think.

Yours,
Linus Walleij
