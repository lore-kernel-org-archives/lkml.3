Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaI3TJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:09:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:46264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaI3TJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:09:02 -0400
Date: Tue, 30 Sep 2014 21:08:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        umgwanakikbuti@gmail.com, akpm@linux-foundation.org, srao@redhat.com,
        lwoodman@redhat.com, atheurer@redhat.com, oleg@redhat.com,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched, time: fix build error with 64 bit cputime_t on 32
 bit systems
Message-ID: <20140930190859.GO4241@worktop.programming.kicks-ass.net>
References: <2547036.UshV4pXvhf@wuerfel>
 <20140930134011.232bc7bf@annuminas.surriel.com>
 <20140930190611.GA5702@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930190611.GA5702@lerouge>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 09:06:13PM +0200, Frederic Weisbecker wrote:
> Maybe cmpxchg() should itself be a wrapper that does this build time choice
> between cmpxchg32() and cmpxchg64().
> 
> And if it looks too dangerous to convert all users, this could be cmpxchg_t().

It cannot, not all 32bit archs can do a 64bit cmpxchg.
