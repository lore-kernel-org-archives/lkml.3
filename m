Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbaJ3A0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:26:07 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:60168 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756750AbaJ3A0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:26:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2731:2828:2914:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4384:5007:6261:8660:10004:10400:10848:10967:11026:11232:11658:11914:12114:12296:12517:12519:12663:12740:13069:13148:13230:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sea09_6f134af004c3d
X-Filterd-Recvd-Size: 2696
Message-ID: <1414628761.2542.7.camel@perches.com>
Subject: Re: [RFA][PATCH 1/8] seq_file: Rename seq_overflow() to
 seq_has_overflowed() and make public
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 29 Oct 2014 17:26:01 -0700
In-Reply-To: <20141029201048.698eb701@gandalf.local.home>
References: <20141029215602.535533597@goodmis.org>
	 <20141029220107.333126455@goodmis.org>
	 <1414620516.2542.3.camel@perches.com>
	 <20141029194215.44e86ffb@gandalf.local.home>
	 <1414626810.2542.5.camel@perches.com>
	 <20141029201048.698eb701@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 20:10 -0400, Steven Rostedt wrote:
> On Wed, 29 Oct 2014 16:53:30 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Wed, 2014-10-29 at 19:42 -0400, Steven Rostedt wrote:
> > > On Wed, 29 Oct 2014 15:08:36 -0700 Joe Perches <joe@perches.com> wrote:
> > > > On Wed, 2014-10-29 at 17:56 -0400, Steven Rostedt wrote:
> > > > > +A true return from seq_has_overflowed means that the seq_file buffer is full
> > > > > +and further output will be discarded.
> > > > Perhaps the description is a bit unclear here.
> > > > Doesn't a return of true to seq_has_overflowed mean that
> > > > more characters have already been written than the buffer
> > > > can accept?
> > > Actually, right now the comment is correct and the name is misleading.
> > > But I have a patch that will make the comment incorrect (and will be
> > > fixed) and the name correct.
> > > 
> > > But since seq_has_overflowed() is to be used throughout the kernel, I
> > > didn't want to have to go do patches all over again for a temporary
> > > misnomer.
> > 
> > I think it'd be better if the first submission
> > of the function has the correct operation for
> > the name.
> 
> I'm hoping that both of these will make it into 3.19, so it really
> doesn't matter the order. I'm working on this patch first, because, as
> you said earlier, it is important to get the call to
> seq_has_overflowed() out there.

So, given the necessary sequence of adding this new
function before any other change is made, please make
this function correct at the get-go.


