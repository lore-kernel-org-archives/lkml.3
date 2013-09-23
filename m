Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3IWSG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:06:56 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:55024 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753252Ab3IWSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:06:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6691:7652:8527:10004:10400:10848:11232:11473:11658:11914:12043:12296:12438:12517:12519:12679:12740:13095:13137:13150:13230:13231,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cork12_59358d7fa464b
X-Filterd-Recvd-Size: 2751
Message-ID: <1379959611.3575.40.camel@joe-AO722>
Subject: Re: checkpatch guide for newbies
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Sep 2013 11:06:51 -0700
In-Reply-To: <20130923090100.GE6192@mwanda>
References: <20130923090100.GE6192@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 12:01 +0300, Dan Carpenter wrote:
> I've written a checkpatch guide for newbies because it seems like they
> make the same mistakes over and over.  I intend to put it under
> Documentation/.  Could you look it over?
> 
> 
> 		Introduction
> 
> This document is aimed at new kernel contributors using "checkpatch.pl --file".
> 
> The first thing to remember is that the aim is not to get rid of every
> checkpatch.pl warning; the aim is to make the code cleaner and more readable.
> The other thing to remember is that checkpatch.pl is not a very smart tool and
> there are mistakes that it misses so keep your eyes open for those as well.

Maybe suggest using

	checkpatch.pl --file --fix --strict --types=<specific_type> <file>
	mv <file>.EXPERIMENTAL-checkpatch-fixes <file>
	git diff <file>

where <specific_types> is one of

For whitespace only changes
	SPACING
	SPACE_BEFORE_TAB
	POINTER_LOCATION
For code changes:
	C99_COMMENTS
	PREFER_PACKED
	PREFER_ALIGNED
	AVOID_EXTERNS
	PARENTHESIS_ALIGNMENT

> For example, checkpatch.pl could warn about a badly formatted warning message.
> Ask yourself, is the warning message is clear?  Is it needed?  Could a
> non-privileged user trigger the warning and flood the syslog?  Are there
> spelling mistakes?  Since Checkpatch.pl has flagged the line as sloppy code,
> there may be multiple mistakes.
> 
> In the Linux kernel, we take an enormous pride in our work and we want clean
> code.  But the one major drawback to cleanup patches is that they break
> "git blame" so it's not a good idea for newbies to send very trivial cleanup
> patches to the kernel/ directory.  It's better to get a little experience in the
> drivers/ directory first.  The drivers/staging/ directory in particular always
> needs cleanup patches.

I think suggesting working _only_ in the drivers/staging/
directory tree might be better.

Maybe I'll submit some auto-neatening script eventually
and see what you think.

