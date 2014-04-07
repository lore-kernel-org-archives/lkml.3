Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaDGLTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:19:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42876 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaDGLTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:19:18 -0400
Date: Mon, 7 Apr 2014 13:19:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, tglx@linutronix.de, ben@decadent.org.uk,
        mkl@pengutronix.de, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: sched: dev_deactivate_many(): use msleep(1) instead
 of yield() to wait for outstanding qdisc_run callsb
Message-ID: <20140407111906.GH11096@twins.programming.kicks-ass.net>
References: <20140402110743.GG27965@twins.programming.kicks-ass.net>
 <1396437459.3989.39.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140404151942.GI10526@twins.programming.kicks-ass.net>
 <20140404.112628.1273328398538574058.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404.112628.1273328398538574058.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 11:26:28AM -0400, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 4 Apr 2014 17:19:42 +0200
> 
> > The proper way to fix the dev_deactivate_many() is to use wait_event(),
> > polling for that state is just daft. Afaict there is no reason the qdisc
> > code could not do a wakeup whenever that condition changes.
> 
> I actually looked into this, and it's going to add expensive checks
> to the fast paths of packet processing.
> 
> If it was so easy we'd be doing it that way already.

Fair enough; and I suppose this waiting side is 'rare' compared to the
packet processing side of things?

In that case you could add a comment with the msleep() and just leave it
at that I suppose.
