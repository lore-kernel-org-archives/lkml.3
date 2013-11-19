Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3KSTOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:14:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46747 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3KSTOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:14:52 -0500
Date: Tue, 19 Nov 2013 20:14:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] core kernel update
Message-ID: <20131119191434.GQ16796@laptop.programming.kicks-ass.net>
References: <20131119154253.GA12219@gmail.com>
 <CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com>
 <20131119190904.GA22076@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119190904.GA22076@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 08:09:04PM +0100, Ingo Molnar wrote:
> The actual value of the limit - here's the on-stack cpumask sizes of 
> the candidate range:
> 
> 	128 CPUs: 16 byte cpumasks
> 	256 CPUs: 32 byte cpumasks
> 	512 CPUs: 64 byte cpumasks

So 512 / 64bytes is a single cacheline and feels like a nice cut-off
before requiring an extra indirection and more cachelines.

64 bytes also doesn't sound _that_ big to have on-stack.

So I'd go for having the cut-off on >512, unless of course theres
evidence 64bytes is already too much.
