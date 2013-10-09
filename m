Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3JISRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab3JISRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:17:15 -0400
Date: Wed, 9 Oct 2013 20:16:13 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009181613.GW30970@tucnak.zalov.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009124310.GA11769@redhat.com>
 <20131009140734.GH3081@twins.programming.kicks-ass.net>
 <20131009143359.GU26785@twins.programming.kicks-ass.net>
 <20131009144656.GV26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009144656.GV26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 04:46:56PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 09, 2013 at 04:33:59PM +0200, Peter Zijlstra wrote:
> > On Wed, Oct 09, 2013 at 04:07:34PM +0200, Peter Zijlstra wrote:
> > > Once I force a x86_64 build using the 'same' config it goes away and
> > > generates 'sensible' code again (although I don't see why L9 isn't
> > > merged with L2):
> > 
> > i386-SMP also generates correct code afaict; a tad stupid but not wrong.
> > 
> > If I remove ftrace from the .config its still broken..
> > If I also remove the likely/unlikely tracer its still broken and lots
> > smaller:
> 
> OK, its -march=winchip2 that's buggered.

Confirmed as gcc bug, filed http://gcc.gnu.org/PR58670
Seems all of 4.[6-9] miscompile it.  Will have a look tomorrow
unless somebody beats me to it.  But historically, the case where
asm goto labels jump to fallthru basic block had numerous problems in the
past.

	Jakub
