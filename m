Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbbA2NsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:48:09 -0500
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:38792 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752455AbbA2NsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:48:06 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1183:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2736:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3873:3874:4362:5007:6261:7875:8660:9040:9108:10004:10400:10848:10967:11026:11232:11658:11914:12043:12295:12438:12517:12519:12740:13069:13148:13149:13230:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: books85_29452c61cc510
X-Filterd-Recvd-Size: 2168
Date: Thu, 29 Jan 2015 08:48:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 0/3] kprobes/ftrace/x86: Function graph trace
 jprobes
Message-ID: <20150129084802.77431788@gandalf.local.home>
In-Reply-To: <54C9CD7C.3030402@hitachi.com>
References: <20150128043036.429390502@goodmis.org>
	<54C9CD7C.3030402@hitachi.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2015 15:04:44 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
 
> Hmm, could you make this more generic? Maybe we can directly call
> ftrace_return_to_handler() from longjmp_break_handler().

I tried that, but because the longjump handlers can also be traced (and
I still want them to be :-) It makes things even more complicated to
get the stacks right. It's best to deal with the stack when you can.

> Actually, current implementation seems just skipping one return
> address, however, there may be possible to call jprobe_return() in
> the nested functions, like below;
> 
> void test_exit(int flag)
> {
> 	if (!flag)
> 		jprobe_return();
> }
> int jdo_fork(...)
> {
> 	...
> 	test_exit(something_to_test);
> 	...
> 	jprobe_return();
> 	return 0;
> }
> 
> I've tested similar code on this series and it crashed kernel.
> (I also checked that the above example can work safely without graph tracer)
> 

Ah yes, I missed this. I have a way to solve this but it's not going to
get done before the merge window. Thanks for the test case. I'll use
this and more complicated ones for future changes.

Thanks!

-- Steve

