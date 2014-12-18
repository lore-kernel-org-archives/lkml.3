Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaLRQ13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:27:29 -0500
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:58590 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751616AbaLRQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:27:27 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4385:5007:6119:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12517:12519:12663:12740:13069:13311:13357:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crow73_6a83563aae46
X-Filterd-Recvd-Size: 2645
Date: Thu, 18 Dec 2014 11:27:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address
 formats
Message-ID: <20141218112715.42420caf@gandalf.local.home>
In-Reply-To: <20141218155255.GF3150@kernel.org>
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com>
	<20141218155255.GF3150@kernel.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014 12:52:55 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Thu, Dec 18, 2014 at 08:10:43AM -0700, David Ahern escreveu:
> > Adds helper for following kernel formats:
> >   %pi4 print an IPv4 address with leading zeros
> >   %pI4 print an IPv4 address without leading zeros
> >   %pi6 print an IPv6 address without colons
> >   %pI6 print an IPv6 address with colons
> >   %pI6c print an IPv6 address with colons
> >   %pISpc print an IP address from a sockaddr
> > 
> > Allows these formats to be used in tracepoints.
> > 
> > Quite a bit of this is adapted from code in lib/vsprintf.c.
> 
> Can't we try as much as possible use that code directly? Something like

Until we have a true shared library, please no. I'm still taking code
from here and adding it manually to trace-cmd. And also sending patches
to here from what I add to trace-cmd.

I do not want this directly linked to the kernel code. Note, the kernel
internals have no guaranteed API, where this does.


> we do for lib/rbtree.c in tools/perf/, or like I did recently with
> tools/lib/util/find_next_bit.c, i.e. retain at least this kind of
> sharing:
> 
> diff -u tools/lib/util/find_next_bit.c  lib/find_next_bit.c

Unless we convert code to trace_seq, I don't think this works. My
patches to move seq_buf.c int lib/ have made it into the kernel.
Perhaps we can copy the seq_buf.c code into tools/lib/traceevent, but
that would take some work.

-- Steve

> 
> Should show that only bits that we have not a need at the moment in
> tools/ were left behind.
> 
> We want to either get fixes for free by directly reusing or notice it
> easily, using diff.
> 
