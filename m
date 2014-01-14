Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaANUUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:20:21 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50730 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaANUUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:20:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAGo_u6oKpRFnPAWaqr9NTNAJB+m56jiDgBUgvsiZpaQ-3SF2kw@mail.gmail.com>
References: <1389625399-24087-1-git-send-email-taras.kondratiuk@linaro.org>
	<52D404DE.2020806@ti.com>
	<CAArO44samX_uMeC93w4DBbC+yskEmrvVt_i-5VV_seatM56ypw@mail.gmail.com>
	<52D55CE5.1060902@ti.com>
	<CAA3XUr2cnF_rxMYvZfjBx22Sa8YE45o_qUU8GNoerQwhWqxhNQ@mail.gmail.com>
	<CAGo_u6oKpRFnPAWaqr9NTNAJB+m56jiDgBUgvsiZpaQ-3SF2kw@mail.gmail.com>
Date: Tue, 14 Jan 2014 12:20:17 -0800
Message-ID: <CAA3XUr1_cNuPmMU6Fs6c7Si2So0VFGcLyGJe+tS_R47BVKRXnw@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: sleep: byteswap data for big-endian
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2014 09:56, Nishanth Menon <nm@ti.com> wrote:
> On Tue, Jan 14, 2014 at 11:35 AM, Victor Kamensky
> <victor.kamensky@linaro.org> wrote:
>>
>> When BE kernel is built Makefile does take of compiling code in BE
>> mode. I.e all proper flags like -mbig-endian and -Wl,--be8 will be set.
>
> Agreed, and I assume you cannot instead switch to LE mode when
> entering assembly assuming LE?

Yes. Note that this asm interacts with other data in kernel that would
be in BE form. And after all linker will not allow to put together files
that were compiled in different endianity.

> The reason I ask this is - most of our development is NOT in BE mode.
> we will continue to manipulate and add assembly - AM335x, DRA7/OMAP5
> etc.. and obviously not every code change will indulge in ensuring
> right markers will be in place.
>
> by ensuring readl_relaxed handles the variations, you have ensured
> that I dont need to care about drivers other than to ensure they use
> _relaxed variants. in the case of assembly, this does not seem long
> term manageable.

Yes, I agree if it is outside of main use case it will get broken if not
attended to. Definitely universe entropy increases :) - if left without
attention things will decay. Note we admit that even with ARM CPU
core BE changes similar decay can happen eventually ...that is
what LNG BE group trying to prevent. I think
the deal here is that next user of it can/need to fix things if they
decayed.

>>
>>> is the idea of BE build meant to deal with having a single BE kernel
>>> build work for all platforms (including LE ones)?
>>
>> Sort of. The idea here to run BE image on OMAP4 chip, with
>> kernel that would deals with LE periphery correctly, but ARM
>> core run in BE with special kernel that compiled for BE case (i.e
>> CONFIG_CPU_BIG_ENDIAN is set).
>
> I still dont get the usecase - other than "hey, we do this coz we can
> do it!".. I mean, yep, it sounds great and all.. but 4 years down the
> line, is this still going to work? is this going to be interesting
> careabout? or we are just maintaining additional code for a passing
> fancy or proof-of-concept?

Valid concern. From LNG BE group point of view it is not "we can do
it". It is more like we've done it. We have Pandaboard ES running BE
kernel for a while. It is in LNG BE tree. We used it as development
and testing vehicle for BE work for a while. We are very grateful to
the platform for that - it is affordable and easily available! Given,
beyond ongoing BE testing on Pandaboard in LNG there may not be valid
use case for further things on OMAP4 BE. We had discussion
with Santosh Shilimkar from TI during last Linaro connect what to
do with LNG BE Pandaboard series. Santosh suggested and we
agreed that we would try to contribute them back to community. And
that is what Taras is doing. IMHO even though there may not be real
product use case for BE OMAP4, it could serve in kernel source as good
example that shows how to work with LE periphery from BE kernel. After
all, these changes are noop for LE case and they don't introduce
a lot of clutter: all BE asm rev and rev16 instructions wrapped around
with ARM_BE8 macro.

Thanks,
Victor

> Regards,
> Nishanth Menon
