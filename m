Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaEUS03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:26:29 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:21762 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaEUS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:26:27 -0400
Message-ID: <1400696776.2646.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] sched: Reduce the rate of needless idle load balancing
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Joe Perches <joe@perches.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Russ Anderson <rja@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 21 May 2014 11:26:16 -0700
In-Reply-To: <1400690267.2970.287.camel@schen9-DESK>
References: <1400617046.2970.270.camel@schen9-DESK>
	 <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
	 <1400619550.2970.274.camel@schen9-DESK>
	 <1400619878.2970.276.camel@schen9-DESK>
	 <1400634953.26709.42.camel@joe-AO725>
	 <1400690267.2970.287.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 09:37 -0700, Tim Chen wrote:
> On Tue, 2014-05-20 at 18:15 -0700, Joe Perches wrote:
> > On Tue, 2014-05-20 at 14:04 -0700, Tim Chen wrote:
> > > On Tue, 2014-05-20 at 13:59 -0700, Tim Chen wrote:
> > > > On Tue, 2014-05-20 at 13:51 -0700, Jason Low wrote:
> > > > > On Tue, May 20, 2014 at 1:17 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> > > > > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > []
> > > > > If we want to do idle load balancing only when it is due for a
> > > > > balance, shouldn't the above just be "if (time_after(jiffies,
> > > > > rq->next_balance))"?
> > > > 
> > > > If rq->next_balance and jiffies are equal, then
> > > > time_after(jiffies, rq->next_balance) check will be false and
> > > > you will not do balance.  But actually you want to balance
> > > > for this case so the jiffies+1 was used.
> > > 
> > > So maybe I should switch the check to 
> > > if (time_before(rq->next_balance, jiffies))
> > 
> > time_after_eq() or time_is_after_eq_jiffies()
> > 
> > 
> 
> I prefer time_after_eq to keep the code style consistent with the
> rest of the code in fair.c.

Should all the code be updated then? We should use the existing
interfaces if available.

