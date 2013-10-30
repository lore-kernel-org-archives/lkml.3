Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3J3Nqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:46:55 -0400
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:54843 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751611Ab3J3Nqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:46:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4362:5007:6120:7652:7903:8985:9025:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pot22_7607a5e5c004e
X-Filterd-Recvd-Size: 2412
Message-ID: <1383140810.12439.69.camel@joe-AO722>
Subject: Re: [RFC PATCH -next] Fix printk_once build errors due to
 __read_mostly
From: Joe Perches <joe@perches.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-metag@vger.kernel.org
Date: Wed, 30 Oct 2013 06:46:50 -0700
In-Reply-To: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 10:18 +0000, James Hogan wrote:
> Commit 3e39c1ab04ba (printk: mark printk_once test variable
> __read_mostly) added __read_mostly to the __print_once bool in the
> printk_once() macro, but __read_mostly is defined in <linux/cache.h>
> which isn't included from <linux/printk.h>. This results in build errors
> like this:
> 
> arch/metag/mm/l2cache.c: In function 'meta_l2c_setup':
> arch/metag/mm/l2cache.c:56: error: '__read_mostly' undeclared
> 
> This is fixed by adding an include of <linux/cache.h> from
> <linux/printk.h> since I don't think printk_once() users should need to
> include <linux/cache.h> for it to work.
> 
> Note that this actually adds a recursive include, since <linux/cache.h>
> includes <linux/kernel.h>, which includes <linux/printk.h>. The actual
> dependencies are all in macros so it doesn't actually seem to result in
> any build failures, but it's clearly less than ideal.

Thanks James.

Oh well.  Pity about the recursive #include.
It seems most every actual use of __read_mostly gets
that cache.h include indirectly.

Perhaps it's better just to remove the __read_mostly patch
as the __read_mostly value is pretty low.

Andrew, could you please remove my __read_mostly patch?

I preferred that printk.h not be a file that
could be independently used via #include.

https://lkml.org/lkml/2011/5/25/331
https://lkml.org/lkml/2011/5/25/333

and that only kernel.h should be used.

Maybe that's still a better approach.

