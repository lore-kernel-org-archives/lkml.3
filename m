Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbbANRFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:05:44 -0500
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:56175 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752542AbbANRFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:05:43 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3167:3352:3622:3865:3867:3868:3871:3872:3874:4250:5007:6119:6261:7875:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: walk88_142b169791d60
X-Filterd-Recvd-Size: 2149
Date: Wed, 14 Jan 2015 12:05:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, vvs@sw.ru,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86-ml <x86@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] ftrace/jprobes/x86: Fix conflict between jprobes
 and function graph tracing
Message-ID: <20150114120536.4cccc3a9@gandalf.local.home>
In-Reply-To: <20150114165537.GB6902@pd.tnic>
References: <20150114153958.931152836@goodmis.org>
	<20150114154329.552437962@goodmis.org>
	<20150114165537.GB6902@pd.tnic>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 17:55:37 +0100
Borislav Petkov <bp@alien8.de> wrote:

 
> Err, stupid question: marking the jprobe handler "notrace" doesn't help?
> 

A few reasons.

One, that would require all users to make their handler as "notrace".
That's not very reliable. Not to mention, I still work at Red Hat and
we have this KABI thingy, where the jprobe modules don't need to change
and we still need to fix it.

This change is much more robust that expecting jprobe callers to add
notrace.

Two, I HATE when a notrace is added for function graph tracing that
is not needed for function tracing. As I told Masami, every "notrace"
added to the kernel makes function tracing that much more useless.

Function tracing should be allowed to debug jprobes.

Three, I have a patch that lets this all work if the kprobe/jprobes
uses the ftrace fentry infrastructure (the work I original did). Why
break everything for something the requires jprobe users to do things
correctly?

-- Steve
