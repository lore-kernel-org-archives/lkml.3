Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaEUBQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:16:01 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:34513 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaEUBQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:16:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:701:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:4321:4433:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCa
X-HE-Tag: gate93_8b3d22db44d4d
X-Filterd-Recvd-Size: 2236
Message-ID: <1400634953.26709.42.camel@joe-AO725>
Subject: Re: [PATCH] sched: Reduce the rate of needless idle load balancing
From: Joe Perches <joe@perches.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Russ Anderson <rja@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 May 2014 18:15:53 -0700
In-Reply-To: <1400619878.2970.276.camel@schen9-DESK>
References: <1400617046.2970.270.camel@schen9-DESK>
	 <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
	 <1400619550.2970.274.camel@schen9-DESK>
	 <1400619878.2970.276.camel@schen9-DESK>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 14:04 -0700, Tim Chen wrote:
> On Tue, 2014-05-20 at 13:59 -0700, Tim Chen wrote:
> > On Tue, 2014-05-20 at 13:51 -0700, Jason Low wrote:
> > > On Tue, May 20, 2014 at 1:17 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> > > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
[]
> > > If we want to do idle load balancing only when it is due for a
> > > balance, shouldn't the above just be "if (time_after(jiffies,
> > > rq->next_balance))"?
> > 
> > If rq->next_balance and jiffies are equal, then
> > time_after(jiffies, rq->next_balance) check will be false and
> > you will not do balance.  But actually you want to balance
> > for this case so the jiffies+1 was used.
> 
> So maybe I should switch the check to 
> if (time_before(rq->next_balance, jiffies))

time_after_eq() or time_is_after_eq_jiffies()


