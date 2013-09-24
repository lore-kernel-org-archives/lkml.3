Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3IXHjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:39:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34119 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab3IXHjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:39:49 -0400
Message-ID: <524141A6.2090701@ti.com>
Date: Tue, 24 Sep 2013 13:09:18 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
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

Hi,
On Monday 23 September 2013 10:37 PM, Tony Lindgren wrote:
> * Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130923 10:09]:
>> On 09/23/2013 06:45 PM, Tony Lindgren wrote:
>>> Hmm does this still work for legacy platform data based
>>> drivers that are doing gpio_request() first?
>>>
>> Yes it still work when booting using board files. I tested on my OMAP3 board and
>> it worked in both DT and legacy booting mode.
> OK great.
>  
>>> And what's the path for clearing things for PM when free_irq()
>>> gets called? It seems that this would leave the GPIO bank
>>> enabled causing a PM regression?
>>>
>> Indeed, I did set bank->mod_usage |= 1 << offset so the bank is enabled if the
>> device goes to suspended and then resumed but I completely forget about the
>> clearing path when the IRQ is freed.
>>
>> Which makes me think that we should probably maintain two usage variables, one
>> for GPIO and another one for IRQ and check both of them on the suspend/resume pm
>> functions.
> Yes that it seems that they should be treated separately.
 To understand, why cant the flag be cleared in gpio_irq_shutdown ?

Regards,
 Sricharan
