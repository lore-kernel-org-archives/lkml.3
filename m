Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaKKLZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:25:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:37685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaKKLY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:24:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="630077637"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141104155734.GL12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022143241.GT12706@worktop.programming.kicks-ass.net> <8738a4crgg.fsf@ashishki-desk.ger.corp.intel.com> <20141104155734.GL12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 11 Nov 2014 13:24:43 +0200
Message-ID: <87wq72asjo.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Oct 31, 2014 at 03:13:35PM +0200, Alexander Shishkin wrote:
>> >> +	if (test_cpu_cap(&boot_cpu_data, X86_FEATURE_INTEL_PT)) {
>> >> +		for (i = 0; i < PT_CPUID_LEAVES; i++)
>> >> +			cpuid_count(20, i,
>> >> +				    &pt_pmu.caps[CR_EAX + i * 4],
>> >> +				    &pt_pmu.caps[CR_EBX + i * 4],
>> >> +				    &pt_pmu.caps[CR_ECX + i * 4],
>> >> +				    &pt_pmu.caps[CR_EDX + i * 4]);
>> >> +	} else
>> >> +		return -ENODEV;
>> >
>> > I would really rather you use bitfield unions for cpuid stuff, have a
>> > look at union cpuid10_e[abd]x as used in
>> > perf_event_intel.c:intel_pmu_init().
>> 
>> It looks like it would only work for the first cpuid leaf, but we'll
>> need more than that. And the array makes it easier to allocate
>> attributes for sysfs en masse.
>> 
>> I guess it doesn't really matter if we use unions unless these bits need
>> to be exported to other parts of the kernel? But *that* is hardly a good
>> idea. What do you think?
>
> Ah yes, the generation. C is lacking there isn't it :/
>
> Now I'm not sure we want to export all the bits you're using though.
> Like the topa_multiple_entires, that appears an implementation detail
> userspace should not really care about either way.

Actually, userspace can make assumptions about lost data from this
bit. But there are others, such as encoded address length. In future
there will also be several "caps" with allowed values for certain bit
fields in RTIT_CTL, such as timing packet frequencies.

Regards,
--
Alex
