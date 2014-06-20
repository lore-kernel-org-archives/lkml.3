Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967065AbaFTL3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:29:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966658AbaFTL3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:29:01 -0400
Date: Fri, 20 Jun 2014 12:28:57 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] cfq: Increase default value of target_latency
Message-ID: <20140620112857.GF10819@suse.de>
References: <1403079807-24690-1-git-send-email-mgorman@suse.de>
 <1403079807-24690-2-git-send-email-mgorman@suse.de>
 <x49y4wslp6z.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <x49y4wslp6z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 02:38:44PM -0400, Jeff Moyer wrote:
> Mel Gorman <mgorman@suse.de> writes:
> 
> > The existing CFQ default target_latency results in very poor performance
> > for larger numbers of threads doing sequential reads.  While this can be
> > easily described as a tuning problem for users, it is one that is tricky
> > to detect. This patch the default on the assumption that people with access
> > to expensive fast storage also know how to tune their IO scheduler.
> >
> > The following is from tiobench run on a mid-range desktop with a single
> > spinning disk.
> >
> >                                       3.16.0-rc1            3.16.0-rc1                 3.0.0
> >                                          vanilla          cfq600                     vanilla
> > Mean   SeqRead-MB/sec-1         121.88 (  0.00%)      121.60 ( -0.23%)      134.59 ( 10.42%)
> > Mean   SeqRead-MB/sec-2         101.99 (  0.00%)      102.35 (  0.36%)      122.59 ( 20.20%)
> > Mean   SeqRead-MB/sec-4          97.42 (  0.00%)       99.71 (  2.35%)      114.78 ( 17.82%)
> > Mean   SeqRead-MB/sec-8          83.39 (  0.00%)       90.39 (  8.39%)      100.14 ( 20.09%)
> > Mean   SeqRead-MB/sec-16         68.90 (  0.00%)       77.29 ( 12.18%)       81.64 ( 18.50%)
> 
> Did you test any workloads other than this? 

dd tests were inconclusive due to high variability. The dbench results
hadn't come through but regression tests there indicate that it has
regressed for high numbers of clients. I know sequential reads of
benchmarks like bonnie++ have also regressed but I have not reverified
the results yet.

> Also, what normal workload
> has 8 or more threads doing sequential reads?  (That's an honest
> question.)
> 

File servers, mail servers, streaming media servers with multiple users,
multi-user systems

-- 
Mel Gorman
SUSE Labs
