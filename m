Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbaAJRJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:09:39 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52270 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642AbaAJRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:09:37 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-33-52d0294f27b0
Message-id: <52D02947.9030005@samsung.com>
Date: Fri, 10 Jan 2014 18:09:27 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>, Will Deacon <will.deacon@arm.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
 <20140108143529.GB14122@mudshark.cambridge.arm.com>
 <CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
In-reply-to: <CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xq7r+mheCDN60slm8X9bDaPH2yy5m
	i7PLDrJZtF05yG6xqe0to0XvgqtsFpseX2O1uLxrDpvFjPP7mCxuX+a1+LplN6PFjzPdLBYv
	P55gceD1WDNvDaNHS3MPm8fshossHpf7epk8nmy6yOixeUm9R9+WVYwenzfJBXBEcdmkpOZk
	lqUW6dslcGU0fWhlK9isX/F9+k22BsYFql2MnBwSAiYSF98cZ4GwxSQu3FvP1sXIxSEksJRR
	YuG+hewQzmdGiYYv15lBqngFtCTeHn3MCGKzCKhKfH+1lAnEZhNQk/jc8IgNxBYViJD4O289
	I0S9oMSPyffANogI+EhcvXiaCWQos8BrFoltVzrBmoWBEpe+9jFCbDsKtLrlMjtIglMgWKL9
	3B+wScwCZhKPWtYxQ9jyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4
	NC9dLzk/dxMjJIK+7GBcfMzqEKMAB6MSD2+AyIUgIdbEsuLK3EOMEhzMSiK8wlJAId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYxR7x4xp/1pTFwQ39Er9sne65fAAd+NG35lVXTu2j5j2aJnFtk7
	nj1Re2jIPIt9Su3/7dJHJ2nuU2ZvPFEecm/r/YIrCu8XnGSYJnFRadpm6xud5avqvj29PG0u
	716Ru3m//eQTmjPK3ORsvsXut7Ew1tJIO7ZLJoljztuGqxurnrr870hZcualEktxRqKhFnNR
	cSIAuPqQU34CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08.01.2014 17:21, Doug Anderson wrote:
