Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbaLKVFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:05:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169AbaLKVFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:05:46 -0500
Date: Thu, 11 Dec 2014 22:05:43 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        bpoirier@suse.de
Subject: Re: [Xen-devel] [PATCH v2 2/2] x86/xen: allow privcmd hypercalls
	to be preempted
Message-ID: <20141211210543.GQ25677@wotan.suse.de>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com> <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com> <CALCETrVAQ5JRoyL=V=fj+KxwUXfOTibKQkEDcvSqJzEi2sgshA@mail.gmail.com> <54897B76.6070500@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54897B76.6070500@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:09:42AM +0000, David Vrabel wrote:
> On 10/12/14 23:51, Andy Lutomirski wrote:
> > On Wed, Dec 10, 2014 at 3:34 PM, Luis R. Rodriguez
> > All that being said, this is IMO a bit gross.  You've added a bunch of
> > asm that's kind of like a parallel error_exit, and the error entry and
> > exit code is hairy enough that this scares me.  Can you do this mostly
> > in C instead?  This would look a nicer if it could be:
> 
> I abandoned my initial attempt that looked like this because I thought
> it was gross too.
> 
> >     call xen_evtchn_do_upcall
> >     popq %rsp
> >     CFI_DEF_CFA_REGISTER rsp
> >     decl PER_CPU_VAR(irq_count)
> > +  call xen_end_upcall
> >     jmp error_exit
> > 
> > Where xen_end_upcall would be witten in C, nokprobes and notrace (if
> > needed) and would check pt_regs and whatever else and just call
> > schedule if needed?
> 
> Oh that's a good idea, thanks!

David, are you going to respin yourself with the goal to get this upstream?
If so I can move on with life on other matters.

  Luis
