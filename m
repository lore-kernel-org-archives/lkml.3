Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaENRVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbaENRV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:21:28 -0400
Date: Wed, 14 May 2014 13:20:43 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140514172043.GA31281@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
 <20140514163535.GS30445@twins.programming.kicks-ass.net>
 <53739BF2.1030100@oracle.com>
 <20140514165205.GU30445@twins.programming.kicks-ass.net>
 <5373A34B.1010008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5373A34B.1010008@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:09:31PM -0400, Sasha Levin wrote:
 
 > > *** Error in `./trinity': double free or corruption (top): 0x000000000135af60 ***
 > > [main] Random reseed: 3671679404
 > > [main] Random reseed: 67838733
 > > *** Error in `./trinity': double free or corruption (top): 0x000000000135ef60 ***
 > > [main] Random reseed: 943044433
 > > *** Error in `./trinity': double free or corruption (top): 0x00000000012bb210 ***
 > > [main] Random reseed: 3627649145
 > > *** Error in `./trinity': double free or corruption (top): 0x000000000139dbe0 ***
 > > [main] Random reseed: 935036390
 > > [main] Random reseed: 3922349807
 > > [main] Random reseed: 835563887
 > > *** Error in `./trinity': double free or corruption (top): 0x0000000001323890 ***
 > > [main] Random reseed: 974945617
 > > *** Error in `./trinity': double free or corruption (top): 0x0000000001308190 ***
 > > [main] Random reseed: 2912296953
 > > [main] Random reseed: 681900861
 > > 
 > > Is this 'expected' behaviour?
 > 
 > I've talked about it with Dave a while ago, he said it happens because the threads that
 > do all the testing sometimes corrupt themselves which result in that error. It shouldn't
 > be harmful as the thread will just get killed and a fresh one will be started in it's
 > place.
 > 
 > Since then I set MALLOC_CHECK_=0 to avoid seeing that in my logs.
 
Pretty strong odds it's mremap causing those double frees.  You can
-xmremap that to see if it goes away.

	Dave

