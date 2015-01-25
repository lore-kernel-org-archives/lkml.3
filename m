Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbbAYTif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:38:35 -0500
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:46094 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754348AbbAYTid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:38:33 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2892:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11473:11658:11914:12438:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grade75_678f0145f1f05
X-Filterd-Recvd-Size: 2029
Date: Sun, 25 Jan 2015 14:38:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5 v2] tracing: Automatically mount tracefs on
 debugfs/tracing
Message-ID: <20150125143830.760c448a@gandalf.local.home>
In-Reply-To: <20150125132206.GA16249@kroah.com>
References: <20150123155525.795129339@goodmis.org>
	<20150123162414.580817092@goodmis.org>
	<20150124030041.GB5009@kroah.com>
	<20150124063330.2c986ea2@grimm.local.home>
	<20150125132206.GA16249@kroah.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015 21:22:07 +0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:


> If we could do it in a non-racy way, that would be good, otherwise I
> don't see us being able to even take this patch :(

Is it still racy even if it's only done at boot up? This path only gets
hit the first time it is called. "if (tr->flags &TRACE_ARRAY_FL_GLOBAL)"
is the top level tracing directory ("tracing") and is only called
during boot up (fs_initcall) and never hit again. I could even make
this called directly by that code so we could label it "__init" to make
sure that it is to be never hit. Or is this racy even when done by
fs_initcall?

Waiting for Al to comment on this, because, I can't add this feature
until debugfs/tracing still containing the tracing information,
otherwise it will break all the tools that interact with the tracing
infrastructure, and we all know how happy Linus feels about such
changes.

-- Steve
