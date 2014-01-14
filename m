Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaANLDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:03:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57750 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaANLDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:03:23 -0500
Date: Tue, 14 Jan 2014 12:03:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Waiman Long <waiman.long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140114110307.GW7572@laptop.programming.kicks-ass.net>
References: <52D353C8.4000000@numascale.com>
 <52D4172E.6030706@hp.com>
 <52D4A0C7.5070601@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D4A0C7.5070601@numascale.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 10:28:23AM +0800, Daniel J Blueman wrote:
> >Peter,
> >
> >I found out that the build failure was caused by the fact that the
> >__native_word() macro (used internally by compiletime_assert_atomic())
> >allows only a size of 4 or 8 for x86-64. The data type that I used is a
> >byte. Is there a reason why byte and short are not considered native?
> 
> It seems likely it was implemented like that since there was no existing
> need; long can be relied on as the largest native type, so this should
> suffice and works here:

There's Alphas that cannot actually atomically adres a byte; I do not
konw if Linux cares about them, but if it does, we cannot in fact rely
on this in generic primitives like this.
