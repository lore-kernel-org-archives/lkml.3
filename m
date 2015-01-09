Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbbAIQZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:25:12 -0500
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:37881 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659AbbAIQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:25:11 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2892:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:5007:6119:6248:6261:7514:7774:7875:7903:8829:10004:10400:10848:10967:11232:11639:11658:11914:12043:12517:12519:12663:12740:13069:13161:13229:13311:13357:13618:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nail57_66d3facf40616
X-Filterd-Recvd-Size: 2256
Date: Fri, 9 Jan 2015 11:25:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Shinde <v.bhav.shinde@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: Preemptionirqsoff latency issue
Message-ID: <20150109112505.4ed9de41@gandalf.local.home>
In-Reply-To: <CAB5gotu75cXeHKhn-GShOTKW7=2bVdYfeUpxM7kCSTRWRsC79Q@mail.gmail.com>
References: <CAB5gottA3D_eJsHcGwO62fJtEqMqivX2kS5D-JhHphW9ADV88A@mail.gmail.com>
	<20150109095603.GB22386@worktop.programming.kicks-ass.net>
	<CAB5gotu75cXeHKhn-GShOTKW7=2bVdYfeUpxM7kCSTRWRsC79Q@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 20:19:51 +0530
Vaibhav Shinde <v.bhav.shinde@gmail.com> wrote:

> Hi Peter,
> 
> Thanks for you reply.
> 
> I am interested in scheduling latency, and using ftrace I see for my
> application suffering from it, that's why I am digging in preemption/irq
> disable time which might cause the latency.
> 
> My app runs on cpu0, while other cpus looks idle; as per my understanding
> from your comment owner of the mutex is on the cpu other than cpu0, and
> which is causing wait spin on cpu0.
> Can this be the reason why latency is caused ?
> If so, then I think I need to take care of the mutex lock which is called
> from my code.
> 

If you download and install the latest trace-cmd, you may be able to
get more information with its new command "profile".

 # trace-cmd profile -o  file  workload

Then look at the output in file.

To limit the running to tracing only the workload:

 # trace-cmd profile -o file -F -c workload

You'll need to use the latest that's in my repo. Use the master branch,
as it has all the above features.

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

-- Steve
