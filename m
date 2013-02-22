Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab3BVOZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:25:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49672 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3BVOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:25:41 -0500
Message-ID: <1361543128.26780.65.camel@laptop>
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Date: Fri, 22 Feb 2013 15:25:28 +0100
In-Reply-To: <20130222141635.GA9606@gmail.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	 <1361522767.26780.44.camel@laptop>
	 <20130222125019.GC17948@somewhere.redhat.com>
	 <1361540926.26780.56.camel@laptop> <20130222135411.GA9202@gmail.com>
	 <1361541894.26780.62.camel@laptop> <20130222141635.GA9606@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 15:16 +0100, Ingo Molnar wrote:
> > I checked arch/x86/include/asm/atomic64_32.h and we use 
> > cmpxchg8b for everything from _set() to _read(), which 
> > translates into 'horridly stupendifyingly slow' for a number 
> > of machines, but coherent.
> 
> That's a valid concern - and cmpxchg8b is the only 64-bit op 
> available on most 32-bit x86 CPUs which does not involve the 
> FPU.
> 
> Wondering how significant this range of x86 problem boxes will 
> be by the time any of these changes reaches upstream and distros 
> - and how much 'horridly stupendifyingly slow' is in terms of 
> cycles expended.

On the !x86 side of things we're implementing (generic) atomic64 using
hashed spinlocks, so there too using a single spinlock around the
entire data structure is a complete win.

