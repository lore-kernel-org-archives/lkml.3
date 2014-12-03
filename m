Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaLCIkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:40:45 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:35235 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751675AbaLCIko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:40:44 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3871:3872:3873:5007:6261:7576:7875:7903:9040:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: class66_6423654ad12e
X-Filterd-Recvd-Size: 2930
Date: Wed, 3 Dec 2014 03:40:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
Message-ID: <20141203034033.19a30e2f@gandalf.local.home>
In-Reply-To: <CAMEtUuyzfKYVSJUra6nib-wWYQ91uEPC6mizF9PLpg+5Kjb+3w@mail.gmail.com>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
	<CAMEtUuyzfKYVSJUra6nib-wWYQ91uEPC6mizF9PLpg+5Kjb+3w@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 22:22:16 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:

> On Tue, Dec 2, 2014 at 7:13 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> >
> > Add a test to test the event filter logic. It currently tests the
> > following filters against sched:sched_switch event.
> >
> >    ( prev_pid != 0 )
> >    ( prev_pid == 0 )
> >    ( prev_pid < 100 )
> >    ( prev_pid <= $$ )
> >    ( prev_pid > 100 )
> >    ( prev_pid >= $$ )
> >   ! ( prev_pid != 0 )
> >   ! ( prev_pid == 0 )
> >   ! ( prev_pid < 100 )
> >   ! ( prev_pid <= $$ )
> >   ! ( prev_pid > 100 )
> >   ! ( prev_pid >= $$ )
> >    ( prev_pid != 0 && next_pid > 10 )
> >    ( prev_pid != 0 || next_pid > 10 )
> >   ! ( prev_pid != 0 && next_pid > 10 )
> >   ! ( prev_pid != 0 || next_pid > 10 )
> >    ( prev_pid & 1 )
> >    ( prev_pid & 2 )
> >    ( prev_pid & 4 )
> >    ( prev_pid & 8 )
> >    ( prev_pid & 16 )
> >   ! ( prev_pid & 1 )
> >   ! ( prev_pid & 2 )
> >   ! ( prev_pid & 4 )
> >   ! ( prev_pid & 8 )
> >   ! ( prev_pid & 16 )
> >    ( next_comm ~ "ftrace-test-fil" )
> >    ( next_comm != "ftrace-test-fil" )
> >   ! ( next_comm ~ "ftrace-test-fil" )
> >   ! ( next_comm != "ftrace-test-fil" )
> 
> thanks for the tests!
> Since you're adding full support for 'not',
> I think would be good to have few more tests
> where ! is not a top node. Like:
> (prev_pid != 0 && !(next_pid & 2))
> and another one with ! at multiple levels, like:
> (prev_pid != 0 && !(next_pid != 2 && !(prev_pid > 3)))
> ... or reject them during parsing.

Sure, would you like to add them :-)

I spent more time on this than I should have. I have other things to
work on and this little project has already put me behind on my other
tasks.

-- Steve
