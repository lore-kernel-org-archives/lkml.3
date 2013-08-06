Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3HFUdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:33:24 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34508 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752042Ab3HFUdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:33:23 -0400
Date: Tue, 6 Aug 2013 16:33:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130806203319.GA16170@Krystal>
References: <1375721715.22073.80.camel@gandalf.local.home> <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com> <1375725328.22073.101.camel@gandalf.local.home> <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com> <1375727977.22073.112.camel@gandalf.local.home> <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com> <1375798783.25420.30.camel@gandalf.local.home> <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com> <1375811885.25420.44.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375811885.25420.44.camel@gandalf.local.home>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2013-08-06 at 10:48 -0700, Linus Torvalds wrote:
> 
> > So I wonder if this is a "ok, let's not bother, it's not worth the
> > pain" issue. 128 bytes of offset is very small, so there probably
> > aren't all that many cases that would use it.
> 
> OK, I'll forward port the original patches for the hell of it anyway,
> and post it as an RFC. Let people play with it if they want, and if it
> seems like it would benefit the kernel perhaps we can reconsider.
> 
> It shouldn't be too hard to do the forward port, and if we don't ever
> take it, it would be a fun exercise regardless ;-)
> 
> Actually, the first three patches should be added as they are clean ups
> and safety checks. Nothing to do with the actual 2-5 byte jumps. They
> were lost due to their association with the complex patches. :-/

Steve, perhaps you could add a mode to your binary rewriting program
that counts the number of 2-byte vs 5-byte jumps found, and if possible
get a breakdown of those per subsystem ? It might help us getting a
clearer picture of how many important sites, insn cache-wise, are being
shrinked by this approach.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
