Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbbAMMWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:22:36 -0500
Received: from smtprelay0063.hostedemail.com ([216.40.44.63]:43501 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751637AbbAMMWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:22:35 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4362:4470:5007:6119:6261:7875:7903:8531:10004:10400:10848:10967:11232:11658:11914:12043:12050:12296:12517:12519:12740:13069:13161:13229:13311:13357:13972:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fly99_6daee5a452424
X-Filterd-Recvd-Size: 2005
Date: Tue, 13 Jan 2015 07:22:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, vvs@sw.ru
Subject: Re: Bug with jprobes and function graph tracer
Message-ID: <20150113072232.451c599b@gandalf.local.home>
In-Reply-To: <54B503F5.4020509@hitachi.com>
References: <20150108122016.0241f713@gandalf.local.home>
	<54B503F5.4020509@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 20:39:33 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> 
> Yeah we should try to fix this, but not so high priority since jprobe
> is not used so frequently. I guess one easy solution is adding notrace
> to all jprobe handlers for hiding it from function-graph tracer.
> If there is a way to check a function is notrace or not, I can use that
> in register_jprobe and reject it if the handler is not "notrace"ed. :)

Adding notrace should be the last resort. Every notrace in the kernel
makes function tracing a little more useless. It bothers me even more
when notrace is added because of function graph tracing but the
function still works for function tracing.

I worked on this for the last few days and have a patch that fixes the
problem. I'll be posting it later today. It also uncovered another
unrelated bug that I worked on yesterday, otherwise I would have posted
these fixes already.

I have a fix for the other bug now but it needs to be cleaned up
(remove all the debugging prints from it). When that's complete I'll
post the patches and get them ready for mainline and stable.

Thanks,

-- Steve
