Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030336AbaGEAbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 20:31:00 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:36315 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbaGEAa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 20:30:58 -0400
Date: Sat, 5 Jul 2014 02:30:53 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Crispin <blogic@openwrt.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix incorrect NULL check in local_flush_tlb_page()
Message-ID: <20140705003053.GB3404@lianli>
References: <1404493623-22705-1-git-send-email-emilgoode@gmail.com>
 <CAOiHx==mR0eioTk=tc457z4ANbhFR2vS2A2y3wzw119jnCi2Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiHx==mR0eioTk=tc457z4ANbhFR2vS2A2y3wzw119jnCi2Pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonas,

On Fri, Jul 04, 2014 at 11:52:51PM +0200, Jonas Gorski wrote:
> On Fri, Jul 4, 2014 at 7:07 PM, Emil Goode <emilgoode@gmail.com> wrote:
> > We check that the struct vm_area_struct pointer vma is NULL and
> > then dereference it. The intent must have been to check that
> > vma is not NULL before we dereference it in the next condition.
> 
> Actually if it is NULL, then it will short-cut and won't dereference
> it (because !vma is true it can never become false again), so the
> condition would be fine previously.
> 
> But, looking at the code a few lines into branch:
> 
>         if (!vma || cpu_context(cpu, vma->vm_mm) != 0) {
>                 unsigned long flags;
>                 int oldpid, newpid, idx;
> 
> #ifdef DEBUG_TLB
>                 printk("[tlbpage<%lu,0x%08lx>]", cpu_context(cpu,
> vma->vm_mm), page);
> #endif
>                 newpid = cpu_context(cpu, vma->vm_mm) & ASID_MASK;
> 
> it will be then dereferenced here, so the change is actually sensible,
> even if the description isn't quite spot-on where it breaks.

Sorry, this is what I meant but failed to explain clearly.

Perhaps the following is a bit better?

We check that the struct vm_area_struct pointer vma is NULL and then
dereference it a few lines below. The intent must have been to make sure
that vma is not NULL and then to check the value from cpu_context() for the
condition to be true.

Best regards,

Emil Goode
