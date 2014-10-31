Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaJaH6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:58:15 -0400
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:39380 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750797AbaJaH6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:58:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:4321:5007:6119:6261:7576:8531:8957:10004:10400:10848:11026:11473:11658:11914:12043:12114:12296:12438:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gate45_2a585a47ec726
X-Filterd-Recvd-Size: 3166
Message-ID: <1414742289.8928.5.camel@perches.com>
Subject: Re: [RFC] arm:remove clear_thread_flag(TIF_UPROBE)
From: Joe Perches <joe@perches.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Oct 2014 00:58:09 -0700
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D1827C@CNBJMBX05.corpusers.net>
References: <1414392371.8884.2.camel@perches.com>
	 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
	 <20141030120127.GC32589@arm.com>
	 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
	 <20141030135749.GE32589@arm.com>
	 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D1827B@CNBJMBX05.corpusers.net>
	 <1414741535.8928.2.camel@perches.com>
	 <35FD53F367049845BC99AC72306C23D103E010D1827C@CNBJMBX05.corpusers.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 15:51 +0800, Wang, Yalin wrote:
> > From: Joe Perches [mailto:joe@perches.com]
> > > diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> > []
> > > @@ -591,10 +591,9 @@ do_work_pending(struct pt_regs *regs, unsigned int
> > thread_flags, int syscall)
> > >  					return restart;
> > >  				}
> > >  				syscall = 0;
> > > -			} else if (thread_flags & _TIF_UPROBE) {
> > > -				clear_thread_flag(TIF_UPROBE);
> > > +			} else if (thread_flags & _TIF_UPROBE)
> > >  				uprobe_notify_resume(regs);
> > > -			} else {
> > > +			else {
> > >  				clear_thread_flag(TIF_NOTIFY_RESUME);
> > >  				tracehook_notify_resume(regs);
> > >  			}
> > 
> > Please keep the braces.
> 
> mm..  could I know the reason ?  :)

Try read Documentation/CodingStyle

		Chapter 3: Placing Braces and Spaces

use braces in both branches:

if (condition) {
	do_this();
	do_that();
} else {
	otherwise();
}


