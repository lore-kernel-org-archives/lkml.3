Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaCaWKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:10:43 -0400
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:35001 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751332AbaCaWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:10:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:4321:5007:7652:7903:10004:10400:10471:10848:10967:11232:11658:11914:12346:12517:12519:12663:12740:13069:13255:13311:13357:14039,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soap88_7a32b72fd350e
X-Filterd-Recvd-Size: 2201
Message-ID: <1396303838.21529.68.camel@joe-AO722>
Subject: Re: [PATCH V2 1/2] checkpatch: Expand parenthesis alignment test to
 declarations, functions and assignments
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 31 Mar 2014 15:10:38 -0700
In-Reply-To: <20140331150625.ca937ea946da5ce619efe2cf@linux-foundation.org>
References: <bf056087fcb8139db3bbf6c187555ab64758f9d4.1396302777.git.joe@perches.com>
	 <20140331150625.ca937ea946da5ce619efe2cf@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 15:06 -0700, Andrew Morton wrote:
> On Mon, 31 Mar 2014 14:58:07 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > Currently the parenthesis alignment test works only on
> > misalignments of if statements like
> > 
> > 	if (foo(bar,
> > 			baz)
> > 
> > Expand the test to find misalignments like:
> > 
> > static inline int foo(int bar,
> > 			int baz)
> > 
> > and
> > 
> > 	foo(bar,
> > 			baz);
> > 
> > and
> > 
> > 	foo = bar(baz,
> > 			qux);
> > 
> > Expand the $Inline keyword for __inline and __inline__ too.
> > Add $Inline to $Declare so it also matches "static inline <foo>".
> 
> I'm having trouble understanding what this patch actually does.  Some
> little examples would be nice.
> 
> I typed in this to play with:
> 
> void foo(int a,
> 		int b)
> {
> }
> 
> but I experienced playus interruptus
> 
> akpm3:/usr/src/25> perl scripts/checkpatch.pl -f t.c
> Global symbol "$c90_Keywords" requires explicit package name at scripts/checkpatch.pl line 2162.
> Execution of scripts/checkpatch.pl aborted due to compilation errors.
> 
> System is Ubuntu 12.04.4 (ish).

You have to apply it to -next (your mm queue)

