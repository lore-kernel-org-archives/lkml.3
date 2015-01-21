Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbbAUVpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:45:06 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:39584 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbbAUVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:44:53 -0500
Message-ID: <54C01DD1.8040704@schinagl.nl>
Date: Wed, 21 Jan 2015 22:44:49 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH v1 2/4] gpio: add parameter to allow the use named gpios
References: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl> <1420621722-7428-3-git-send-email-oliver+list@schinagl.nl> <CAAVeFuLwTsX8HByCVyEucYJ_DhhCOP=tEDprmi9pBwx+a7zzJg@mail.gmail.com>
In-Reply-To: <CAAVeFuLwTsX8HByCVyEucYJ_DhhCOP=tEDprmi9pBwx+a7zzJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alexandre,

On 01/19/2015 05:04 AM, Alexandre Courbot wrote:
> On Wed, Jan 7, 2015 at 6:08 PM, Olliver Schinagl
> <oliver+list@schinagl.nl> wrote:
>> From: Olliver Schinagl <oliver@schinagl.nl>
>>
>> The gpio binding document says that new code should always use named
>> gpios. Patch 40b73183 added support to parse a list of gpios from child
>> nodes, but does not make it possible to use named gpios. This patch adds
>> the con_id property and implements it is done in gpiolib.c, where the
>> old-style of using unnamed gpios still works.
> This is absolutely correct - thanks for spotting this.
>
> <snip>
> ... since it looks like this part has been mostly copy/pasted from
> of_find_gpio(), can you add another patch that fixes it there as well?
Yeah, since it has the same functionality, i copy pasted it. Wasn't sure 
if it was worth to macro it or anything. I've sent a v2 with that patch 
added to the mix :)
>
> Also in the case of ACPI this will prove to be an incomplete lookup
> since acpi_find_gpio() has an additional fallback if the named lookup
> fails.
I'm not very familiar (or at all) how ACPI falls into all of this, I'm 
just starting to get a hang of the DT, but since this is how the dts is 
being parsed, where is the relation here? Or did I misunderstand?
>
> In that respect, I wonder if it would not be better for
> devm_get_gpiod_from_child() to call of_find_gpio() and
> acpi_find_gpio() (after making them non-static) followed by
> gpiod_request() instead of calling fwnode_get_named_gpiod(). But in
> that case it will have to do the OF/ACPI handling by itself.
>
> I'm not really sure about which way is better. I'd appreciate if you
> could give a thought to a possible refactoring that would improve the
> situation ; otherwise feel free to ignore what I have written above
> and to duplicate the property name building code.
I'm afraid I'm a little too inexperienced to follow exactly what you say ;)

Olliver

