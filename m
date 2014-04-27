Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaD0Lun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 07:50:43 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37633 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaD0Lul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 07:50:41 -0400
Date: Sun, 27 Apr 2014 13:50:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oren Twaig <oren@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
Message-ID: <20140427115036.GA22116@gmail.com>
References: <1398376326-3055-1-git-send-email-oren@scalemp.com>
 <20140425080137.GC19588@gmail.com>
 <535A421F.4010108@scalemp.com>
 <20140426060959.GA1944@gmail.com>
 <535CA9F6.7010101@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535CA9F6.7010101@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oren Twaig <oren@scalemp.com> wrote:

> Hi Ingo,
> 
> On 04/26/2014 09:09 AM, Ingo Molnar wrote:
> > I still don't see a clear explanation of what the _user_ saw and sees
> > before and after the change. What is the effect of the patch: correct
> > IRQ routing (i.e. before the change IRQs would end up on the wrong
> > CPU), lower overhead IRQ routing (i.e. before the change IRQ routing
> > overhead was more expensive), or something else?
> >
> > You don't spell this out clearly and it's a crucial piece of
> > information that comes before every other explanation.
> >
> I see.. I tried to explain the entire flow and that was confusing - I'll explain
> only the patch.
> 
> As you stated, in general, the patch corrects IRQ routing in case a vSMP
> Foundation box is detected but the Interrupt Routing Comply (IRC) is set to
> "comply".
> 
> Before the patch:
> When a vSMP Foundation box was detected and IRC was set to "comply", users (and
> kernel) couldn't effectively set the destination of the IRQs. This is because
> the hook inside vsmp_64.c always setup all CPUs as the IRQ destination using
> cpumask_setall() as the return value for IRQ allocation mask. Later, this
> "overrided" mask caused the kernel to set the IRQ destination to the lowest
> online CPU in the mask (CPU0 usually).
> 
> After the patch:
> When the IRC is set to "comply", Users (and kernel) can control the destination
> of the IRQs as we will not be changing the default
> "apic->vector_allocation_domain".

Much better, thanks!

	Ingo
