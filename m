Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbaDZGKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 02:10:06 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46441 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaDZGKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 02:10:04 -0400
Date: Sat, 26 Apr 2014 08:09:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oren Twaig <oren@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
Message-ID: <20140426060959.GA1944@gmail.com>
References: <1398376326-3055-1-git-send-email-oren@scalemp.com>
 <20140425080137.GC19588@gmail.com>
 <535A421F.4010108@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A421F.4010108@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oren Twaig <oren@scalemp.com> wrote:

> On 4/25/2014 11:01 AM, Ingo Molnar wrote:
> >
> > * Oren Twaig <oren@scalemp.com> wrote:
> >
> >> vSMP Foundation provides locality based interrupt routing which needed
> >> vector_allocation_domain to allow all online cpus can handle all
> possible
> >> vectors.
> >>
> >> Enforcing Interrupt Routing Comply (IRC) mode requires us to
> unplug this hook as
> >> otherwise the IOAPIC, MSI and MSIX destination selectors to
> always select the
> >> lowest online cpu as the destination. I.e affinity of HW
> interrupts cannot be
> >> controled by kernel and/or userspace code.
> >>
> >> The purpose of the patch is to fix the code to set override
> vector allocation
> >> domain only when IRC is set to ignore to allow the kernel and
> userspace to
> >> effectively control the destination of the HW interrupts.
> >>
> >> Signed-off-by: Oren Twaig <oren@scalemp.com>
> >> Acked-by: Shai Fultheim <shai@scalemp.com>
> >
> > So what was the behavior before the change - certain IRQs did not get
> > routed, they just ended up on CPU0 or on some other undesirable CPU?
> > Or was IRQ distribution random? It's not clear from the changelog.
> 
> It all depends on the IRC flag. When set to "ignore" by the linux 
> kernel, vSMP Foundation knew that it can deliver the IRQ to the CPU 
> which would result in less virtualization overhead. For example, we 
> could deliver the HW interrupt to the CPU which got it or any other 
> CPU in the system. We couldn't have done it without the kernel 
> making sure that each vector can be passed to all CPUs. This is why 
> we override the verctor allocation domain to signal all CPUs.
> 
> But, when the IRC is set to "comply" we, before this patch, still 
> efected the allocation domains alltough it wasn't needed. It wasn't 
> needed because when in "comply" mode, we always pass the HW 
> interrupt to the CPU the kernel requested (by setting the IOAPIC 
> entry, MSI/X entry or IR entry)

I still don't see a clear explanation of what the _user_ saw and sees 
before and after the change. What is the effect of the patch: correct 
IRQ routing (i.e. before the change IRQs would end up on the wrong 
CPU), lower overhead IRQ routing (i.e. before the change IRQ routing 
overhead was more expensive), or something else?

You don't spell this out clearly and it's a crucial piece of 
information that comes before every other explanation.

Thanks,

	Ingo
