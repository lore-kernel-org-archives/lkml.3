Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3IWSgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:36:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42625 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3IWSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:36:16 -0400
Message-ID: <524089DF.600@ti.com>
Date: Mon, 23 Sep 2013 14:35:11 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Jon Hunter <jgchunter@gmail.com>,
        <linux-gpio@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk> <20130923164519.GF2684@atomide.com> <524073BC.9080907@collabora.co.uk> <20130923170724.GG2684@atomide.com>
In-Reply-To: <20130923170724.GG2684@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Monday 23 September 2013 01:07 PM, Tony Lindgren wrote:
> * Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130923 10:09]:
>> On 09/23/2013 06:45 PM, Tony Lindgren wrote:
>>>
>>> Hmm does this still work for legacy platform data based
>>> drivers that are doing gpio_request() first?
>>>
>>
>> Yes it still work when booting using board files. I tested on my OMAP3 board and
>> it worked in both DT and legacy booting mode.
> 
> OK great.
>  
>>> And what's the path for clearing things for PM when free_irq()
>>> gets called? It seems that this would leave the GPIO bank
>>> enabled causing a PM regression?
>>>
>>
>> Indeed, I did set bank->mod_usage |= 1 << offset so the bank is enabled if the
>> device goes to suspended and then resumed but I completely forget about the
>> clearing path when the IRQ is freed.
>>
>> Which makes me think that we should probably maintain two usage variables, one
>> for GPIO and another one for IRQ and check both of them on the suspend/resume pm
>> functions.
> 
> Yes that it seems that they should be treated separately.
> 
As discussed on IRC, the patch as such is fine after the mentioned fixup,
I would like to hear back if Linus W/Grant is fine with the approach. Not sure
if I missed the discussion, but the proposed patch is deviation from
traditional method of doing gpio_request() first up to perform other
gpio operations.

Regards,
Santosh


