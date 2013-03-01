Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3CASY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:24:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49001 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CASY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:24:57 -0500
Message-ID: <5130F276.8000904@wwwdotorg.org>
Date: Fri, 01 Mar 2013 11:24:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: gpio: vt8500: Add pin control driver for Wondermedia
 SoCs
References: <1360896534-20637-1-git-send-email-linux@prisktech.co.nz>  <1360896534-20637-2-git-send-email-linux@prisktech.co.nz>  <512E86F4.6000909@wwwdotorg.org> <1362032757.32211.10.camel@gitbox>
In-Reply-To: <1362032757.32211.10.camel@gitbox>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 11:25 PM, Tony Prisk wrote:
> Thanks for the review Stephen,
> 
> I have posted replies to most of your points/questions inline.
> 
> The review was slightly more in-depth than I expected and as you
> noticed, the patch is poor in quality. I was more 'testing the water'
> that people were happy with the basic design of the code, rather than
> the specifics as I have 4 SoC's worth of data to add, and didn't want to
> have to redo it all if I had to make a data format change.
> 
> It seems that on the whole the design is ok, so I will post a proper
> patch series for this to be reviewed (after addressing the issues you
> pointed out).

Oh, OK. It might have been a good idea to mention this in the patch
description, or have posted it as [PATCH RFC].

>>> diff --git a/drivers/pinctrl/pinctrl-wm8850.c b/drivers/pinctrl/pinctrl-wm8850.c
>>
>>> +/* Please keep sorted by bank/bit */
>>> +#define WMT_PIN_EXTGPIO0	WMT_PIN(0, 0)
>>> +#define WMT_PIN_EXTGPIO1	WMT_PIN(0, 1)
>> ...
>>> +#define WMT_PIN_I2C2_SCL	WMT_PIN(5, 12)
>>> +#define WMT_PIN_I2C2_SDA	WMT_PIN(5, 13)
>>
>> There are a lot of gaps in that list. Does the HW really not support pin
>> muxing on the rest of the bits in the registers?
>
> Nobody who knows is willing to say :). Most of the code for Wondermedia
> SoCs is based of the vendor source that has come out, and we therefore
> only know what the vendor has included support for.
> 
> No doubt there will be other pins which have valid functions, but we
> don't know what they are and don't have support for them at the moment.
> The reason I went with the bank/pin encoding is so that if/when we add
> other pins, it won't affect any pin numbering.

Doing the pin numbering that way was a good choice.

So, there's an idea that when first defining a DT binding for HW, that
binding should be complete and accurate, rather than being minimal, with
a plan to incrementally expand it later. I would take that to mean that
for a pinctrl binding, the list of pins/groups/function/config-options
that the binding supports is complete. Obviously this isn't possible if
there's no complete documentation for the HW:-(

I hope this case will be allowed though, since any modifications to
support new pins/groups/functions should be possible to add in a
backwards-compatible way, especially with a forward-looking number
scheme for the pins.

We should consider this kind of issue if/when we actually implement
stricter rules for modifications to DT bindings, so as not to disallow
solving this problem.
