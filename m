Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaIJNzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:55:39 -0400
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:33907 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751084AbaIJNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:55:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2898:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4362:5007:6119:6742:7652:10004:10400:10450:10455:10848:11232:11658:11914:12043:12517:12519:12740:13069:13095:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy05_3092d0d13c656
X-Filterd-Recvd-Size: 2903
Message-ID: <1410357331.24028.39.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Warn on macros with flow control statements
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Andy Whitcroft <apw@canonical.com>
Date: Wed, 10 Sep 2014 06:55:31 -0700
In-Reply-To: <20140910084306.GV6600@mwanda>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
	 <20140909125410.GJ6549@mwanda> <1410295093.12560.60.camel@joe-AO725>
	 <20140910084306.GV6600@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 11:43 +0300, Dan Carpenter wrote:
> On Tue, Sep 09, 2014 at 01:38:13PM -0700, Joe Perches wrote:
> > Macros with flow control statements (goto and return) are
> > not very nice to read as any flow movement is unexpected.

break and continue are also flow control statements
but are those are frequently used in macros in
complete switch statements so were not added.
 
> > Try to highlight them and emit a warning on their definition.
> > 
> > Avoid warning on macros that use argument concatenation as
> > those macros commonly create another function where the
> > concatenation is used in the function name definition like:
> > 	#define FOO_FUNC(name, rtn_type)	\
> > 	rtn_type func##name(arg1, ...)		\
> > 	{					\
> > 		rtn_type rtn;			\
> > 		[code...]			\
> > 		return rtn;			\
> > 	}
> > 
> 
> It adds 382 new warnings.

Thanks for running it over the tree.

> The '##' trick doesn't remove all then macros which create functions.
> I can't think of a better way to do that though.

Nor I.  I suppose it could be a --strict CHK and not
a WARN message type though.

> We will eventually get rid of almost all the warnings in staging.  The
> one that makes sense to keep is:
> 
> drivers/staging/lustre/lnet/selftest/selftest.h:559
> #define STATE2STR(x) case x: return #x

Yup, there are a few of those and they should
definitely stay.

> My guess is that other maintainers won't be as excited to change these...

Do maintainers ever get excited about style?

> Some of the macros have "RETURN", "RET" or "EXIT" in the name so the
> return is not really hidden.

Not sure what to do about that.

