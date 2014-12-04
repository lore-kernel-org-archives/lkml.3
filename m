Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaLDMEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:04:35 -0500
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:46451 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753420AbaLDMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:04:33 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2911:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3874:4250:4425:5007:6261:7875:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dime18_61ac778cf732a
X-Filterd-Recvd-Size: 2040
Date: Thu, 4 Dec 2014 07:04:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH v2] ftracetests: Add test to test event filter logic
Message-ID: <20141204070429.71d8c2fd@gandalf.local.home>
In-Reply-To: <5480322D.1060302@hitachi.com>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
	<547ED753.3060508@hitachi.com>
	<20141203043423.6c7e4524@gandalf.local.home>
	<547F9939.7010207@hitachi.com>
	<20141203221858.3478e360@gandalf.local.home>
	<5480322D.1060302@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2014 19:06:37 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi Steven,
> 
> I have just one comment.
> 
> (2014/12/04 12:18), Steven Rostedt wrote:
> > +# Test more complex compares (&& and !!)
> > +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" ''
> > +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" ''
> > +
> > +test_cmp2 -ne 0 -a -gt 10 "!= 0" "> 10" "&&" '!'
> > +test_cmp2 -ne 0 -o -gt 10 "!= 0" "> 10" "||" '!'
> 
> These are not fixed :(

Oops, forgot about this. I was so focused on the dash commands I forgot
about the easy stuff.

> 
> > +    filter1=$6
> > +    filter2=$7
> > +    fconj=$8
> 
> are better to be
> 
> > +    filter1=$6
> > +    fconj=$7
> > +    filter2=$8
> 
> so that we can easily review parameters.
> 
> Others are OK for me.
> 

Yep, I'll make a v3 soon.

-- Steve

