Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbaFKQBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:01:49 -0400
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:42956 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753048AbaFKQBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:01:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:2908:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3873:3874:4321:4362:5007:6120:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13161:13229:13255:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rat40_494100d035260
X-Filterd-Recvd-Size: 1897
Message-ID: <1402502500.6169.5.camel@joe-AO725>
Subject: Re: [RFC PATCH] checkpatch: Attempt to find unnecessary 'out of
 memory' messages
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Wed, 11 Jun 2014 09:01:40 -0700
In-Reply-To: <20140611074704.GS5015@mwanda>
References: <1402419340.30479.18.camel@joe-AO725>
	 <20140611074704.GS5015@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 10:47 +0300, Dan Carpenter wrote:
> Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This check introduces 1849 new checkpatch.pl warnings.  I looked through
> the first 70 warnings and there were no false positives.

Thanks for checking Dan.

As your systems are much faster than mine, perhaps you could publish
the output of some script like:

$ git ls-files -- "*.[ch]" | while read file ; do \
	./scripts/checkpatch.pl -f --emacs --terse --no-summary --types=OOM_MESSAGE $file; \
  done

to someplace like kernel janitors.

That might prompt someone to submit patch series for them.

> Besides the bloat issue, I don't like these warnings because they make
> the error handling harder to read.  They are sort of a mindless thing
> that people feel they have to do for no particular reason.  Since
> people aren't thinking when they write the error message then you get
> NULL dereferences and so on.

Yeah, that too.

cheers, Joe

