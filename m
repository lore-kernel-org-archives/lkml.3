Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaGaXRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 19:17:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaGaXRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 19:17:20 -0400
Message-ID: <53DACE73.8080009@suse.de>
Date: Fri, 01 Aug 2014 01:17:07 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
CC: Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-5-git-send-email-afaerber@suse.de> <53DA936E.9060004@gmail.com> <53DA9709.10602@suse.de> <53DA9BA9.60808@gmail.com>
In-Reply-To: <53DA9BA9.60808@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.07.2014 21:40, schrieb Tomasz Figa:
> On 31.07.2014 21:20, Andreas Färber wrote:
>> Am 31.07.2014 21:05, schrieb Tomasz Figa:
>>> On 31.07.2014 18:08, Andreas Färber wrote:
>>>> +	usb-hub {
>>>> +		compatible = "smsc,usb3503a";
>>>> +		reset-gpios = <&hsic_reset>;
>>>
>>> Hmm, why a -gpios property points to a pinctrl node? Shouldn't there be
>>> a phandle to GPIO bank + GPIO specifier instead?
>>
>> Dunno, can change it. Can I just copy the gpio property from the
>> regulator above?
> 
> Reading what Vincent posted earlier I would consider this as the right
> thing to do and it might even let you remove the fake regulator node.

Indeed it does, thanks for spotting this!

[...]
>>>> +&dp_hpd {
>>>> +	samsung,pins = "gpc3-0";
>>>> +	samsung,pin-function = <0>;
>>>> +	samsung,pin-pud = <3>;
>>>> +	samsung,pin-drv = <0>;
>>>> +};
>>>
>>> Hmm, what node is this referencing? I believe this should rather
>>> reference the pin controller and add a new board-specific pinconf/pinmux
>>> group instead....
>>
>> It's a -pinctrl node. See v3->v4 change log and discussion on v3.
>>
> 
> Well, this is clearly a board specific node anyway, because it does not
> refer to a special function, but simply an input/interrupt GPIO. If it
> somehow has landed in generic pinctrl dtsi then it should be removed
> from there and this patch should simply introduce its own instance of
> dp_hpd node, so you did the right thing in v3.

Well, my point was that the 3.8 tree contains only one dp-hpd node, not
two as we would get by adding a new node here.

Apart from Spring, it's used in Snow and SMDK5250, so moving it there
seems feasible and the cleanest solution to me.

>>> [snip]
>>>
>>>> +/*
>>>> + * Disabled pullups since external part has its own pullups and
>>>> + * double-pulling gets us out of spec in some cases.
>>>> + */
>>>> +&i2c2_bus {
>>>> +	samsung,pin-pud = <0>;
>>>> +};
>>>
>>> OK, here overriding a generic pinconf group is justified and nicely
>>> explained by a comment.
>>
>> You seem to assume that I actually understand these things. ;)
>> Just copied from -cros-common/-snow.
>>
> 
> It is good if those things are being done with some level of
> understanding. The DT mechanics are quite well documented in
> Documentation/devicetree/bindings, while for HW-specific bits I believe
> Chromium guys could give you a hand.

I did read and even fix documentation for those bindings that I added
myself in Spring, just not for those that were already in common code,
like this one here.

A tps65090 patch has been ignored since being asked to extend the commit
message, v3 was recently sent. Help getting that in appreciated.

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
