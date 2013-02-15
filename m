Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707Ab3BOP6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:58:04 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59835 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3BOP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:58:02 -0500
Date: Fri, 15 Feb 2013 16:57:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
Message-ID: <20130215155757.GD3324@gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
 <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com>
 <20130214105027.GB25282@gmail.com>
 <CA+55aFxxt4Qu=kSGCuvqh+veotL7P=14mHiFTUUNgkh3UwRiDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxxt4Qu=kSGCuvqh+veotL7P=14mHiFTUUNgkh3UwRiDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Btw, it may end up that almost nobody cares. Modern CPU's are 
> really good at handling the straightforward "save/restore to 
> stack" instructions. One of the reasons I care is not 
> performance per se, butu the fact that I still look at asm 
> code every time I do any performance profiling, and it's 
> absolutely horrible to see the code when you see "ugh, that's 
> pointless". I'm sensitive to the spinlocks in particular, 
> because we've gone back and forth on inlining them before, so 
> I've seen this. But right now I don't think we inline the lock 
> under normal configs *anyway*, so I guess it doesn't much 
> matter.

Yes, right now we only inline non-debug spin_unlock() and 
spin_unlock_irq() [on !PREEMPT] - because that was an 
unconditional win.

Thanks,

	Ingo
