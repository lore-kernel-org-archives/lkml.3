Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3HBJPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:15:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:54456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab3HBJPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:15:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,800,1367996400"; 
   d="scan'208";a="380574989"
Message-ID: <1375434911.31118.74.camel@smile>
Subject: Re: [PATCH 2/2] aoe: use min() to simplify the code
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 02 Aug 2013 12:15:11 +0300
In-Reply-To: <5B6F37C8-CB08-4BA6-9AC9-D328711385F9@coraid.com>
References: <1375360134-20860-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1375360134-20860-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <5B6F37C8-CB08-4BA6-9AC9-D328711385F9@coraid.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 21:13 -0400, Ed Cashin wrote: 
> Thanks.
> 
> I agree that we could do that.  I'm not sure it increases readability to put this much stuff on one line, though.  What is the motivation?

Motivation is to explicitly show that that operation is to calculate a
minimum of two the slen parameter and the length of last part of the
disk_name.

It seems matter of taste, so, I'm okay with current piece of code.

> > min() incorporates condition in it. In our case we could do assignment and
> > make a choice at once.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> > drivers/block/aoe/aoedev.c | 6 ++----
> > 1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
> > index db35ef6..92fadfa 100644
> > --- a/drivers/block/aoe/aoedev.c
> > +++ b/drivers/block/aoe/aoedev.c
> > @@ -13,6 +13,7 @@
> > #include <linux/kdev_t.h>
> > #include <linux/moduleparam.h>
> > #include <linux/string.h>
> > +#include <linux/kernel.h>
> > #include "aoe.h"
> > 
> > static void dummy_timer(ulong);
> > @@ -248,10 +249,7 @@ user_req(char *s, size_t slen, struct aoedev *d)
> > 	if (!d->gd)
> > 		return 0;
> > 	p = kbasename(d->gd->disk_name);
> > -	lim = sizeof(d->gd->disk_name);
> > -	lim -= p - d->gd->disk_name;
> > -	if (slen < lim)
> > -		lim = slen;
> > +	lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
> > 
> > 	return !strncmp(s, p, lim);
> > }
> > -- 
> > 1.8.3.2
> > 
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
