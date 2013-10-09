Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3JIT1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:27:25 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41797 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3JIT1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:27:23 -0400
Message-ID: <5255AE12.2000205@gmail.com>
Date: Wed, 09 Oct 2013 21:27:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Mark Rutland <mark.rutland@arm.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: Re: [PATCH 3/8] ARM: l2x0: add Marvell Tauros3 compatible
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-4-git-send-email-sebastian.hesselbarth@gmail.com> <20131008134100.GD1412@e106331-lin.cambridge.arm.com> <52542D64.5010800@gmail.com> <525433D3.2090906@free-electrons.com> <20131009085026.GD4981@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131009085026.GD4981@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 10:50 AM, Mark Rutland wrote:
> On Tue, Oct 08, 2013 at 05:33:23PM +0100, Gregory CLEMENT wrote:
>> On 08/10/2013 18:05, Sebastian Hesselbarth wrote:
>>> On 10/08/2013 03:41 PM, Mark Rutland wrote:
>>>> On Tue, Oct 08, 2013 at 01:24:28PM +0100, Sebastian Hesselbarth wrote:
>>>>> This add a compatible for the Marvell Tauros3 cache controller which
>>>>> is compatible with l2x0 cache controllers. While updating the binding
>>>>> documentation, clean up the list of possible compatibles.
>>>>>
>>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>>>> ---

Added Jisheng and Lennert to Cc.

Lennert, while looking for differences between ARM PL310 and
Marvell Tauros3 cache controller in a GPL'ed 2.6 kernel source
from Asus, I found arch/arm/mm/cache-tauros3.c which states you
as the original author. If that is wrong, please ignore this.

>>> [...]
>>>>> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
>>>>> index c0c7626..a1d0cbd 100644
>>>>> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
>>>>> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
>>>>> @@ -7,20 +7,20 @@ The ARM L2 cache representation in the device tree should be done as follows:
>>>>>    Required properties:
>>>>>
>>>>>    - compatible : should be one of:
>>>>> -	"arm,pl310-cache"
>>>>> -	"arm,l220-cache"
>>>>> -	"arm,l210-cache"
>>>>> -	"marvell,aurora-system-cache": Marvell Controller designed to be
>>>>> +  "arm,pl310-cache"
>>>>> +  "arm,l220-cache"
>>>>> +  "arm,l210-cache"
>>>>> +  "bcm,bcm11351-a2-pl310-cache": DEPRECATED by "brcm,bcm11351-a2-pl310-cache"
>>>>> +  "brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
>>>>> +     offset needs to be added to the address before passing down to the L2
>>>>> +     cache controller
>>>>> +  "marvell,aurora-system-cache": Marvell Controller designed to be
>>>>>         compatible with the ARM one, with system cache mode (meaning
>>>>>         maintenance operations on L1 are broadcasted to the L2 and L2
>>>>>         performs the same operation).
>>>>> -	"marvell,"aurora-outer-cache: Marvell Controller designed to be
>>>>> -	 compatible with the ARM one with outer cache mode.
>>>>> -	"brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
>>>>> -	offset needs to be added to the address before passing down to the L2
>>>>> -	cache controller
>>>>> -	"bcm,bcm11351-a2-pl310-cache": DEPRECATED by
>>>>> -	                               "brcm,bcm11351-a2-pl310-cache"
>>>>> +  "marvell,aurora-outer-cache": Marvell Controller designed to be
>>>>> +     compatible with the ARM one with outer cache mode.
>>>>> +  "marvell,tauros3-cache": Marvell Tauros3 cache controller.
>>>>
>>>> How does the tauros3 cache differ from the other caches supported by the
>>>> l2x0 driver?
>>>
>>> [added Gregory to Cc]
>>>
>>> Good question. I cannot say at this time. I would have guessed that l2cc
>>> on Armada 1500 and Armada 370/XP are more or less the same, as both use
>>> Marvell's PJ4B CPU. Maybe, Gregory or Thomas can shed some light into
>>> this.

As stated above, I did some research on the differences. I think I can
prepare a patch providing tauros3 specific callbacks for .inv_all,
.flush_all, .resume, and .save.

For full .setup, I need to do more research on the CTRL/AUX_CTRL bits.

Up to now, I think pl310 specific callbacks (.resume, .save, .setup)
are _not_ suitable for tauros3. In the source from above, there are
no TAG_LATENCY_CTRL, DATA_LATENCY_CTRL, ADDR_FILTER_*, nor POWER_CTRL
registers.

>>>>>    - cache-unified : Specifies the cache is a unified cache.
>>>>>    - cache-level : Should be set to 2 for a level 2 cache.
>>>>>    - reg : Physical base address and size of cache controller's memory mapped
>>>>> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
>>>>> index 447da6f..90c776e 100644
>>>>> --- a/arch/arm/mm/cache-l2x0.c
>>>>> +++ b/arch/arm/mm/cache-l2x0.c
>>>>> @@ -929,6 +929,7 @@ static const struct of_device_id l2x0_ids[] __initconst = {
>>>>>    	  .data = (void *)&aurora_no_outer_data},
>>>>>    	{ .compatible = "marvell,aurora-outer-cache",
>>>>>    	  .data = (void *)&aurora_with_outer_data},
>>>>> +	{ .compatible = "marvell,tauros3-cache", .data = (void *)&l2x0_data },
>>>>
>>>> Are we intending to handle this differently later?
>>>>
>>>> Or is it 100% compatible with the pl210 or pl220? We could just require
>>>> an entry later in the compatible string list instead...
>>>
>>> No public documentation, no clear answer.
>>>
>>> Tauros3 isn't 100% compatible with any of the ARM l2cc above, it has
>>> additional "features" or "bugs" - call it whatever you want.
>>>
>>> I am not an l2cc expert, but basically I see two options:
>>> a) use (possibly) wrong existing compatible in current mv88de3100.dtsi
>>>      now and fix later.
>>> b) add tauros3 compatible now and add (possible) quirks/marvell-specific
>>>      properties later.
>>>
>>> IMHO b) is very likely to happen as l2x0_of_init in patch 8/8 already
>>> sets bits, I wasn't able to verify in public ARM l2cc docu.
>>
>> I agree with Sebastian. I don't have more information that Sebastian, but
>> as it is definitely a different controller of the ones from ARM, it should
>> have its own compatible string. Then latter when we will discover new feature
>> and/or bugs, we will be able to manage them without requiring people to update
>> their dtb. If I understood well it is the philosophy behind the device tree.
>
> Please note that I wasn't arguing for people to have to update their
> dtb. I was only suggesting that we'd have something like:
>
> 	compatible = "marvell,tauros3-cache", "arm,l220-cache";
>
> Which would function now, and later the driver could choose to check for
> "marvell,tauros3-cache" and do something different.

Agree, we really should use above compatible style more often.

> However, given that we don't have sufficient documentation to tell how
> close the tauros3 cache is to any ARM l2x0 variant, having just the
> "marvell,tauros3-cache" string in dts and supporting this in the driver
> makes sense to me.

I found some source, which is possibly enough documentation. Also, I am
counting on Jisheng or Lennert to comment on the hidden magic in
Tauros3.

Sebastian

