Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965198AbaLMFsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 00:48:35 -0500
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:34235 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965106AbaLMFse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 00:48:34 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2892:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4605:5007:6119:6120:6261:6742:7875:7903:10004:10400:10848:10967:11232:11658:11914:12050:12052:12296:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: care18_679a9d9bd8a2a
X-Filterd-Recvd-Size: 2978
Date: Sat, 13 Dec 2014 00:48:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 0/2] tracing: The Grinch who stole the stealing of
 Christmas
Message-ID: <20141213004830.792da019@gandalf.local.home>
In-Reply-To: <20141212181420.47100d5c@gandalf.local.home>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
	<20141212181420.47100d5c@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014 18:14:20 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 12 Dec 2014 21:35:14 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > We're almost there with x86 but my gut feeling tells me that pushing
> > it now is too risky. I rather prefer quiet holidays for all of us than
> > the nagging fear that the post holiday inbox will be full of obscure
> > bug reports and we then start a chase and bandaid race which will kill
> > the well earned recreation in an instant.
> 
> 
> > 
> >       Though one issue with that is, that for the early boot process
> >       there is no way to store that information as the tracer gets
> >       enabled way after init_IRQ(). But there is no reason why the
> >       tracer could not be enabled before that. All it needs is a
> >       working memory allocator. Steven?
> > 
> >       Now there is another class of problems which might be hard to
> >       debug. When the machine just boots into a hang, so we dont get a
> >       ftrace output neither from an oops nor from a console. It would
> >       be nice if we could have a command line option which prints
> >       enabled trace points via (early_)printk. That would avoid
> >       sending out ad hoc printk debug patches which will basically
> >       provide the same information as the trace_points. That would be
> >       useful for other hard to debug boot hangs as well. Steven?
> 
> Sure sure, everyone gets a nice calm xmas except for poor Steven who
> has to hack on early tracepoints such that this will be ready for 3.20!
> 
> -- Steve (The Grinch who Hacked on Christmas)

I guess I can enjoy my Holiday.

-- Steve
