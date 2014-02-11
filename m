Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaBKCqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:46:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:53339 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaBKCqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:46:08 -0500
Message-ID: <1392086660.3996.50.camel@pasglop>
Subject: Re: [PATCH v2] powerpc ticket locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 11 Feb 2014 13:44:20 +1100
In-Reply-To: <20140210155217.GF2107@lst.de>
References: <20140207165801.GC2107@lst.de>
	 <1392001823.3996.21.camel@pasglop> <20140210155217.GF2107@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Linus, Al, a question for you down there about lockref "ref" size)

On Mon, 2014-02-10 at 16:52 +0100, Torsten Duwe wrote:

> What if I squeeze the bits a little?
> 4k vCPUs, and 256 physical, as a limit to stay within 32 bits?
> At the cost that unlock may become an ll/sc operation again.
> I could think about a trick against that.
> But alas, hw_cpu_id is 16 bit, which makes a lookup table neccessary :-/
> 
> Doing another round of yields for lockrefs now doesn't
> sound so bad any more.

So, the ticketpair has to be 16:16 so we can avoid the atomic on unlock

That leaves us with 32 bits to put the ref and the owner. The question
is how big the ref really has to be and can we have a reasonable failure
mode if it overflows ?

If we limit ourselves to, for example, 16-bit for the ref in lockref,
then we can have the second 32-bit split between the owner and the ref.

If we limit ourselves to 4k CPUs, then we get 4 more bits of ref ...

So the question is, is it reasonable to have the ref smaller than
32-bit...

Cheers,
Ben.


