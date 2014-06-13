Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaFMJa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:30:27 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:59687 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751761AbaFMJa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:30:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3743:3865:3866:3868:3870:3871:3872:3874:4321:4605:5007:7652:10004:10400:10848:11232:11233:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stew48_77f1c90ebab1d
X-Filterd-Recvd-Size: 2142
Message-ID: <1402651822.12385.31.camel@joe-AO725>
Subject: Re: [patch] checkpatch: warn on missing spaces in broken up quoted
 strings
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2014 02:30:22 -0700
In-Reply-To: <20140613065346.GA28134@mwanda>
References: <20140613065346.GA28134@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 09:53 +0300, Dan Carpenter wrote:
> Checkpatch already complains when people break up quoted strings but
> it's still pretty common.  One mistake that people often make is they
> leave out the space character between the two strings.
> 
> This check adds 453 new warnings.  There very few false positives, here
> is what they look like:
> 
> 1) Most of the false positives are in crypto/testmgr.h where they just
>    want a 10x10 block of sample text and don't care about the content.
> 2) There one commented place like this:
>   "das08-aoh"
>   "das08-aol"
> 3) There is one place which breaks the alphabet at the lower and upper
>    case boundary.
> 4) There is one person who broke quoted strings at the 80 character mark
>    without considering the content (that's not really a false positive,
>    now that I think about it).
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +# check for missing a space in a string concatination
> +        if ($prevrawline =~ /[^\\][a-zA-Z]"$/ && $rawline =~ /^\+[\t ]+"[a-zA-Z]/) {
> +            WARN('MISSING_SPACE',
> +                 "break quoted strings at a space character\n" . $hereprev);
> +        }

Probably want digits too so maybe \w instead of "[a-zA-Z]/


