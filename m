Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaEMWae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:30:34 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:42160 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409AbaEMWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:30:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3874:4250:4321:5007:6119:7652:7875:7903:10004:10400:10450:10455:10848:10967:11232:11658:11914:12296:12517:12519:12663:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stop34_20a76e1fa4143
X-Filterd-Recvd-Size: 1973
Message-ID: <1400020223.24350.73.camel@joe-AO725>
Subject: Re: [PATCH 2/2] FS/CONFIGFS: Use pr_fmt
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>
Date: Tue, 13 May 2014 15:30:23 -0700
In-Reply-To: <20140513151541.a4e5649a657569e8847b3d84@linux-foundation.org>
References: <20140513202428.77c59d530a2c2154a9902cb3@skynet.be>
	 <20140513135049.2d160a63d662b3aab6ba3c03@linux-foundation.org>
	 <75410.1400018810@turing-police.cc.vt.edu>
	 <20140513151541.a4e5649a657569e8847b3d84@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 15:15 -0700, Andrew Morton wrote:
> On Tue, 13 May 2014 18:06:50 -0400 Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 13 May 2014 13:50:49 -0700, Andrew Morton said:
> > > On Tue, 13 May 2014 20:24:28 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> > 
> > > > +#ifdef pr_fmt
> > > > +#undef pr_fmt
> > > > +#endif
> > >
> > > Why this?
> > >
> > > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > 
> > Won't GCC whinge by default about the #define if it doesn't exactly match the
> > previous definition?
> 
> Yes, if there's already a pf_fmt defined.  That's what I'm asking about
> - what pr_fmt are we overriding here?  Seems wrong.

If this is not the first #include or if this
#includes kernel.h/printk.h, then the default
#define pr_fmt(fmt) fmt
from printk.h will be used.

One year soon, I'd like to change the default
from blank to KBUILD_MODNAME ": " fmt


