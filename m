Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbaEIVoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:44:20 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:49509 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757836AbaEIVoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:44:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2196:2199:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:4470:4605:5007:6119:6691:7652:7903:8531:8660:10004:10400:10848:11658:11914:12517:12519:12740:13069:13148:13230:13255:13311:13357:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wind57_7c485f8a80f1c
X-Filterd-Recvd-Size: 2695
Message-ID: <1399671852.2912.29.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Make --strict a default for files in
 drivers/net and net/
From: Joe Perches <joe@perches.com>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Fri, 09 May 2014 14:44:12 -0700
In-Reply-To: <20140509162914.8f8ac84b3a973820a21e5c2d@freescale.com>
References: <487acde009f61607863704e5dd9da7f151cf5be8.1399486274.git.joe@perches.com>
	 <20140509153748.e2467ab487404f07e818719e@freescale.com>
	 <1399668975.2912.14.camel@joe-AO725>
	 <20140509162914.8f8ac84b3a973820a21e5c2d@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 16:29 -0500, Kim Phillips wrote:
[]
> > > this isn't easily extensible/scalable to other subsystems, or
> > > say something like "all Freescale drivers."  Having it configurable
> > > in .checkpatch.conf might be a better solution, but I don't believe
> > > networking should be the only subsystem that can take advantage of
> > > the extra checkpatch CHECKs.
> > 
> > staging probably could too.
> 
> why call staging out to be subject to stricter checks than the rest
> of the kernel, when it's code that's _known_ to be non-compliant?

Staging is mostly a "play area sandbox" for people
that want to submit "my first kernel patch" and
GregKH seems to apply style-only patches like that.

> > > Can we enable --strict universally in the Linux kernel, maybe like
> > > so:?
> > 
> > I don't think that's appropriate (yet?).
> 
> why not?  checkpatch CHECKs seem reasonably stable AFAICT.

Several maintainers have their own style or don't
care at all about what indentation is used.

Several maintainers prefer stasis to what they
perceive as changes that are just whitespace noise.

> would an alternative option be to promote CHECKs like parentheses
> alignment to WARN status?

Probably not.

> > Try that with a per-file "wc -l" for checks per LOC
> 
> good point, that reinforces the statement back for networking :) :
> 
> {drivers/}net/ :            0.013 CHECKs per .[hc] file line
> everything else:            0.43  CHECKs per .[hc] file line
> no net, no drivers/staging: 0.38  CHECKs per .[hc] file line

yup. cheers, Joe

