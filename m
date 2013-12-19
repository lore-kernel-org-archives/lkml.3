Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3LSRuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:50:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60596 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3LSRut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:50:49 -0500
Date: Thu, 19 Dec 2013 18:50:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219175037.GK2480@laptop.programming.kicks-ass.net>
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
 <20131219122257.GC11279@gmail.com>
 <52B316FF.50906@zytor.com>
 <20131219160210.GA28426@gmail.com>
 <52B31B21.6010901@zytor.com>
 <20131219162136.GM16438@laptop.programming.kicks-ass.net>
 <52B323BE.7090108@zytor.com>
 <20131219170741.GB30382@gmail.com>
 <20131219172535.GN16438@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219172535.GN16438@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:25:35PM +0100, Peter Zijlstra wrote:
> On Thu, Dec 19, 2013 at 06:07:41PM +0100, Ingo Molnar wrote:
> > Likewise, having a barrier before the MONITOR looks sensible as well. 
> 
> I again have to disagree, one would expect monitor to flush all that is
> required to start the monitor -- and it actually does so. As is
> testified by this extra CLFLUSH being called a bug workaround.

SDM states that MONITOR is ordered like a LOAD, and a LOAD cannot pass
a previous STORE to the same address.

That said; there's enough holes in there to swim a titanic through,
seeing how MONITOR stares at an entire cacheline and LOAD/STORE order is
specified on location, whatever that means.


