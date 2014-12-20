Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaLTWH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:07:29 -0500
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:33727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751104AbaLTWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:07:27 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:7875:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crack36_23d5d8021fa25
X-Filterd-Recvd-Size: 1708
Date: Sat, 20 Dec 2014 17:07:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
Message-ID: <20141220170725.776363ac@gandalf.local.home>
In-Reply-To: <20141220204213.GA16705@amd>
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
	<20141220204213.GA16705@amd>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014 21:42:13 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Wed 2014-12-10 15:38:27, Michael Ellerman wrote:
> > usleep is a Fedoraism, it's not generally available on Debian based
> > systems AFAICS.
> > 
> > GNU sleep accepts a floating point argument, so use that instead.
> > 
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> 
> Could ftrace user interface be enhanced not to need random delays?
> 

Not sure what you are talking about. These "random delays" are not for
the interface, but instead to force some events to happen and to make
sure they did.

As the subject states, this is for "ftracetest" which is the selftests
for ftrace.

The usleep is basically a "do something to trigger events", and we
don't want to wait long in doing it.

-- Steve
