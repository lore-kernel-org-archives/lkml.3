Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab3KKMdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:33:46 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38790 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3KKMdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:33:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131111104432.GA28302@mudshark.cambridge.arm.com>
References: <1383739658-10036-1-git-send-email-vkale@apm.com>
	<527D8A17.9020208@codeaurora.org>
	<20131111104432.GA28302@mudshark.cambridge.arm.com>
Date: Mon, 11 Nov 2013 18:03:38 +0530
Message-ID: <CAFpQJXW6_VXYBkkTrQedDSR6V4TcWEO_6vsheZ1oHXvmaRy+wg@mail.gmail.com>
Subject: Re: [PATCH 0/2] genirq: arm64: perf: support for percpu pmu interrupt
From: Ganapat Rao P Kulkarni <gpkulkarni@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, "jcm@redhat.com" <jcm@redhat.com>,
        "patches@apm.com" <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vinayak Kale <vkale@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

armv8pmu_read_counter() and armv8pmu_write_counter() treats cycle
counter as 32 bit counter.
AFAIK, the cycle counter  on ARM64 is 64 bit and overflow interrupt
comes either 32 bit changes or when 64 bit flips.
and HRM says, ARM deprecates use of PMCR_EL0.LC = 0   => cycle counter
of 64 bit only

My understanding is perf's common code designed based on 32 bit cycle counters.
what is the plan? are we going to maintain the same logic of 32 bit
counter with  writing 1 to upper 32 bits of 64 bit counter?

Vinayak,

I think, it will be helpful if you mention in patch description about
changes needed in dts file (like PMUIRQ number, PPI mode etc) to
migrate to PMUv3 which is PPI.



regards
Ganapat
PS: Sending again, since my previous email was not plain-text.


On Mon, Nov 11, 2013 at 4:14 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Sat, Nov 09, 2013 at 01:04:23AM +0000, Stephen Boyd wrote:
>> On 11/06/13 04:07, Vinayak Kale wrote:
>> > This patch series adds support to handle interrupt registration/deregistration
>> > in arm64 pmu driver when pmu interrupt type is percpu.
>> >
>> > Patches in this patch series were previously sent out as separate patches [1].
>> > This patch series incorporates comments/fixes suggested for original patches.
>> >
>> > [1]
>> > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/205888.html
>> > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204414.html
>> >
>> > Vinayak Kale (2):
>> >   genirq: error reporting in request_percpu_irq() and
>> >     request_threaded_irq()
>> >   arm64: perf: add support for percpu pmu interrupt
>> >
>> >  arch/arm64/kernel/perf_event.c |  109 +++++++++++++++++++++++++++++-----------
>> >  kernel/irq/manage.c            |   12 +++--
>> >  2 files changed, 89 insertions(+), 32 deletions(-)
>> >
>>
>> What ever happened to the approach here[1]? It doesn't look very nice to
>> have to request the irq first as a per-cpu interrupt and then try as a
>> non-percpu interrupt when genirq already knows if its per-cpu or not.
>>
>> [1] http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/02955.html
>
> Hmm, I'd completely forgotten about that approach. Whilst it certainly looks
> cleaner from a user perspective, I always get scared when I see
> 'desc->status_use_accessors' since it tends to incur the wrath of tglx :)
>
> That said, I guess that should be fine in irqdesc.h (basically adding a new
> accessor). Chris went missing after sending those initial patches, so
> perhaps Vinayak could look at resurrecting those?
>
> Will
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
regards,
Ganapat
