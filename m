Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3JHQdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:33:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34420 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754840Ab3JHQd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:33:27 -0400
Message-ID: <525433D3.2090906@free-electrons.com>
Date: Tue, 08 Oct 2013 18:33:23 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] ARM: l2x0: add Marvell Tauros3 compatible
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-4-git-send-email-sebastian.hesselbarth@gmail.com> <20131008134100.GD1412@e106331-lin.cambridge.arm.com> <52542D64.5010800@gmail.com>
In-Reply-To: <52542D64.5010800@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 18:05, Sebastian Hesselbarth wrote:
> On 10/08/2013 03:41 PM, Mark Rutland wrote:
>> On Tue, Oct 08, 2013 at 01:24:28PM +0100, Sebastian Hesselbarth wrote:
>>> This add a compatible for the Marvell Tauros3 cache controller which
>>> is compatible with l2x0 cache controllers. While updating the binding
>>> documentation, clean up the list of possible compatibles.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> ---
> [...]
>>> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
>>> index c0c7626..a1d0cbd 100644
>>> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
>>> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
>>> @@ -7,20 +7,20 @@ The ARM L2 cache representation in the device tree should be done as follows:
>>>   Required properties:
>>>
>>>   - compatible : should be one of:
>>> -	"arm,pl310-cache"
>>> -	"arm,l220-cache"
>>> -	"arm,l210-cache"
>>> -	"marvell,aurora-system-cache": Marvell Controller designed to be
>>> +  "arm,pl310-cache"
>>> +  "arm,l220-cache"
>>> +  "arm,l210-cache"
>>> +  "bcm,bcm11351-a2-pl310-cache": DEPRECATED by "brcm,bcm11351-a2-pl310-cache"
>>> +  "brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
>>> +     offset needs to be added to the address before passing down to the L2
>>> +     cache controller
>>> +  "marvell,aurora-system-cache": Marvell Controller designed to be
>>>        compatible with the ARM one, with system cache mode (meaning
>>>        maintenance operations on L1 are broadcasted to the L2 and L2
>>>        performs the same operation).
>>> -	"marvell,"aurora-outer-cache: Marvell Controller designed to be
>>> -	 compatible with the ARM one with outer cache mode.
>>> -	"brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
>>> -	offset needs to be added to the address before passing down to the L2
>>> -	cache controller
>>> -	"bcm,bcm11351-a2-pl310-cache": DEPRECATED by
>>> -	                               "brcm,bcm11351-a2-pl310-cache"
>>> +  "marvell,aurora-outer-cache": Marvell Controller designed to be
>>> +     compatible with the ARM one with outer cache mode.
>>> +  "marvell,tauros3-cache": Marvell Tauros3 cache controller.
>>
>> How does the tauros3 cache differ from the other caches supported by the
>> l2x0 driver?
> 
> [added Gregory to Cc]
> 
> Good question. I cannot say at this time. I would have guessed that l2cc
> on Armada 1500 and Armada 370/XP are more or less the same, as both use
> Marvell's PJ4B CPU. Maybe, Gregory or Thomas can shed some light into
> this.
> 
>>>   - cache-unified : Specifies the cache is a unified cache.
>>>   - cache-level : Should be set to 2 for a level 2 cache.
>>>   - reg : Physical base address and size of cache controller's memory mapped
>>> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
>>> index 447da6f..90c776e 100644
>>> --- a/arch/arm/mm/cache-l2x0.c
>>> +++ b/arch/arm/mm/cache-l2x0.c
>>> @@ -929,6 +929,7 @@ static const struct of_device_id l2x0_ids[] __initconst = {
>>>   	  .data = (void *)&aurora_no_outer_data},
>>>   	{ .compatible = "marvell,aurora-outer-cache",
>>>   	  .data = (void *)&aurora_with_outer_data},
>>> +	{ .compatible = "marvell,tauros3-cache", .data = (void *)&l2x0_data },
>>
>> Are we intending to handle this differently later?
>>
>> Or is it 100% compatible with the pl210 or pl220? We could just require
>> an entry later in the compatible string list instead...
> 
> No public documentation, no clear answer.
> 
> Tauros3 isn't 100% compatible with any of the ARM l2cc above, it has
> additional "features" or "bugs" - call it whatever you want.
> 
> I am not an l2cc expert, but basically I see two options:
> a) use (possibly) wrong existing compatible in current mv88de3100.dtsi
>     now and fix later.
> b) add tauros3 compatible now and add (possible) quirks/marvell-specific
>     properties later.
> 
> IMHO b) is very likely to happen as l2x0_of_init in patch 8/8 already 
> sets bits, I wasn't able to verify in public ARM l2cc docu.

I agree with Sebastian. I don't have more information that Sebastian, but
as it is definitely a different controller of the ones from ARM, it should
have its own compatible string. Then latter when we will discover new feature
and/or bugs, we will be able to manage them without requiring people to update
their dtb. If I understood well it is the philosophy behind the device tree.

Regards,

> 
> But again, I am very open for suggestions here.
> 
> Sebastian
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
