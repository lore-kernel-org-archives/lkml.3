Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825Ab3IGEPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 00:15:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37213 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3IGEP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 00:15:28 -0400
Message-ID: <522AA85E.3050206@codeaurora.org>
Date: Fri, 06 Sep 2013 21:15:26 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tero Kristo <t-kristo@ti.com>, Mark Rutland <Mark.Rutland@arm.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ian campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org> <20130829011425.8231.78802@quantum> <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org> <20130830203334.10934.10011@quantum> <522110AA.7040700@wwwdotorg.org> <20130903232219.10934.67434@quantum> <52277DBF.7080104@wwwdotorg.org> <CAPtuhThWHP61FzDBCH5SSFx6kV7==VdF3-M=Lke+cgnrOQL7JQ@mail.gmail.com> <5228EA02.3000200@wwwdotorg.org> <52297BE2.8010603@ti.com> <522A267B.4010200@wwwdotorg.org>
In-Reply-To: <522A267B.4010200@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 12:01 PM, Stephen Warren wrote:
> On 09/06/2013 12:53 AM, Tero Kristo wrote:
>> On 09/05/2013 11:30 PM, Stephen Warren wrote:
>
> ...
>>> 1)
>>>
>>> At least for large SoCs (rather than e.g. a simple clock generator
>>> chip/crystal with 1 or 2 outputs), clock drivers need a *lot* of data.
>>> We can either:
>>>
>>> a) Put that data into the clock driver, so it's "just there" for the
>>> clock driver to use.
>>>
>>> b) Represent that data in DT, and write code in the clock driver to
>>> parse DT when the driver probe()s.
>>>
>>> Option (a) is very simple.
>>
>> How can you claim option (a) to be very simple compared to (b)? I think
>> both are as easy / or hard to implement.
>
> Well, the work required for (b) is a pure super-set of the work require
> for (a), so clearly (a) is less work (perhaps the issue you're debating
> is harder/easier rather than more/less work?)
>
>>> Option (b) entails writing (and executing) a whole bunch of DT parsing
>>> code.It's a lot of effort to define the DT binding for the data,
>>> convert the data into DT format, and write the parsing code. It wastes
>>> execution time at boot. In the end, the result of the parsing is exactly
>>> the same data structures that could have been embedded into DT in the
>>> first place. This seems like a futile effort.
>>
>> Not really, consider a new SoC where you don't have any kind of data at
>> all. You need to write the data tables anyway, whether they are under DT
>> or some kernel data struct.
>
> Yes.
>
> But beyond writing the data tables, you also don't/do have to write all
> the DT parsing code based on choosing (a) or (b), etc.
>
>> The execution time remain in place for
>> parsing DT data though, but I wouldn't think this to be a problem. Also,
>> you should consider multiarch ARM kernel, where same kernel binary
>> should support multiple SoCs, this would entail having clock data for
>> all built in to the kernel, which can be a problem also.
>
> There's no reason that the clock data has to be built into the kernel at
> all; we should support even SoC clock drivers as modules in an initrd.
> Alternatively, drop the unused data from the kernel after boot via
> __init or similar. Alternatively, "pre-link" the clock driver module
> into the kernel in a way that allows it to be unloaded after boot even
> though it was built-in.
>
> ...
>> You can just as easily claim that anything internal to SoC should be
>> left out from DT, as this is cast in stone (or rather, silicon) also. We
>> should only use it to describe board layout. Everything else, the kernel
>> can 'know' by compile time.
>
> I did, immediately below:-) And then I went on to explain why that's
> necessary in many cases.
>
> ...
>> I can turn this around, as you went to this road. Why have DT at all?
>
> I believe (at least for ARM) the idea was to avoid churn to the kernel
> for supporting the numerous different *boards*.
>
> The kernel needs and contains drivers for HW blocks, and so since
> they're there, they may as well encode everything about the HW block.
>
> However, in most cases, the kernel shouldn't contain drivers for boards;
> boards are built from various common components which have drivers. DT
> is used to describe how those components are inter-connected. Hence, we
> can hopefully remove all board-related churn from the kernel (once the
> DT files are moved out of the kernel).
>
>> Personally I hate the whole idea of a devicetree, however am forced to
>> use it as somebody decided it is a good idea to have one. It doesn't
>> really solve any problems, it just creates new ones in a way of
>> political BS where everybody claims they know how DT should be used, and
>> this just prevents people from actually using it at all. Also, it
>> creates just one new unnecessary dependency for boot, previously we had
>> bootloader and kernel images which had to be in sync, now we have
>> bootloader + DT + kernel. What next? Maybe we should move the clock data
>> into a firmware file of its own?
>
> Well, I can sympathize, but I think the time is past for debating that.
>
>> Why do you care so much what actually goes into the devicetree?
>
> To get DT right.
>
> Even if we went back to board files and mach-xxx specific code rather
> than cleanly separated drivers, it would still be beneficial to have
> much more oversight of board/mach-xxx code than there was previously.
> Board files made it very easy to do SoC-specific hacks. To avoid that,
> in either DT or board files, we're trying to impose standards so that we
> pick correct, generic, appropriate solutions, rather than letting
> everyone run of with isolated ad-hoc solutions.
>
>> Shouldn't people be let use it how they see fit? For the clock bindings
>> business this is the same, even if the bindings are there, you are free
>> to use them if you like, and if you don't like them, you can do things
>> differently.
>
> We'd be better of creating as much standardization as possible, so that
> all SoCs/boards/.. work as similarly as possible, and we achieve maximal
> code reuse, design-reuse, and allow people to understand everything
> rather than just one particular SoC's/board's solution.
>
> If we don't get some re-use and standardization out of DT, we really may
> as well just use board files.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

