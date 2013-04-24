Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3DXPjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:39:21 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:45341 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3DXPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:39:19 -0400
Date: Wed, 24 Apr 2013 17:39:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/6] signal x86: Propage RF EFLAGS bit throught the
 signal restore call
Message-ID: <20130424153914.GC6993@somewhere>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
 <1362940871-24486-2-git-send-email-jolsa@redhat.com>
 <20130416010524.GH17561@somewhere.redhat.com>
 <20130416144226.GA12848@redhat.com>
 <20130417200206.GA18253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130417200206.GA18253@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 10:02:06PM +0200, Oleg Nesterov wrote:
> On 04/16, Oleg Nesterov wrote:
> >
> > On 04/16, Frederic Weisbecker wrote:
> > >
> > > On Sun, Mar 10, 2013 at 07:41:06PM +0100, Jiri Olsa wrote:
> > > > Adding RF EFLAGS bit to be restored on return from signal from
> > > > the original register context before the signal was entered.
> > > >
> > > > This will prevent the RF flag to disappear when returning
> > > > from exception due to the signal handler being executed.
> > >
> > > So that happens if, say, we get a breakpoint exception and then we
> > > run a signal handler before returning to the ip that triggered the
> > > breakpoint?
> >
> > Afaics these changes (1 and 2) should fix the bug.
> >
> > Suppose that the first insn in the signal handler should trigger
> > another bp, we should clear X86_EFLAGS_RF (2/6).
> >
> > Otoh, we should restore it when we return to the original insn
> > which triggered the trap to avoid another trap.
> 
> I applied 1 and 2, and this fixes the test-case below.
> 
> > But. it seems that we have yet another problem? Suppose that
> > the signal handler does siglongjmp() and jumps to yet another
> > insn which should trigger the trap?
> 
> Argh. Sorry for confusion. I tried to say that the signal handler
> can play with sigcontext->ip before sigreturn(). But probably we
> can ignore this.

Hmm, ok.

Anyway patches 1-3 look good!

Thanks!
