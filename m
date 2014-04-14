Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaDNDSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 23:18:06 -0400
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:45945 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750850AbaDNDSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 23:18:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13180:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy07_462bd0ab1d120
X-Filterd-Recvd-Size: 1784
Message-ID: <1397445480.5243.6.camel@joe-AO722>
Subject: Re: [PATCH 1/1] kernel/rcu/tree.c: remove duplicate extern
 definition
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2014 20:18:00 -0700
In-Reply-To: <CAJhHMCBsa6ypbaLZ2Uv6x60uU-xq=veAem85Ke=-R+nbW5=5fA@mail.gmail.com>
References: <CAJhHMCCE0QHvzqrdY-w8bB8ZK=JRN02V29XwaFYRXmu=9RhG9Q@mail.gmail.com>
	 <CAJhHMCCgMgL2etE8sYPgUfy+OXcyxG6_X1v1OhUxzX5c0kaZ4w@mail.gmail.com>
	 <1397443846.5243.2.camel@joe-AO722>
	 <CAJhHMCBsa6ypbaLZ2Uv6x60uU-xq=veAem85Ke=-R+nbW5=5fA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-13 at 23:03 -0400, Pranith Kumar wrote:
> On Sun, Apr 13, 2014 at 10:50 PM, Joe Perches <joe@perches.com> wrote:
> >> -/*
> >> - * This function really isn't for public consumption, but RCU is special in
> >> - * that context switches can allow the state machine to make progress.
> >> - */
> >> -extern void resched_cpu(int cpu);
> >
> > why not #include "sched.h"
> > and remove both declarations?
> As the comment mentions, resched_cpu is internal to the scheduler and
> hence is in sched/sched.h file and not in linux/sched.h.

Note the use of quotes and lack of angle brackets.

> sched/sched.h cannot be included in other subsystems directly.

If functions from it can be declared extern,
then likely it could be used in an #include.


