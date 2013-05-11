Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3EKHgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 03:36:44 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49460 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3EKHgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 03:36:42 -0400
Date: Sat, 11 May 2013 09:36:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mm: Remove unnecessary assignment for
 max_pfn_mapped:q
Message-ID: <20130511073638.GA24435@gmail.com>
References: <518CB758.4000101@cn.fujitsu.com>
 <CAE9FiQVpbDJT2Ma6MHkB5aF9PUuGCia_QaLc_LjYCLJb4nKebg@mail.gmail.com>
 <518CCBB2.5010308@cn.fujitsu.com>
 <CAE9FiQWcKAJ0DP833urozcECkZNpbCks_vLVBf8UhaXTRSEWzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWcKAJ0DP833urozcECkZNpbCks_vLVBf8UhaXTRSEWzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Fri, May 10, 2013 at 3:28 AM, Zhang Yanfei
> <zhangyanfei@cn.fujitsu.com> wrote:
> > ?? 2013??05??10?? 17:27, Yinghai Lu ????:
> >> On Fri, May 10, 2013 at 2:01 AM, Zhang Yanfei
> >> <zhangyanfei@cn.fujitsu.com> wrote:
> >>> init_memory_mapping will set max_pfn_mapped:
> >>> int_memory_mapping
> >>>   --> add_pfn_range_mapped
> >>>     --> max_pfn_mapped = max(max_pfn_mapped, end_pfn)
> >>>
> >>> In init_mem_mapping, before we set max_pfn_mapped to 0, we
> >>> have already called init_memory_mapping to setup pagetable
> >>> for [0, ISA_END_ADDRESS], and that sets max_pfn_mapped. So
> >>> the assignment to 0 is not necessary, remove it.
> >>
> >> NAK.
> >>
> >> for 32bit or Xen, max_pfn_mapped is set way before in head_32.S and
> >> xen-enlighen.
> >
> > Hi Yinghai
> >
> > I might be wrong, but just from the code in init_mem_mapping only:
> >
> >  410         /* the ISA range is always mapped regardless of memory holes */
> >  411         init_memory_mapping(0, ISA_END_ADDRESS);
> >  412
> >  413         /* xen has big range in reserved near end of ram, skip it at first.*/
> >  414         addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
> >  415         real_end = addr + PMD_SIZE;
> >  416
> >  417         /* step_size need to be small so pgt_buf from BRK could cover it */
> >  418         step_size = PMD_SIZE;
> >  419         max_pfn_mapped = 0; /* will get exact value next */
> >
> > Line 411 set max_pfn_mapped, and then line 419 set it to zero again, so
> > why keep the later assignment?
> 
> the comment says: /* will get exact value next */

And what does that comment mean??

next where? Which call? How? What's the logic? Where is it described 
accurately so that people who haven't seen the code (for a while) can 
understand it?

> For x86 32bit path, and xen set bigger max_pfn_mapped before.

and what does this mean? Perhaps:

 "32-bit x86 and Xen set a bigger value for max_pfn_mapped before this 
  call."

?

And where and why does it matter that we set a bigger max_pfn_mapped 
before?

The dependencies in this code are incestous.

Thanks,

	Ingo