> WIll,
>
> Thanks for your comments!
>
> On Wed, Jan 8, 2014 at 6:35 AM, Will Deacon <will.deacon@arm.com> wrote:
>> On Wed, Jan 08, 2014 at 01:33:11PM +0000, Vivek Gautam wrote:
>>> The erratum-773769 occurs on Arm Coretex-A15 (rev r2p0),
>>> when L2 Data Ram latency is set to 4 cycles or more; or
>>> when ACP is in use, or with L2 Data RAM slice configured.
>>> Therefore, the effective latency as calculated in Table 7-2 of
>>> Cotex-A15 (rev r2p0) trm should be 3 cycles or less.
>>>
>>> On Exynos5250 based systems the effective data ram latency
>>> is 4 cycles, since we have DATA_RAM_SETUP bit enabled (L2CTRL[5]=1b'1)
>>> and DATA_RAM_LATENCY bits set to 0x2 (L2CTLR[2:0]=3b'010) therefore,
>>> the effective L2 data RAM latency becomes 4 cycles.
>>> So erratum '773769' occurs causing a corrupted L2 Cache.
>>>
>>> This patch gives a workaround to the mentioned erratum, using below
>>> mentioned algo:
>>> ----------------------------------------------------------------
>>> if data RAM setup = 1
>>>    then check if effective latency i.e (latency + setup + 1) > 3
>>>    if 'true'
>>>      then clear data RAM setup
>>>        goto branch 'a'
>>> if data RAM setup = 0
>>>    a: then check if data RAM latency > 0x10
>>>      if true then force data RAM latency = 0x10
>>> ----------------------------------------------------------------
>>> so that the effective data RAM latency reduces to 3 cycles or less
>>> and hence prevent hitting the erratum.
>>>
>>> NOTE: The Exynos5250 based products have already been shipped, which
>>>        makes it impossible to add the change in bootloader, so we are
>>>        adding the required change in kernel.
>>
>> NAK. Whilst I appreciate that you may not be able to fix your bootloader,
>> this isn't the right change to make in the kernel. Blindly changing memory
>> latencies is likely to do more harm than good for a multi-platform kernel,
>> even if it works for exynos 5250. The only alternative I can think of (if you
>> have to make a mainline kernel change) is to restrict the clock frequencies at
>> which the CPU is allowed to run, although that obviously requires some
>> investigation in order to determine how viable it is for your SoC.
>
> OK, so humor me a little here...
>
> I'll start off by saying that I'm totally OK if mainline doesn't want
> this fixed.  If mainline is not interested in running reliably on
> exynos5250-based products then there's nothing I can do about it.  It
> seems unfortunate, but I'm not going to get into a shouting match
> about it.
>
> You're saying that this patch is blindly changing memory latencies.  I
> don't think it is (please correct me if I'm wrong!).  This patch:
>
> * Is guarded by a CONFIG option so the code isn't even compiled in if
> you don't want EXYNOS5250 support.  I know this doesn't help
> multiplatform, but it means that if you really hate the code it's easy
> to disable.
>
> * Is guarded by a runtime check of the revision number so that it
> doesn't run on unaffected A15 revisions.
>
> * Is guarded by a runtime check so it does nothing at all if the total
> latency is <= 3 (AKA if boot code already picked a sane value)
>
> ...with the above guards it's pretty safe...
>
> I will agree that there is a _potential_ that this could make things
> work worse on an already broken product our there, but I would say
> there's a reasonable chance that such a product doesn't exist (but
> please correct me if I'm wrong).  Specifically, this patch will cause
> problems in two examples that I can think of:
>
> --
>
> Example A: existing A15 <=r2p0 product with 773769-ignorant boot code
> that could be fixed, but that needs "setup = 1"
>
> In this case we've got boot code that's like the exynos5250 boot code
> that accidentally sets the total latency to >= 4 when it would work
> just fine to use a value of 3.  ...except that unlike the exynos5250
> this hypthetical SoC needs to leave setup = 1.
>
> ...if such a machine were found in the wild (seems unlikely?) then
> we'll need to figure out what to do.  If its boot code cannot be
> updated and we want to support this product with a similar patch then
> we'll need to be more dynamic.
>
> --
>
> Example B: existing A15 <=r2p0 product that just has to live with crashes
>
> In this case we've got a product where we're going to just accept that
> it crashes sometimes (since this is a fairly hard crash to trigger)
> because it crashes even more when the total latency < 4.  In this case
> we don't want to "fix" the errata because that makes things worse.
>
> ...if such a machine were find in the wild (it's possible, I guess?)
> then that's a really good reason not to take this patch or to find
> some way to dynamically enable / disable it.
>
> --
>
> Let me know what you think of the above, or if I'm misunderstanding something...

It's hard to disagree with any of the opinions presented here. We want 
to support Exynos5250-based hardware, but at the same time we don't want 
to regress any hardware unaffected by mentioned issue...

Let me propose you a solution that comes to my mind (as discussed with 
ojn on #armlinux):

To work around the erratum we basically need to ensure that two things 
are done:

  1) At boot-up the L2 controller configured by R/O firmware need to
     be reconfigured to sane values.

  2) At resume from sleep mode the same process as in 1) must be done.

As for the first one, it might be handled either by R/W firmware of the 
board or some small loader code glued in front of zImage. Second one can 
be implemented in SoC-specific resume code 
(arch/arm/plat-samsung/s5p-sleep.S), as it's currently done with L2X0 on 
Exynos4.

Of course this is scattering the workaround over multiple code bases, 
but this way the workaround is executed only on affected platforms 
without hurting the unaffected ones. What do you think?

Best regards,
Tomasz
