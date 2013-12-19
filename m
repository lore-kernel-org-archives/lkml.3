Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3LST13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:27:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34674 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LST11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:27:27 -0500
Date: Thu, 19 Dec 2013 20:27:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219192714.GP16438@laptop.programming.kicks-ass.net>
References: <20131219122257.GC11279@gmail.com>
 <52B316FF.50906@zytor.com>
 <20131219160210.GA28426@gmail.com>
 <52B31B21.6010901@zytor.com>
 <20131219162136.GM16438@laptop.programming.kicks-ass.net>
 <52B323BE.7090108@zytor.com>
 <20131219170741.GB30382@gmail.com>
 <52B33640.3020204@zytor.com>
 <20131219181948.GD32508@gmail.com>
 <52B34759.3010009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B34759.3010009@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:22:01AM -0800, H. Peter Anvin wrote:
> On 12/19/2013 10:19 AM, Ingo Molnar wrote:
> > 
> > ( It would also be nice to know whether MONITOR loads that cacheline 
> >   into the CPUs cache, and in what state it loads it. )
> > 
> 
> I would assume that is implementation-dependent.  However, one plausible
> implementation is to load the cache line into the cache in shared state
> and monitor for evictions.

I suppose the monitor part is the important part because certain C
states drop all cache, presumably including the cacheline we're actually
monitoring.


