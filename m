Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943AbaLBTys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:54:48 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:41775 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932806AbaLBTyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:54:45 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2693:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4362:4425:4605:5007:6261:7875:8531:9149:10004:10400:10848:10967:11026:11232:11473:11658:11914:12438:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brass85_a17f23117348
X-Filterd-Recvd-Size: 2119
Date: Tue, 2 Dec 2014 14:54:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] tracing: Add NOT to filtering logic
Message-ID: <20141202145420.279e4de6@gandalf.local.home>
In-Reply-To: <CAMEtUuwejSGZSMyncPo9GRvy7vnC8Wam-dOdHU+iO0cJkRDeTg@mail.gmail.com>
References: <20141202120430.71979060@gandalf.local.home>
	<CAMEtUuwejSGZSMyncPo9GRvy7vnC8Wam-dOdHU+iO0cJkRDeTg@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 11:49:58 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:

> On Tue, Dec 2, 2014 at 9:04 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >                                                                         \
> > -       return match;                                                   \
> > +       return match == !pred->not;                                     \
> 
> are you sure this one works for !(var & 2) ?
> 'not' is either 0 or 1, so it works for other macro:
> (val == *addr) ^ pred->not
> 
> whereas here 'match' is 'int' and
> match = (*addr & val)
> will not be 0 or 1...
> 
> the patch is small, but delicate...

Yeah, there's some more I'm fixing up on it. I only did some basic
tests. I should have tested '& 2' instead of '& 1' ;-)

I'll make that check: return !!match == !pred->not.


> In such cases I trust tests more than code review ;)
> Could you add few tests for this to
> CONFIG_FTRACE_STARTUP_TEST
> part of the file ?

No, but I will be adding tests to the ftracetests in
tools/testing/selftests to test the filters.

Thanks,

-- Steve
