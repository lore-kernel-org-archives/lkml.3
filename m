Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbaGAXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 19:09:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbaGAXJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 19:09:55 -0400
Date: Wed, 2 Jul 2014 00:09:49 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Improve sequential read throughput v4r8
Message-ID: <20140701230949.GZ10819@suse.de>
References: <1404146883-21414-1-git-send-email-mgorman@suse.de>
 <20140701171611.GB1369@cmpxchg.org>
 <20140701183915.GW10819@suse.de>
 <20140701223817.GI4453@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140701223817.GI4453@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 08:38:17AM +1000, Dave Chinner wrote:
> On Tue, Jul 01, 2014 at 07:39:15PM +0100, Mel Gorman wrote:
> > On Tue, Jul 01, 2014 at 01:16:11PM -0400, Johannes Weiner wrote:
> > > On Mon, Jun 30, 2014 at 05:47:59PM +0100, Mel Gorman wrote:
> > > Seqread throughput is up, randread takes a small hit.  But allocation
> > > latency is badly screwed at higher concurrency levels:
> > 
> > So the results are roughly similar. You don't state which filesystem it is
> > but FWIW if it's the ext3 filesystem using the ext4 driver then throughput
> > at higher levels is also affected by filesystem fragmentation. The problem
> > was outside the scope of the series.
> 
> I'd suggest you're both going wrong that the "using ext3" point.
> 
> Use ext4 or XFS for your performance measurements because that's
> what everyone is using for the systems these days. iNot to mention
> they don'thave all the crappy allocation artifacts that ext3 has,
> nor the throughput limitations caused by the ext3 journal, and so
> on.
> 
> Fundamentally, ext3 performance is simply not a relevant performance
> metric anymore - it's a legacy filesystem in maintenance mode and
> has been for a few years now...
> 

The problem crosses filesystems. ext3 is simply the first in the queue
because by and large it behaved the worst.  Covering the rest of them
simply takes more time and with different results as you may expect. Here
are the xfs results for the smaller of the machines as it was able to get
that far before it got reset

                                      3.16.0-rc2                 3.0.0            3.16.0-rc2
                                         vanilla               vanilla           fairzone-v4
Min    SeqRead-MB/sec-1          92.69 (  0.00%)       99.68 (  7.54%)      104.47 ( 12.71%)
Min    SeqRead-MB/sec-2         106.81 (  0.00%)      123.43 ( 15.56%)      123.24 ( 15.38%)
Min    SeqRead-MB/sec-4         101.89 (  0.00%)      113.78 ( 11.67%)      116.85 ( 14.68%)
Min    SeqRead-MB/sec-8          95.31 (  0.00%)       91.40 ( -4.10%)      101.68 (  6.68%)
Min    SeqRead-MB/sec-16         81.84 (  0.00%)       88.53 (  8.17%)       86.63 (  5.85%)

-- 
Mel Gorman
SUSE Labs
