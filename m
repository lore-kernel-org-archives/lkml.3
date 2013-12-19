Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3LSSOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:14:17 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:45087 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3LSSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:14:14 -0500
Date: Thu, 19 Dec 2013 19:14:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219181410.GB32508@gmail.com>
References: <20131219122257.GC11279@gmail.com>
 <52B316FF.50906@zytor.com>
 <20131219160210.GA28426@gmail.com>
 <52B31B21.6010901@zytor.com>
 <20131219162136.GM16438@laptop.programming.kicks-ass.net>
 <52B323BE.7090108@zytor.com>
 <20131219170741.GB30382@gmail.com>
 <20131219172535.GN16438@laptop.programming.kicks-ass.net>
 <20131219173629.GJ2480@laptop.programming.kicks-ass.net>
 <52B33567.9060205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B33567.9060205@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/19/2013 09:36 AM, Peter Zijlstra wrote:
> > On Thu, Dec 19, 2013 at 06:25:35PM +0100, Peter Zijlstra wrote:
> >> That said, I would find it very strange indeed if a CLFLUSH doesn't also
> >> flush the store buffer.
> > 
> > OK, it explicitly states it does not do that and you indeed need 
> > an mfence before the clflush.
> 
> So, MONITOR is defined to be ordered as a load, which I think should 
> be adequate, but I really wonder if we should have mfence on both 
> sides of clflush.  This now is up to 9 bytes, and perhaps pushing it 
> a bit with how much we would be willing to patch out.
> 
> On the other hand - the CLFLUSH seems to have worked well enough by 
> itself, and this is all probabilistic anyway, so perhaps we should 
> just leave the naked CLFLUSH in and not worry about it unless 
> measurements say otherwise?

So I think the window of breakage was rather large here, and since it 
seems to trigger on rare types of hardware I think we'd be better off 
by erring on the side of robustness this time around ...

This is the 'go to idle' path, which isn't as time-critical as the 
'get out of idle' code path.

Thanks,

	Ingo
