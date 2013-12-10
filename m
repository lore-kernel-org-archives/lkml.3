Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3LJESr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 23:18:47 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21893 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071Ab3LJESa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 23:18:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEIAMOVplJ5LHyk/2dsb2JhbABZgwe0ToVQgSIXdIIlAQEFOhwjEAgDDgcDCSUPBSUDIROIAcBcFxaOegeDIIETA5gTkhSDPSg
Date: Tue, 10 Dec 2013 15:18:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, hannes@cmpxchg.org, mhocko@suse.cz,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org,
        glommer@openvz.org, glommer@gmail.com,
        Glauber Costa <gloomer@openvz.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v13 13/16] vmscan: take at least one pass with shrinkers
Message-ID: <20131210041826.GB31386@dastard>
References: <cover.1386571280.git.vdavydov@parallels.com>
 <5287164773f8aade33ce17f3c91546c6e1afaf85.1386571280.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5287164773f8aade33ce17f3c91546c6e1afaf85.1386571280.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 12:05:54PM +0400, Vladimir Davydov wrote:
> From: Glauber Costa <glommer@openvz.org>
> 
> In very low free kernel memory situations, it may be the case that we
> have less objects to free than our initial batch size. If this is the
> case, it is better to shrink those, and open space for the new workload
> then to keep them and fail the new allocations.
> 
> In particular, we are concerned with the direct reclaim case for memcg.
> Although this same technique can be applied to other situations just as
> well, we will start conservative and apply it for that case, which is
> the one that matters the most.

This should be at the start of the series.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
