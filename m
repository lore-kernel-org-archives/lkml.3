Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaJHQXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:23:23 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:50949 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaJHQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:23:22 -0400
Date: Wed, 8 Oct 2014 18:23:13 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
Message-ID: <20141008162313.GA38790@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <1412782664.5179.75.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412782664.5179.75.camel@marge.simpson.net>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 05:37:44PM +0200, Mike Galbraith wrote:
> Seems you opened a can of futex worms...

Awesome.

> I don't see that on the 2 x E5-2697 box I borrowed to take a peek.  Once
> I got stockfish to actually run to completion by hunting down and brute
> force reverting the below, I see ~32 million nodes/sec throughput with
> 3.17 whether I use taskset or just let it do its thing.

Interesting. If you open up top, do you see (like me) the load being spread
out across multiple CPUs, or do they actually stay in place like they're
supposed to?

I suppose you run with Threads set to 28, right? (And not, say, 56.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
