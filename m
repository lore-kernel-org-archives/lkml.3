Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3KOAbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:31:10 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55447 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3KOAbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:31:03 -0500
X-AuditID: 9c93017e-b7cbeae0000003a9-00-52856b45fc11
Date: Fri, 15 Nov 2013 09:31:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, mgorman@suse.de, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131115003110.GF4407@bbox>
References: <20131107070451.GA10645@bbox>
 <20131112154137.GA3330@gmail.com>
 <alpine.LNX.2.00.1311131811030.1120@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1311131811030.1120@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hugh,

On Wed, Nov 13, 2013 at 08:00:34PM -0800, Hugh Dickins wrote:
> On Wed, 13 Nov 2013, Minchan Kim wrote:
> > On Thu, Nov 07, 2013 at 04:04:51PM +0900, Minchan Kim wrote:
> > > On Wed, Nov 06, 2013 at 07:05:11PM -0800, Greg KH wrote:
> > > > On Wed, Nov 06, 2013 at 03:46:19PM -0800, Nitin Gupta wrote:
> > > >  > I'm getting really tired of them hanging around in here for many years
> > > > > > now...
> > > > > >
> > > > > 
> > > > > Minchan has tried many times to promote zram out of staging. This was
> > > > > his most recent attempt:
> > > > > 
> > > > > https://lkml.org/lkml/2013/8/21/54
> ...
> > 
> > Hello Andrew,
> > 
> > I'd like to listen your opinion.
> > 
> > The zram promotion trial started since Aug 2012 and I already have get many
> > Acked/Reviewed feedback and positive feedback from Rik and Bob in this thread.
> > (ex, Jens Axboe[1], Konrad Rzeszutek Wilk[2], Nitin Gupta[3], Pekka Enberg[4])
> > In Linuxcon, Hugh gave positive feedback about zram(Hugh, If I misunderstood,
> > please correct me!). And there are lots of users already in embedded industry
> > ex, (most of TV in the world, Chromebook, CyanogenMod, Android Kitkat.)
> > They are not idiot. Zram is really effective for embedded world.
> 
> Sorry for taking so long to respond, Minchan: no, you do not misrepresent
> me at all.  Promotion of zram and zsmalloc from staging is way overdue:
> they long ago proved their worth, look tidy, and have an active maintainer.
> 
> Putting them into drivers/staging was always a mistake, and I quite
> understand Greg's impatience with them by now; but please let's move
> them to where they belong instead of removing them.
> 
> I would not have lent support to zswap if I'd thought that was going to
> block zram.  And I was not the only one surprised when zswap replaced its
> use of zsmalloc by zbud: we had rather expected a zbud option to be added,
> and I still assume that zsmalloc support will be added back to zswap later.
> 
> I think your August 2013 posting moved zsmalloc under zram and moved it
> all to drivers/block?  That is the right place for zram, but I do think
> zsmalloc.c (I'm not very keen on _drvs and -mains myself) should be
> alongside zbud.c in mm, where we can better keep an eye on its
> struct-pageyness.

It's really no problem and it was what I want from the beginning.
https://lkml.org/lkml/2012/9/11/551
I will do in next posting.

Before that, I'd like to listen Andrew's opinion about promoting because
my previous trials to promote zram have ignored so it was just waste
for my time and noisy for you guys. 

Andrew, please tell us your decision. May I go ahead?

> 
> IMHO
> Hugh
> 
> > 
> > We spent much time with preventing zram enhance since it have been in staging
> > and Greg never want to improve without promotion.
> > 
> > Please consider promotion and let us improve it.
> > I think only remained thing is your decision.
> > 
> > 
> > 1. https://lkml.org/lkml/2012/9/11/551
> > 2. https://lkml.org/lkml/2012/8/9/636
> > 3. https://lkml.org/lkml/2012/8/8/390
> > 4. https://lkml.org/lkml/2012/9/26/126
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
