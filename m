Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3IRGvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:51:13 -0400
Received: from ozlabs.org ([203.10.76.45]:50848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3IRGvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:51:12 -0400
Date: Wed, 18 Sep 2013 16:51:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] irq: Fix stack overflow due to softirq called on
 current stack
Message-ID: <20130918065101.GA22060@drongo>
References: <1378330796.4321.50.camel@pasglop>
 <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

On Thu, Sep 05, 2013 at 05:33:21PM +0200, Frederic Weisbecker wrote:
> 
> This series is a proposition to fix the crash reported here: http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
> And it has the upside to also consolidate a bit the arch do_softirq overriden implementation.

I tried this series on a ppc64 machine running KVM guests and doing
network traffic, while under memory pressure, and it seems to work
fine.  Although the original problem was never completely
deterministically reproducible, the problem did originally show up
with the combination of memory pressure, network traffic and KVM
guests.  I pushed the test machine moderately hard for a while and
there was no sign of stack overflow.  So:

Tested-by: Paul Mackerras <paulus@samba.org>

Are you going to push this upstream?

Thanks,
Paul.
