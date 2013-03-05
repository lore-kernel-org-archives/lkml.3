Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3CENS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 08:18:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab3CENS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:18:28 -0500
Date: Tue, 5 Mar 2013 14:18:13 +0100
From: Anton Arapov <anton@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH v4 5/6] uretprobes: invoke return probe handlers
Message-ID: <20130305131813.GA24229@bandura.brq.redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
 <1362407893-32505-6-git-send-email-anton@redhat.com>
 <20130305070326.GA5684@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305070326.GA5684@in.ibm.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 12:33:26PM +0530, Ananth N Mavinakayanahalli wrote:
> On Mon, Mar 04, 2013 at 03:38:12PM +0100, Anton Arapov wrote:
> > 
> > diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> > index c353555..fa9d9de 100644
> > --- a/arch/x86/include/asm/uprobes.h
> > +++ b/arch/x86/include/asm/uprobes.h
> > @@ -56,4 +56,9 @@ extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> >  extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> >  extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> >  extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs);
> > +
> > +static inline unsigned long arch_uretprobe_get_sp(struct pt_regs *regs)
> > +{
> > +	return (unsigned long)regs->sp;
> > +}
> 
> You could use GET_USP() here.
perhaps, which in turn is a helper for user_stack_pointer() :) comment
is valid though.

thanks,
Anton.
