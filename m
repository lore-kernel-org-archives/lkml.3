Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaGaJBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:01:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:56507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbaGaJBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:01:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="581611877"
Date: Thu, 31 Jul 2014 17:01:30 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [mm] b72fd1470c9: -41.7%
 perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page
Message-ID: <20140731090130.GB23367@aaronlu.sh.intel.com>
References: <20140731055035.GB19742@aaronlu.sh.intel.com>
 <20140731084832.GP10819@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731084832.GP10819@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:48:32AM +0100, Mel Gorman wrote:
> On Thu, Jul 31, 2014 at 01:50:35PM +0800, Aaron Lu wrote:
> > FYI, we noticed the below changes on
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > commit b72fd1470c9735f53485d089aa918dc327a86077 ("mm: rearrange zone fields into read-only, page alloc, statistics and page reclaim lines")
> > 
> > test case: lkp-st02/dd-write/5m-11HDD-JBOD-cfq-xfs-10dd
> > 
> > e28c951ff01a805  b72fd1470c9735f53485d089a  
> > ---------------  -------------------------  
> >       1.06 ~ 6%     -41.7%       0.62 ~ 3%  TOTAL perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page
> >       1.34 ~ 2%     -19.8%       1.07 ~ 2%  TOTAL perf-profile.cpu-cycles.__block_write_begin.xfs_vm_write_begin.generic_perform_write.xfs_file_buffered_aio_write.xfs_file_write_iter
> >       1.19 ~ 5%     -12.1%       1.05 ~ 4%  TOTAL perf-profile.cpu-cycles.copy_from_user_atomic_iovec.iov_iter_copy_from_user_atomic.generic_perform_write.xfs_file_buffered_aio_write.xfs_file_write_iter
> >       2.78 ~ 1%     -16.3%       2.32 ~ 4%  TOTAL perf-profile.cpu-cycles.__clear_user.read_zero.read_zero.vfs_read.sys_read
> >   2.96e+09 ~ 4%      -5.2%  2.806e+09 ~ 0%  TOTAL perf-stat.cache-misses
> >   3.86e+12 ~ 5%      -5.2%  3.658e+12 ~ 1%  TOTAL perf-stat.ref-cycles
> > 
> > Legend:
> > 	~XX%    - stddev percent
> > 	[+-]XX% - change percent
> > 
> 
> I'm not exactly sure what I'm reading here. I think it is reporting on cpu
> cycles and cache misses used in various kernel functions. It's not clear what
> the units are but it looks like percentages of overall cycles spent in the
> reported functions. That may or may not be good depending on whether there
> is a higher cost elsewhere pushing the percentages down but that detail
> is not in the report. It looks like this is reporting that fewer clock
> cycles are being spent and incurring fewer cache misses. What is the problem?

LKP does not report problems only, it will also report commits that make
things better :-)

>From the perf-stat.cache-misses, I think it is indicating your commit
does something for good.

Thanks,
Aaron
