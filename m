Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbbANNtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:49:36 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:34134 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751187AbbANNtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:49:35 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4470:5007:6261:7875:7903:8531:9040:10004:10400:10848:10967:11232:11658:11914:12043:12050:12294:12517:12519:12740:13069:13149:13161:13229:13230:13311:13357:13618:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: silk35_3622f889afc08
X-Filterd-Recvd-Size: 2097
Date: Wed, 14 Jan 2015 08:49:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, vvs@sw.ru
Subject: Re: Bug with jprobes and function graph tracer
Message-ID: <20150114084930.06e9daf1@gandalf.local.home>
In-Reply-To: <54B513A9.8070004@hitachi.com>
References: <20150108122016.0241f713@gandalf.local.home>
	<54B503F5.4020509@hitachi.com>
	<20150113072232.451c599b@gandalf.local.home>
	<54B513A9.8070004@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 21:46:33 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> > 
> > I worked on this for the last few days and have a patch that fixes the
> > problem. I'll be posting it later today. It also uncovered another
> > unrelated bug that I worked on yesterday, otherwise I would have posted
> > these fixes already.
> 
> Great! I look forward that! :)

I was all set to send the patches but during testing found that this
isn't just affected by the fentry code, but also happens when jprobes
and kprobes uses the breakpoint method (old mcount and i386).

I guess this has always been broken from when jprobes and function
graph tracing were together.

Anyway, I think I have a simpler solution which simulates making the
jprobes "notrace". At least this solution will allow us to have jprobe
callbacks traced in the future. But for now, instead of crashing, we'll
just disable function graph tracing while its in a jprobe.

I'll see if I can get that patch working today (I should stop saying
that).

But all is not lost. I found two bugs in the current implementation of
the function graph tracer because of this :-)

-- Steve
