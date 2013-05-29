Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967055Ab3E2VJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:09:12 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42253 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967065Ab3E2VJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:09:00 -0400
Date: Wed, 29 May 2013 16:08:20 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv12 3/4] zswap: add to mm/
Message-ID: <20130529210820.GF428@cerebellum>
References: <1369067168-12291-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1369067168-12291-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130528145918.acbd84df00313e527cf04d1b@linux-foundation.org>
 <20130529145720.GA428@cerebellum>
 <20130529112929.24005ae9cf1d9d636b2ea42f@linux-foundation.org>
 <20130529195027.GC428@cerebellum>
 <20130529125747.23a6a26cdcb013842bf31644@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529125747.23a6a26cdcb013842bf31644@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052921-3620-0000-0000-000002C70DA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 12:57:47PM -0700, Andrew Morton wrote:
> On Wed, 29 May 2013 14:50:27 -0500 Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:
> 
> > On Wed, May 29, 2013 at 11:29:29AM -0700, Andrew Morton wrote:
> > > On Wed, 29 May 2013 09:57:20 -0500 Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:
> > > 
> > > > > > +/*********************************
> > > > > > +* helpers
> > > > > > +**********************************/
> > > > > > +static inline bool zswap_is_full(void)
> > > > > > +{
> > > > > > +	return (totalram_pages * zswap_max_pool_percent / 100 <
> > > > > > +		zswap_pool_pages);
> > > > > > +}
> > > > > 
> > > > > We have had issues in the past where percentage-based tunables were too
> > > > > coarse on very large machines.  For example, a terabyte machine where 0
> > > > > bytes is too small and 10GB is too large.
> > > > 
> > > > Yes, this is known limitation of the code right now and it is a high priority
> > > > to come up with something better.  It isn't clear what dynamic sizing policy
> > > > should be used so, until such time as that policy can be determined, this is a
> > > > simple stop-gap that works well enough for simple setups.
> > > 
> > > It's a module parameter and hence is part of the userspace interface. 
> > > It's undesirable that the interface be changed, and it would be rather
> > > dumb to merge it as-is when we *know* that it will be changed.
> > > 
> > > I don't think we can remove the parameter altogether (or can we?), so I
> > > suggest we finalise it ASAP.  Perhaps rename it to
> > > zswap_max_pool_ratio, with a range 1..999999.  Better ideas needed :(
> > 
> > zswap_max_pool_ratio is fine with me.  I'm not entirely clear on the change
> > though.  Would that just be a name change or a change in meaning?
> 
> It would be a change in behaviour.  The problem which I'm suggesting we
> address is that a 1% increment is too coarse.

Sorry, but I'm not getting this.  This zswap_max_pool_ratio is a ratio of what
to what?  Maybe if you wrote out the calculation of the max pool size using
this ratio I'll get it.

Seth

