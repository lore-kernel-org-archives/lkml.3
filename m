Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3KLGAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:00:46 -0500
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:54775 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751378Ab3KLGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <20131111104432.GA28302@mudshark.cambridge.arm.com>
References: <1383739658-10036-1-git-send-email-vkale@apm.com>
	<527D8A17.9020208@codeaurora.org>
	<20131111104432.GA28302@mudshark.cambridge.arm.com>
Date: Tue, 12 Nov 2013 11:30:38 +0530
Message-ID: <CAPrCYkf60+9RJ2aJ5ep3-j+ThdniJQHnUj_8POrCr7X2veKRZQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] genirq: arm64: perf: support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@apm.com" <patches@apm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jcm@redhat.com" <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Okay, in next patch revision I will use that approach.
