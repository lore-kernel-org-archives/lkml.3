Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaKDOq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:46:27 -0500
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:34780 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754426AbaKDOqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:46:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:6261:7576:7809:8660:10004:10400:10848:10967:11026:11232:11658:11914:12517:12519:12740:13069:13148:13230:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cover91_377650357d114
X-Filterd-Recvd-Size: 2317
Message-ID: <1415112379.24560.6.camel@perches.com>
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Tue, 04 Nov 2014 06:46:19 -0800
In-Reply-To: <20141104093150.7410f6d0@gandalf.local.home>
References: <20141029215602.535533597@goodmis.org>
	 <20141029220107.465008329@goodmis.org>
	 <20141104080535.5f651713@gandalf.local.home>
	 <20141104142236.GA10239@salvia>
	 <20141104093150.7410f6d0@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 09:31 -0500, Steven Rostedt wrote:
> On Tue, 4 Nov 2014 15:22:36 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Nov 04, 2014 at 08:05:35AM -0500, Steven Rostedt wrote:
> > > On Wed, 29 Oct 2014 17:56:04 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > > [ REQUEST FOR ACKS ]
> > > Can any of the netfilter folks give me an Acked-by for this?
> > If Florian's concern were addressed, then:
> Yeah, the change he mentioned was done is 3/8. As that was written by
> Joe Perches, I did some work that he missed and put it before his
> patch, which showed a discrepancy between the two functions. After all
> patches are applied, it should be consistent to his liking.

I think seq_has_overflowed does not need
to be used after every seq_<put/print> call.

It interrupts reading code flow and just
isn't alll that necessary as every operation
before it will be redone anyway.

It should be used before or after a large
blocks though.


