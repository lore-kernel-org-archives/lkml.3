Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaEPNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:16:58 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39536 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaEPNQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:16:57 -0400
Date: Fri, 16 May 2014 09:16:53 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Richard Lee <superlibj8301@gmail.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, iamjoonsoo.kim@lge.com,
        santosh.shilimkar@ti.com, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Li.Xiubo@freescale.com,
        robherring2@gmail.com, linux-kernel@vger.kernel.org,
        lauraa@codeaurora.org
Subject: Re: [PATCHv2] ARM: ioremap: Fix static vm area boundary checking.
In-Reply-To: <CAHPCO9GrwRczw2R9nZDL0tDdYxSHV0f2aDhFSat+xhhiWaYbUg@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405160910220.17310@knanqh.ubzr>
References: <1400142562-9111-1-git-send-email-superlibj8301@gmail.com> <alpine.LFD.2.11.1405151325250.17310@knanqh.ubzr> <CAHPCO9GrwRczw2R9nZDL0tDdYxSHV0f2aDhFSat+xhhiWaYbUg@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Richard Lee wrote:

> On Fri, May 16, 2014 at 1:28 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Thu, 15 May 2014, Richard Lee wrote:
> >
> >> Static vm area boundary check:
> >>
> >>       paddr1 --->|       |
> >>                  |       |
> >>                  |-------| <-\--- svm->vm->addr(is page aligned)
> >>       paddr2 --->|       |    |
> >>                  |     --| <--|-- svm->vm->phys_addr
> >>                  |       |    |
> >>       paddr3 --->|       |    |
> >>                  |       |    |
> >>                  |-------| <--|-- next page boundary
> >>                  |       |    |
> >>       paddr4 --->|       |    | <----- svm->vm->size(including guard page)
> >>                  |       |    |
> >>                  |       |    |
> >> max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
> >>                  | ///// |    |
> >>       paddr5 --->| guard |    |
> >>                  | page  |    |
> >>                  | ///// |    |
> >>                   -------  <-/--- svm->vm->addr + svm->vm_size
> >>
> >> <1> If the paddr == paddr1, then continue;
> >> <2> If the paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
> >>     then continue;
> >> <3> if the paddr >= paddr5 then continue;
> >>
> >> Signed-off-by: Richard Lee <superlibj8301@gmail.com>
> >
> > instead of doing this repeatedly, why not simply ensure the recorded
> > static vm information is already page aligned in the first place?
> >
> 
> Sorry, I'm not very sure what vm information you meant here.
> 
> And the 'svm->vm->addr' and 'svm->vm->size' are all page aligned
> already, but we cannot make sure that the 'paddr' and
> 'svm->vm->phys_addr' are page aligned.

If ->vm->addr is page aligned, then ->vm->phys_addr must be page aligned 
as well.  The hardware does virtual to physical mappings on a page 
granularity.  It is then not important to align paddr for the purpose of 
the search.

In other words, I fail to understand what problem your patch solves.


Nicolas
