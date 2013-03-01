Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3CALVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:21:41 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57154 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab3CALVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:21:40 -0500
Date: Fri, 1 Mar 2013 16:51:32 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH v3 2/6] uretprobes/x86: hijack return address
Message-ID: <20130301112132.GC30500@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1362049215-5780-1-git-send-email-anton@redhat.com> <1362049215-5780-3-git-send-email-anton@redhat.com> <20130301054536.GB30500@in.ibm.com> <20130301110043.GA15426@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301110043.GA15426@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030111-5806-0000-0000-00002028A631
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 12:00:43PM +0100, Anton Arapov wrote:
> On Fri, Mar 01, 2013 at 11:15:36AM +0530, Ananth N Mavinakayanahalli wrote:
> > On Thu, Feb 28, 2013 at 12:00:11PM +0100, Anton Arapov wrote:

...

> > > +extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long
> > > +		rp_trampoline_vaddr, struct pt_regs *regs)
> > > +{
> > > +	int rasize, ncopied;
> > > +	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
> > > +
> > > +	rasize = is_ia32_task() ? 4 : 8;
> > > +	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
> > > +	if (unlikely(ncopied))
> > 
> > What if ncopied < rasize? Agreed that the upper order bits can be 0, but should
> > you not validate ncopied == rasize?
> 
>   Function returns 0 in case copy_from_user() was not able to copy
> return address entirely, and "if (ncopied)" makes sure of it. We 
> can't continue if we have no correct return address.
> 
>   copy_from_user() returns number of bytes that were *not* copied,
> thus "ncopied == rasize" means copy_from_user() was not able to copy
> *all* bytes. I don't see the point of such check here.
> 
>   Or am I missing anything?

You are right... my bad.

Ananth

