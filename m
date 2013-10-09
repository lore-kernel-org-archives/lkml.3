Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab3JITJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:09:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab3JITJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:09:34 -0400
Date: Wed, 9 Oct 2013 21:08:51 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009190851.GX30970@tucnak.zalov.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009124310.GA11769@redhat.com>
 <20131009140734.GH3081@twins.programming.kicks-ass.net>
 <20131009143359.GU26785@twins.programming.kicks-ass.net>
 <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009190231.GI13848@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 09:02:31PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 09, 2013 at 08:16:13PM +0200, Jakub Jelinek wrote:
> > Confirmed as gcc bug, filed http://gcc.gnu.org/PR58670
> > Seems all of 4.[6-9] miscompile it.  Will have a look tomorrow
> > unless somebody beats me to it.  But historically, the case where
> > asm goto labels jump to fallthru basic block had numerous problems in the
> > past.
> 
> That bug lists the component as middle end; this suggests x86_64 would
> be vulnerable too, can you confirm? So far we've only observed the wrong
> code on i386 targets, x86_64 targets appeared correct.

Any target, the testcase in the bugzilla aborts on x86_64 with -O2, and
even say on ppc64 (sure, one would have to rewrite the asm to have it fail
at runtime).

	Jakub