I didn't read the full thread, but I have talked about this several 
times with Mike and Stephen Boyd before.

Here's my view on this.

I think the stance of saying the entire clock tree data should not be in 
DT is rather absurd and very contradictory to the existing clock DT 
bindings.

There are two ways to look at how the clock bindings should be:

1) We only care about the clocks that are sent out of a clock controller 
(CC) HW to other blocks. We don't care about the internals of the CC. In 
that case, the DT bindings should not have any details about the clock, 
Just a list of names/ids of the clocks being sent out of the HW block so 
that the clock provider driver for that CC knows which clock is being 
clk_get()'ed. The DT shouldn't specify if it's a frickin PLL, mux, 
divider, gate clock, etc. None of the clients care what is the type of 
the clock, so why list all that data in DT?

2) We want to document the entire clock tree data in DT so that we don't 
have to keep adding C files just to capture the data needed to represent 
the clock tree when the actual code can be 100% reused across several 
chips. Even in this case, the clients in DT will only care about the 
clock and not what their type/rest of the data is. So, we will still 
need to have a list of nodes/phandles (not actual linux devices), names 
or ids.

But the current clock DT binding is a Frankenstein monster of (1) and 
(2) that nobody loves. We list the type and other details of the clock 
leaf nodes, but not the rest of the tree. So, that additional data is 
useless both to the clients and to the CC driver. There's no benefit to 
the CC driver in knowing only the partial details of a partial list of 
clocks (leaf nodes). Would rather pick (1) or (2) instead of the current 
abomination.

Sure, someone will come and argue, "Oh, but my clock tree is simple, so 
I can still use just the data and have a portable driver". But that's a 
very narrow outlook that doesn't scale and work for everyone. And even 
in that case, I'm fairly certain they are hacking some stuff up and not 
now truly representing the entire HW clock tree using the clock 
framework. I mean, which HW has a clock "tree" with just leaf nodes -- 
that can only be possible if you have one XO (crystal oscillator) for 
every clock and none of the clock rates are changeable.

And finally to give my preference, I prefer option (2) that represents 
the entire clock tree in DT and here are the reasons:

A) Wasn't one of the main reasons for ARM using DT to stop code churn 
for minor changes in HW? I even vaguely remember Linux co,plaining that 
all us stupid clock folks keeps making code changes to update minor 
data. So, why are we trying to pick DT bindings that will continue to 
cause a shit ton of code churn?

B) Also, don't we always complain that HW vendors aren't documenting 
their HW and opening it up? What better way that describing the entire 
HW block in DT? It gives you all the details you about it. So, why are 
we pushing against it? This just seems an arbitrary push back.

C) Clocks change often and in minor ways between chips from the same 
vendor. DT is a lot more capable and less repetitive than C to list the 
"diffs". In DT, we can include the clock tree data from another chip and 
just "fix up" the parts that changed. This would be so much nicer than 
creating separate C files for each chip or trying to update the 
structures at runtime based on some vendor specific DT property or 
compatible string.

Btw, this is the kind of stuff I want to discuss in ARM Summit, but I'm 
still waiting for an invite :( Hopefully it will come soon enough that I 
don't miss the ARM Summit because I don't have time to get a UK Visa.

Thanks,
Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
