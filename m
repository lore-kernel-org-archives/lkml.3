Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaLCX3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:29:24 -0500
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:38183 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751110AbaLCX3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:29:22 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2895:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3872:3873:3874:5007:6261:6690:7875:7903:7904:8531:9036:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:14096:14097:21060:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wine79_34827b2d8c211
X-Filterd-Recvd-Size: 2403
Date: Wed, 3 Dec 2014 18:29:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
Message-ID: <20141203182911.1d4a8f8e@gandalf.local.home>
In-Reply-To: <547F9939.7010207@hitachi.com>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
	<547ED753.3060508@hitachi.com>
	<20141203043423.6c7e4524@gandalf.local.home>
	<547F9939.7010207@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2014 08:14:01 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> >> to allow run this on busybox or dash, we'd better clean it.
> > 
> > Do you know how to fix this?
> 
> Yes, it's easy :).
> As the tool output, [ a == b ] can be changed to [ a = b ],
> and "let ..." can be changed to "$((...))"

OK, thanks.

> 
> > 
> >>
> >>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >>> ---
> >> [...]
> >>> +# Test more complex compares (&& and !!)
> >>> +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" ''
> >>> +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" ''
> >>
> >> This might better be
> >> test_cmp2 -ne 0 -a -gt 10 "!= 0" "&&" "> 10" ''
> >> test_cmp2 -ne 0 -o -gt 10 "!= 0" "||" "> 10" ''
> >>
> >> :-)
> > 
> > Sure.
> > 
> > OK, I'll hold off on sending this patch then till 3.20.
> 
> OK.
> 
> > 
> > I'll still add the update to the kernel for 3.19, but the testing for
> > it needs work. It passes my test suite, but I don't know how to handle
> > the busybox limitations.
> 
> If you are using Fedora, it provides dash and busybox packages too.

Yep, and so does Debian. In fact, I notice that my Debian boxes all
have /bin/sh linked to dash not bash (which means they were not as
susceptible to the bash bug).

-- Steve
