Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbaGAWiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:38:23 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45673 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbaGAWiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:38:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiNWAC83s1N5LHZ8PGdsb2JhbABagw2DSYUIpBIGmkkBgQwXBAEBAQE4NYQDAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQcc7FxeFWIkwB4RDBZpll1gr
Date: Wed, 2 Jul 2014 08:38:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Improve sequential read throughput v4r8
Message-ID: <20140701223817.GI4453@dastard>
References: <1404146883-21414-1-git-send-email-mgorman@suse.de>
 <20140701171611.GB1369@cmpxchg.org>
 <20140701183915.GW10819@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701183915.GW10819@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:39:15PM +0100, Mel Gorman wrote:
> On Tue, Jul 01, 2014 at 01:16:11PM -0400, Johannes Weiner wrote:
> > On Mon, Jun 30, 2014 at 05:47:59PM +0100, Mel Gorman wrote:
> > Seqread throughput is up, randread takes a small hit.  But allocation
> > latency is badly screwed at higher concurrency levels:
> 
> So the results are roughly similar. You don't state which filesystem it is
> but FWIW if it's the ext3 filesystem using the ext4 driver then throughput
> at higher levels is also affected by filesystem fragmentation. The problem
> was outside the scope of the series.

I'd suggest you're both going wrong that the "using ext3" point.

Use ext4 or XFS for your performance measurements because that's
what everyone is using for the systems these days. iNot to mention
they don'thave all the crappy allocation artifacts that ext3 has,
nor the throughput limitations caused by the ext3 journal, and so
on.

Fundamentally, ext3 performance is simply not a relevant performance
metric anymore - it's a legacy filesystem in maintenance mode and
has been for a few years now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
