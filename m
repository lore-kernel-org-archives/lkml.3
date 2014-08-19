Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaHSPv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:51:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:5763 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbaHSPv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:51:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,895,1400050800"; 
   d="scan'208";a="578819923"
Date: Tue, 19 Aug 2014 23:51:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [mm] 3484b2de949: -56.2% vm-scalability.throughput, +9.3%
 turbostat.Pkg_W
Message-ID: <20140819155125.GB2697@localhost>
References: <20140819043252.GA8798@localhost>
 <20140819142925.GB10146@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140819142925.GB10146@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 03:29:25PM +0100, Mel Gorman wrote:
> On Tue, Aug 19, 2014 at 12:32:52PM +0800, Fengguang Wu wrote:
> > Hi Mel,
> > 
> > We noticed the below vm-scalability performance/power regressions on
> > commit 3484b2de9499df23c4604a513b36f96326ae81ad ("mm: rearrange zone
> > fields into read-only, page alloc, statistics and page reclaim lines").
> > 
> > 24b7e5819ad5cbe  3484b2de9499df23c4604a513  testbox/testcase/testparams
> > ---------------  -------------------------  ---------------------------
> >      %stddev        %change               %stddev
> >             \          |                 /
> >       9.95 ± 2%     +69.1%      16.83 ± 5%  brickland3/vm-scalability/300s-lru-file-mmap-read
> >       2.32 ± 6%    +229.4%       7.63 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
> >      12.27 ± 3%     +99.4%      24.46 ± 5%  TOTAL vm-scalability.stddev
> > 
> > 24b7e5819ad5cbe  3484b2de9499df23c4604a513  
> > ---------------  -------------------------  
> >   13882598 ± 0%     -35.8%    8915310 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
> >   36379953 ± 1%     -64.0%   13093373 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
> >   50262551 ± 0%     -56.2%   22008683 ± 0%  TOTAL vm-scalability.throughput
> > 
> 
> 
> What units are these? It's completely unclear what is good and bad from the
> figures. 300s-lru-file-mmap-read appears multiple times in this report,
> each with different numbers beside them but little clue as to what they
> mean or what I'm meant to be looking for :(

Sorry the output format is a bit obscure: the stats names are after
the "TOTAL" word, such as TOTAL vm-scalability.stddev, TOTAL
vm-scalability.throughput, ...

> This is the same patch that was reported as having a performance gain in
> another set of tests from lkp so am a little confused.

That can happen some times -- we've seen some commits to benefit some
workloads while hurting some others. I'm now running more complete
test set for the commit, hopefully can get some results tomorrow.

> More importantly, as this patch is primary abougt cache misses it should
> be very unlikely that it makes a noticable difference to IO as the
> relative cost of a cache miss is so low. Similarly any difference it
> makes to reclaim activity is likely to be a coincidence or due to test
> variance.

The test case creates tmpfs files and read them fast to exercise the LRU.
So it's VM test and do not involve disk IO.

Thanks,
Fengguang
