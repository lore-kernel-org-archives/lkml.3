Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbbA2OXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:23:02 -0500
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:42729 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753216AbbA2OXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:23:00 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2898:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:3874:5007:6119:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12294:12296:12517:12519:12740:13069:13311:13357:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: truck49_36e26c212b34d
X-Filterd-Recvd-Size: 1972
Date: Thu, 29 Jan 2015 09:22:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] scsi: Some seq_file cleanups/optimizations
Message-ID: <20150129092256.1c84193c@gandalf.local.home>
In-Reply-To: <87wq46aqvz.fsf@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
	<1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
	<alpine.LNX.2.00.1501291636140.7510@nippy.intranet>
	<87wq46aqvz.fsf@rasmusvillemoes.dk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2015 10:16:16 +0100
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Steven, you've been doing some cleanup in this area, among other things
> trying to make all the seq_* functions return void. Could you fill me in
> on the status of that?

Yes, the entire seq_*() operations are ambiguous in how they handle
filling the buffers. Don't worry about side effects of using one seq
operation over another (I highly doubt anyone will notice).

I had to stop doing the cleanups to work on other things, but I have
patches to make all seq operations perform the same (and also use the
new seq_buf infrastructure).

And, please ignore any return value from the seq operations. If you
want to know if the buffer is full use seq_has_overflowed() to find out.

I'll try to continue this clean up as a side project.

-- Steve

