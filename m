Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbaGDREG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:04:06 -0400
Received: from smtprelay0105.hostedemail.com ([216.40.44.105]:46285 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752257AbaGDREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:04:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3873:3874:4321:4605:5007:6117:6119:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: net45_404da34973850
X-Filterd-Recvd-Size: 2536
Message-ID: <1404493440.6384.28.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Emit a warning on file add/move/delete
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 04 Jul 2014 10:04:00 -0700
In-Reply-To: <20140704151128.GC20758@bark>
References: <1404434816.6384.5.camel@joe-AO725>
	 <20140704151128.GC20758@bark>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 16:11 +0100, Andy Whitcroft wrote:
> On Thu, Jul 03, 2014 at 05:46:56PM -0700, Joe Perches wrote:
> > Whenever files are added, moved, or deleted, the
> > MAINTAINERS file patterns can be out of sync or
> > outdated.
> > 
> > To try to keep MAINTAINERS more up-to-date, add a
> > one-time warning whenever a patch does any of those.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > +# Check for added, moved or deleted files
> > +		if (!$reported_maintainer_file && !$in_commit_log &&
> > +		    ($line =~ /^(?:new|deleted) file mode\s*\d+\s*$/ ||
> > +		     $line =~ /^rename (?:from|to) [\w\/\.\-]+\s*$/ ||
> > +		     ($line =~ /\{\s*([\w\/\.\-]*)\s*\=\>\s*([\w\/\.\-]*)\s*\}/ &&
> > +		      (defined($1) || defined($2))))) {
> > +			$reported_maintainer_file = 1;
> > +			WARN("FILE_PATH_CHANGES",
> > +			     "added, moved or deleted file(s), does MAINTAINERS need updating?\n" . $herecurr);
> > +		}
> > +
[]
> That seems like a sensible plan.  Sometime we might try and work out if
> any entries are affected or needed.
> 
> I think you are checking against the git ways of mentioning this only,

Yes, I believe so.

> don't know if there is any milage in checking the dates which also
> convey add/remove info via datea at the epoch.

I don't remember what that date format looks like.
Got an example?

Maybe there's value in checking the diff file header
for /dev/null

Something like:

--- t.c	2014-04-11 10:57:07.767131132 -0700
+++ /dev/null	2014-06-30 13:19:01.524210166 -0700

or

--- /dev/null	2014-06-30 13:19:01.524210166 -0700
+++ t.c	2014-04-11 10:57:07.767131132 -0700

Is there some other form?

