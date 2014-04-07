Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaDGPHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:07:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48167 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaDGPHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:07:13 -0400
Date: Mon, 7 Apr 2014 17:07:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michele Ballabio <barra_cuda@katamail.com>
Cc: linux-kernel@vger.kernel.org, toralf.foerster@gmx.de, fweisbec@gmail.com,
        mingo@kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
Message-ID: <20140407150705.GB13658@twins.programming.kicks-ass.net>
References: <5341707F.5000406@katamail.com>
 <20140407150337.GO10526@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407150337.GO10526@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 05:03:37PM +0200, Peter Zijlstra wrote:
> So what I suspect at this point is that because i386 and x86_64 have a
> difference in current_thread_info() (i386 is stack based), we end up
> setting the TIF_NEED_RESCHED bit on the wrong stack.
> 
> Now I have some vague memories of propagating the TIF flags on stack
> switch, but I cannot remember what arch we did that for. Let me stare at
> this a little more.
> 
> Also, IFF this is the case, then the fingered patch above (and your
> suggested 'fix') aren't the real curlpit/cure but simply make it
> more/less likely to happen.
> 
> Now, Steve had a patch somewhere that would make i386 use per-cpu
> variables for current_thread_info() just like x86_64 already does I
> think. Let me go find them too.

Ohh, goodie, they're already in Linus' tree. Could you see if current
git still suffers this problem?
