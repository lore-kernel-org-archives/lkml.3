Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbbAPQxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:53:09 -0500
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:58493 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754567AbbAPQxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:53:06 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:5007:6261:7875:8784:9040:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: elbow68_1ab90db5c3a0a
X-Filterd-Recvd-Size: 2840
Date: Fri, 16 Jan 2015 11:53:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] ftrace: don't allow IPMODIFY without proper
 compiler support
Message-ID: <20150116115302.0897b895@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.10.1501161737320.1074@wotan.suse.de>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
	<20141223094607.GA16445@infradead.org>
	<20141223151056.GA4789@treble.redhat.com>
	<20141226155613.36dd95b9@canb.auug.org.au>
	<20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
	<alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz>
	<20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org>
	<alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz>
	<20150107155701.4839545f63701412003edd88@linux-foundation.org>
	<alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz>
	<54B3C1DD.6090400@hitachi.com>
	<alpine.LNX.2.00.1501132345080.4162@pobox.suse.cz>
	<20150113211223.18908f21@grimm.local.home>
	<alpine.LNX.2.00.1501140945520.4162@pobox.suse.cz>
	<alpine.LNX.2.00.1501151045580.4162@pobox.suse.cz>
	<20150116113539.78c093ad@gandalf.local.home>
	<alpine.LNX.2.10.1501161737320.1074@wotan.suse.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 17:41:58 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 16 Jan 2015, Steven Rostedt wrote:
> 
> > Instead, make live kernel patching fail to load if fentry isn't 
> > supported. IOW, instead of ftrace_ipmodify_supported, have a 
> > live_kernel_patching_supported that could be based on fentry being used 
> > or not.
> 
> I can live with that, we are handling non-fentry case ourselves already.
> 
> You expressed that you would accept such patch for ftrace in a past, so I 

Right, but then I thought about it more :-)

I had a lot of time thinking about things like this while debugging
the dance between function graph and jprobes.

> thought I'll move it out from livepatching to ftrace. But if you don't 
> want it now, that's not a big issue, and handling the possible fallout 
> stays the responsibility of ftrace_ops "owner".
> 

Exactly!

-- Steve

