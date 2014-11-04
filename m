Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaKDP5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:57:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaKDP5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:57:44 -0500
Date: Tue, 4 Nov 2014 16:57:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141104155734.GL12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022143241.GT12706@worktop.programming.kicks-ass.net>
 <8738a4crgg.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738a4crgg.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 03:13:35PM +0200, Alexander Shishkin wrote:
> >> +	if (test_cpu_cap(&boot_cpu_data, X86_FEATURE_INTEL_PT)) {
> >> +		for (i = 0; i < PT_CPUID_LEAVES; i++)
> >> +			cpuid_count(20, i,
> >> +				    &pt_pmu.caps[CR_EAX + i * 4],
> >> +				    &pt_pmu.caps[CR_EBX + i * 4],
> >> +				    &pt_pmu.caps[CR_ECX + i * 4],
> >> +				    &pt_pmu.caps[CR_EDX + i * 4]);
> >> +	} else
> >> +		return -ENODEV;
> >
> > I would really rather you use bitfield unions for cpuid stuff, have a
> > look at union cpuid10_e[abd]x as used in
> > perf_event_intel.c:intel_pmu_init().
> 
> It looks like it would only work for the first cpuid leaf, but we'll
> need more than that. And the array makes it easier to allocate
> attributes for sysfs en masse.
> 
> I guess it doesn't really matter if we use unions unless these bits need
> to be exported to other parts of the kernel? But *that* is hardly a good
> idea. What do you think?

Ah yes, the generation. C is lacking there isn't it :/

Now I'm not sure we want to export all the bits you're using though.
Like the topa_multiple_entires, that appears an implementation detail
userspace should not really care about either way.


