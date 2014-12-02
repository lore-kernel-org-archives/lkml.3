Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaLBClJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 21:41:09 -0500
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:49873 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204AbaLBClH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 21:41:07 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:5007:6261:7875:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357:13618:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hate45_99ab37b5264f
X-Filterd-Recvd-Size: 2213
Date: Mon, 1 Dec 2014 21:41:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
Message-ID: <20141201214104.32d3f10d@gandalf.local.home>
In-Reply-To: <20141202021912.GA29096@thunk.org>
References: <20141202021912.GA29096@thunk.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 21:19:12 -0500
Theodore Ts'o <tytso@mit.edu> wrote:

> I was trying to do something like this:
> 
> filter="events/writeback/writeback_mark_inode_dirty/filter"
> echo "(flags & 2048) && ((state & 2048) == 0)" > $filter
> 
> ... but that doesn't work.
> 
> This works:
> 
> echo "flags & 2048" > $filter
> 
> But the problem is this:
> 
> echo "(state & 2048) == 0" > $filter
> 
> The simplest patch to add this would be add a new filter_ops so we
> could do this:
> 
> echo "(state !& 2048)" > $filter
> 
> ... but that's pretty ugly.  But adding more general expression
> parsing in the ftrace event filter code would be non-trivial, and if
> we start trying to make things like "!(state & 2048)" or "(state &
> 2048) == 0", then at some point some crazy person might request
> supporting something like this: "(state ^ flags) == 2048".  :-)
> 
> So I guess the main question I want to ask is your opinion about
> whether a patch that adds support for the operator "!&" is too ugly to
> live?
> 

Yeah, I don't want to add some bastardization compare that we'll be
stuck with till the end of time. Either we modify the tree walk to
handle values (it shouldn't be too difficult, but it wont be trivial),
or we wait till eBPF is up and running as the trace filter replacement
and that should be able to handle this much better.

-- Steve
