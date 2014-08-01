Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaHAMZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:25:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39495 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbaHAMZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:25:41 -0400
Message-ID: <53DB877A.5000004@ti.com>
Date: Fri, 1 Aug 2014 15:26:34 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        dt list <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <jason@lakedaemon.net>, Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, <tglx@linutronix.de>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
References: <20140729141522.GB17808@saruman.home> <20140729152052.GV29045@atomide.com> <20140729154057.GE17808@saruman.home> <20140729163345.GF17808@saruman.home> <20140730060420.GY29045@atomide.com> <20140730144059.GA7272@saruman.home> <CAGo_u6ou+MoKOE_tTTmjxyFNW=jTaN9vnTsHrxR6sQHsieJyLA@mail.gmail.com> <20140730162038.GH7272@saruman.home> <20140731062843.GA29045@atomide.com> <53D9F6D5.1080307@ti.com> <20140731134945.GB19512@saruman.home>
In-Reply-To: <20140731134945.GB19512@saruman.home>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 04:49 PM, Felipe Balbi wrote:
> Hi,
>
> On Thu, Jul 31, 2014 at 10:57:09AM +0300, Tero Kristo wrote:
>> On 07/31/2014 09:28 AM, Tony Lindgren wrote:
>>> * Felipe Balbi <balbi@ti.com> [140730 09:23]:
>>>> Hi,
>>>>
>>>> On Wed, Jul 30, 2014 at 10:45:41AM -0500, Nishanth Menon wrote:
>>>>> On Wed, Jul 30, 2014 at 9:40 AM, Felipe Balbi <balbi@ti.com> wrote:
>>>>>> HI,
>>>>>>
>>>>>> On Tue, Jul 29, 2014 at 11:04:21PM -0700, Tony Lindgren wrote:
>>>>>>> * Felipe Balbi <balbi@ti.com> [140729 09:36]:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On Tue, Jul 29, 2014 at 10:40:57AM -0500, Felipe Balbi wrote:
>>>>>>>>> On Tue, Jul 29, 2014 at 08:20:52AM -0700, Tony Lindgren wrote:
>>>>>>>>>> * Felipe Balbi <balbi@ti.com> [140729 07:18]:
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> On Tue, Jul 29, 2014 at 05:14:25AM -0700, Tony Lindgren wrote:
>>>>>>>>>>>> * Felipe Balbi <balbi@ti.com> [140728 14:19]:
>>>>>>>>>>>>> now that we don't need to support legacy board-files,
>>>>>>>>>>>>> we can completely switch over to a linear irq domain
>>>>>>>>>>>>> and make use of irq_alloc_domain_generic_chips() to
>>>>>>>>>>>>> allocate all generic irq chips for us.
>>>>>>>>>>>>
>>>>>>>>>>>> This patch seems to somehow break off-idle for omap3
>>>>>>>>>>>> where it no longer wakes up.
>>>>>>>>>>>
>>>>>>>>>>> Sure your bisection is correct ? This patch just switches from legacy
>>>>>>>>>>> irq domain to linear irq domain.
>>>>>>>>>>
>>>>>>>>>> Yes, I tried it a few times. Just enabling
>>>>>>>>>> retention idle hangs too with this patch.
>>>>>>>>>>
>>>>>>>>>> Maybe it's omap3_prcm_irq_setup that relies on
>>>>>>>>>> 11 + OMAP_INTC_START? There may be other such issues
>>>>>>>>>
>>>>>>>>> lol.
>>>>>>>>>
>>>>>>>>> OMAP4 has the same nonsense.
>>>>>>>>
>>>>>>>> made me think why (if) OMAP4 works with that same setup. Does wake from
>>>>>>>> OFF work with OMAP4 ?
>>>>>>>
>>>>>>> Not without similar changes, omap4+ has the same issue.. There's a RFC
>>>>>>> series from Nishant to fix some of this, and Tero is moving the PRCM
>>>>>>> into a driver.
>>>>>>>
>>>>>>>> Anyway, here's a quick little hack to check if that's the reason for the
>>>>>>>> regression:
>>>>>>>
>>>>>>> OK yeah that's along the same lines with Nishant's RFC series in thread
>>>>>>> "[RFC PATCH 0/7] ARM: OMAP4+: PRM: minor cleanups and dt support of
>>>>>>> interrupts"
>>>>>>>
>>>>>>> FYI, it did not compile, needs to include linux/of_irq.h. But yes,
>>>>>>
>>>>>> I might have sent the wrong version as I had that same build error and
>>>>>> fixed it localy.
>>>>>>
>>>>>>> it fixes the regression for me, Also now the whole series works for
>>>>>>> me :)
>>>>>>
>>>>>> good to know.
>>>>>>
>>>>>> What do you want to do now ? Wait for PRCM to become a driver ? Wait for
>>>>>> Nishanth's series to get accepted ? I guess the same thing could be done
>>>>>> for OMAP3 and AM33, then we would have a chance of having working wake
>>>>> >from idle with the new irqchip.
>>>>>
>>>>> I can repost the current series as it stands now once 17-rc1 comes out
>>>>> (without the build failure ofcourse).. if that helps to move it out of
>>>>> RFC status.
>>>>
>>>> That'd be great. It would be ever greater if you could add support for
>>>> OMAP3 on that too.
>>>
>>> Yeah sounds good to me. Tero, does that work OK for your PRCM changes?
>>
>> Well, this set seems to break PM. suspend-resume on omap3-beagle just hangs
>> after this set is applied. Works fine without it with 3.16-rc5 tag.
>
> did you apply the quick little hack to prm3xxx.c ? prcm IRQ is hardcoded
> to 11, once we switch to a linear irq domain, irq_base may change.

Yea, with that hack it works. However, you should make that into a 
proper patch and add it to this series, otherwise you will be causing 
regressions. Just renaming that tmp into something meaningful for now 
should be enough for me at least.

-Tero

