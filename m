Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaFWK6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:58:31 -0400
Received: from relay.parallels.com ([195.214.232.42]:51178 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFWK6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:58:30 -0400
Message-ID: <1403521103.3462.13.camel@tkhai>
Subject: Re: [PATCH 1/3] sched/fair: Disable runtime_enabled on dying rq
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Date: Mon, 23 Jun 2014 14:58:23 +0400
In-Reply-To: <20140623100724.GU19860@laptop.programming.kicks-ass.net>
References: <20140617130442.29933.54945.stgit@tkhai>
	 <1403011450.27674.44.camel@tkhai>
	 <20140623100724.GU19860@laptop.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 23/06/2014 в 12:07 +0200, Peter Zijlstra пишет:
> On Tue, Jun 17, 2014 at 05:24:10PM +0400, Kirill Tkhai wrote:
> > @@ -3790,6 +3803,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
> >  		cfs_rq->runtime_remaining = 1;
> >  		if (cfs_rq_throttled(cfs_rq))
> >  			unthrottle_cfs_rq(cfs_rq);
> > +
> > +		/*
> > +		 * Offline rq is schedulable till cpu is completely disabled
> > +		 * in take_cpu_down(), so we prevent new cfs throttling here.
> > +		 */
> > +		cfs_rq->runtime_enabled = 0;
> 
> Does it make sense to clear this before calling unthrottle_cfs_rq()?
> Just to make sure they're in the right order..

This looks good for me. I'll test and resend.

> 
> >  	}
> >  }


