Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965745Ab3E2S3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:29:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab3E2S3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:29:32 -0400
Date: Wed, 29 May 2013 11:29:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
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
Message-Id: <20130529112929.24005ae9cf1d9d636b2ea42f@linux-foundation.org>
In-Reply-To: <20130529145720.GA428@cerebellum>
References: <1369067168-12291-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1369067168-12291-4-git-send-email-sjenning@linux.vnet.ibm.com>
	<20130528145918.acbd84df00313e527cf04d1b@linux-foundation.org>
	<20130529145720.GA428@cerebellum>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 09:57:20 -0500 Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> > > +/*********************************
> > > +* helpers
> > > +**********************************/
> > > +static inline bool zswap_is_full(void)
> > > +{
> > > +	return (totalram_pages * zswap_max_pool_percent / 100 <
> > > +		zswap_pool_pages);
> > > +}
> > 
> > We have had issues in the past where percentage-based tunables were too
> > coarse on very large machines.  For example, a terabyte machine where 0
> > bytes is too small and 10GB is too large.
> 
> Yes, this is known limitation of the code right now and it is a high priority
> to come up with something better.  It isn't clear what dynamic sizing policy
> should be used so, until such time as that policy can be determined, this is a
> simple stop-gap that works well enough for simple setups.

It's a module parameter and hence is part of the userspace interface. 
It's undesirable that the interface be changed, and it would be rather
dumb to merge it as-is when we *know* that it will be changed.

I don't think we can remove the parameter altogether (or can we?), so I
suggest we finalise it ASAP.  Perhaps rename it to
zswap_max_pool_ratio, with a range 1..999999.  Better ideas needed :(


