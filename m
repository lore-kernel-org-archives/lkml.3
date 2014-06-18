Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaFRWJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:09:17 -0400
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:37264 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754218AbaFRWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:09:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13018:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brick51_331b9457c561b
X-Filterd-Recvd-Size: 1804
Message-ID: <1403129350.14018.1.camel@joe-AO725>
Subject: Re: [PATCH] floppy: Neaten message logging
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 15:09:10 -0700
In-Reply-To: <alpine.LNX.2.00.1406182358320.2303@pobox.suse.cz>
References: <alpine.LNX.2.00.1406181406401.2303@pobox.suse.cz>
	 <1403117049.3839.21.camel@joe-AO725>
	 <alpine.LNX.2.00.1406182358320.2303@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 23:59 +0200, Jiri Kosina wrote:
> On Wed, 18 Jun 2014, Joe Perches wrote:
> 
> > Use a more current style to prefix "floppy: " on
> > all messages.
> > 
> > Convert DPRINT to emit at KERN_DEBUG.
> > 
> > Other miscellaneous logging changes:
> > 
> > o Add missing newline
> > o Remove embedded "floppy" style prefixes
> 
> Why is this a good change?
> 
> [ ... ]
> >  	if (!req) {
> > -		pr_info("floppy.c: no request in request_done\n");
> > +		pr_info("no request in request_done\n");
> 
> I think that in cases like this (and elsewhere where you are changing it 
> in your patch) the prefix is actually useful.

Adding

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

makes sure that all printks from this module
are prefixed with "floppy: ".

Currently, only a very few actually are prefixed
with anything and there are some prefix mixtures of
"floppy: " and "floppy.c: "




