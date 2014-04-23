Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaDWB6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:58:18 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3399 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbaDWB6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:58:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq9xAPIdV1N5LEcvPGdsb2JhbABZgwaIbqMPmWeBExcDAQEBATg1giUBAQUnExwjEAgDDgoJJQ8FJQMHGhOIQKx5okQXFo5AB4Q4BIV2knmKbIsqKw
Date: Wed, 23 Apr 2014 11:58:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>, hch <hch@infradead.org>
Subject: Re: [PATCH 1/1] fs/xfs/xfs_log.c: Fix comparison to bool
Message-ID: <20140423015803.GH15995@dastard>
References: <20140413220917.a566d048eb0cc55b5ec9f7be@skynet.be>
 <20140416151557.ac032e9621027faa8fc7f86d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416151557.ac032e9621027faa8fc7f86d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:15:57PM -0700, Andrew Morton wrote:
> On Sun, 13 Apr 2014 22:09:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > Fixing coccinelle warning
> 
> Please always quote the full error message or warning text when fixing
> such things.

And CC the correct lists (xfs@oss.sgi.com) and/or the subsystem
maintainer (me). LKML is extremely lossy - I got behind on reading
it and so simply deleted the 10,000 queued emails, one of which was
this patch....

> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2376,7 +2376,7 @@ next_lv:
> >  				if (lv)
> >  					vecp = lv->lv_iovecp;
> >  			}
> > -			if (record_cnt == 0 && ordered == false) {
> > +			if (record_cnt == 0 && !ordered) {
> >  				if (!lv)
> >  					return 0;
> 
> There was nothing wrong with that code.  I suspect coccinelle bustage.

Agreed, especially given that the variable is declared as:

	bool ordered = false;

So it can only have the values of false and true....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
