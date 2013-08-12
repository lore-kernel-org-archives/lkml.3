Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3HLRxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:53:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51819 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab3HLRxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:53:03 -0400
Message-ID: <520920AF.1050407@zytor.com>
Date: Mon, 12 Aug 2013 10:51:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
References: <20130812115113.GE27162@twins.programming.kicks-ass.net> <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
In-Reply-To: <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 10:35 AM, Linus Torvalds wrote:
> 
> Agreed. Making it atomic would suck, and cancel all advantages of the
> better code generation to access it. Good point.
> 
> And yeah, it could be two variables in the same cacheline or something.
> 

So we would have code looking something like:

	decl %fs:preempt_count
	jnz 1f
	cmpb $0,%fs:need_resched
	je 1f
	call __preempt_schedule
1:

It's a nontrivial amount of code, but would seem a fair bit better than
what we have now, at least.

	-hpa

