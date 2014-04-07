Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbaDGTAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:00:05 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50474 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026AbaDGS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:59:54 -0400
Date: Mon, 7 Apr 2014 20:59:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Michele Ballabio <barra_cuda@katamail.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
Message-ID: <20140407185949.GC4106@localhost.localdomain>
References: <5341707F.5000406@katamail.com>
 <20140407150337.GO10526@twins.programming.kicks-ass.net>
 <20140407150705.GB13658@twins.programming.kicks-ass.net>
 <5342EB78.3060002@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5342EB78.3060002@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 08:16:24PM +0200, Toralf Förster wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On 04/07/2014 05:07 PM, Peter Zijlstra wrote:
> > On Mon, Apr 07, 2014 at 05:03:37PM +0200, Peter Zijlstra wrote:
> >> So what I suspect at this point is that because i386 and x86_64
> >> have a difference in current_thread_info() (i386 is stack based),
> >> we end up setting the TIF_NEED_RESCHED bit on the wrong stack.
> >> 
> >> Now I have some vague memories of propagating the TIF flags on
> >> stack switch, but I cannot remember what arch we did that for.
> >> Let me stare at this a little more.
> >> 
> >> Also, IFF this is the case, then the fingered patch above (and
> >> your suggested 'fix') aren't the real curlpit/cure but simply
> >> make it more/less likely to happen.
> >> 
> >> Now, Steve had a patch somewhere that would make i386 use
> >> per-cpu variables for current_thread_info() just like x86_64
> >> already does I think. Let me go find them too.
> > 
> > Ohh, goodie, they're already in Linus' tree. Could you see if
> > current git still suffers this problem?
> > 
> v3.14-10353-g2b3a8fd works fine AFAICS
> (BTW the fix is stable material, right ?)

If we are reffering to 198d208df4371734ac4728f69cb585c284d20a15
(x86: Keep thread_info on thread stack in x86_32) it doesn't
carry a stable tag.

So to be clear, you are saying that v3.14 is fine but other release
are buggy? Which ones are these?

If a backport is needed, 198d208df4371734ac4728f69cb585c284d20a15 looks too large...
