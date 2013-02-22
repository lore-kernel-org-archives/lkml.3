Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3BVLBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:01:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42042 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab3BVLBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:01:38 -0500
Message-ID: <51275058.7010809@ti.com>
Date: Fri, 22 Feb 2013 16:32:48 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos> <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com> <alpine.LFD.2.02.1302211436300.22263@ionos> <51263975.20906@ti.com> <alpine.LFD.2.02.1302212214020.22263@ionos> <5127436E.4040100@ti.com> <alpine.LFD.2.02.1302221122290.22263@ionos> <20130222103149.GC12140@e102568-lin.cambridge.arm.com>
In-Reply-To: <20130222103149.GC12140@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013 04:01 PM, Lorenzo Pieralisi wrote:
> On Fri, Feb 22, 2013 at 10:24:00AM +0000, Thomas Gleixner wrote:
>> On Fri, 22 Feb 2013, Santosh Shilimkar wrote:
>>> BTW, Lorenzo off-list mentioned to me about warning in boot-up
>>> which I missed while testing your patch. It will take bit more
>>> time for me to look into it and hence thought of reporting it.
>>>
>>> [    2.186126] ------------[ cut here ]------------
>>> [    2.190979] WARNING: at kernel/time/tick-broadcast.c:501
>>> tick_broadcast_oneshot_control+0x1c0/0x21c()
>>
>> Which one is that? tick_broadcast_pending or tick_force_broadcast_mask ?
>
> It is the tick_force_broadcast_mask and I think that's because on all
> systems we are testing, the broadcast timer IRQ is a thundering herd,
> all CPUs get out of idle at once and try to get out of broadcast mode
> at more or less the same time.
>
So the issue comes ups only when the idle state used where CPU wakeup
more or less at same time as Lorenzo mentioned. I have two platforms
where I could test the patch and see the issue only with one platform.

Yesterday I didn't notice the warning because it wasn't seen on that
platform :-) OMAP4 idle entry and exit in deep state is staggered
between CPUs and hence the warning isn't seen. On OMAP5 though,
there is an additional C-state where idle entry/exit for CPU
isn't staggered and I see the issue in that case.

Actually the broad-cast code doesn't expect such a behavior
from CPUs since only the broad-cast affine CPU should wake
up and rest of the CPU should be woken up by the broad-cast
IPIs.

Regards,
Santosh








