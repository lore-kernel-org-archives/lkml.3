Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078AbaDJNRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:17:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:13109 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161042AbaDJNRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:17:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="510893441"
Date: Thu, 10 Apr 2014 21:17:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        lkp@01.org
Subject: Re: [writeback] 6903673566d: +2.5% fileio.requests_per_sec
Message-ID: <20140410131700.GA20102@localhost>
References: <20140410124137.GA17720@localhost>
 <20140410130821.GB17871@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410130821.GB17871@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:08:21PM +0800, Fengguang Wu wrote:
> On Thu, Apr 10, 2014 at 08:41:37PM +0800, Fengguang Wu wrote:
> > Hi Jan,
> > 
> > I tried your writeback dirty list patchset and noticed some ups/downs.
> > The main performance changes are
> > 
> > 1) +2.5% fileio.requests_per_sec
> > 2) -7.1% iostat.md0.wkB/s
> > 
> > git://bee.sh.intel.com/git/wfg/linux-devel.git jan-dirty-list
> > commit 6903673566d0289680e593dac088c787d119b067 ("writeback: Replace several writeback lists with inode tagging")
> > 
> > 836ecc5f024669e  6903673566d0289680e593dac  
> > ---------------  -------------------------  
> >       6526 ~ 0%      +3.2%       6736 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
> >       6441 ~ 0%      +1.8%       6558 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
> >      12968 ~ 0%      +2.5%      13295 ~ 0%  TOTAL fileio.requests_per_sec
> > 
> > 836ecc5f024669e  6903673566d0289680e593dac  
> > ---------------  -------------------------  
> >     398147 ~ 0%      -7.1%     369866 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
> >     398147 ~ 0%      -7.1%     369866 ~ 0%  TOTAL iostat.md0.wkB/s
> 
> Here are the complete power performance comparisons:
> 
> # the higher index, the better
>     98      perf-index  ea87e2e7e0905325c58cf5643
>    105     power-index  ea87e2e7e0905325c58cf5643
>     99   latency-index  ea87e2e7e0905325c58cf5643

Note that some few performance changes are caused by CPU frequency
unstableness. Sorry for showing results with some defects - I only
realized that after reading through the results..

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1.12 ~ 0%      -0.4%       1.12       brickland1/micro/will-it-scale/brk1
      1.14 ~ 0%      +2.0%       1.16       brickland1/micro/will-it-scale/context_switch1
      1.15 ~ 1%      +0.6%       1.16       brickland1/micro/will-it-scale/eventfd1
      1.23 ~ 2%      +7.6%       1.32       brickland1/micro/will-it-scale/futex1
      1.24 ~ 4%      -4.2%       1.19       brickland1/micro/will-it-scale/futex2
      1.15 ~ 1%      -0.1%       1.15       brickland1/micro/will-it-scale/futex3
      1.18 ~ 3%      -4.2%       1.13       brickland1/micro/will-it-scale/futex4
      1.14 ~ 1%      -0.6%       1.13       brickland1/micro/will-it-scale/getppid1
      1.09 ~14%      +5.6%       1.15       brickland1/micro/will-it-scale/lock1
      1.13 ~ 1%      +1.9%       1.15       brickland1/micro/will-it-scale/lseek1
      1.18 ~ 2%      +3.6%       1.22       brickland1/micro/will-it-scale/malloc1
      1.13 ~ 0%      +0.6%       1.14       brickland1/micro/will-it-scale/malloc2
      1.21 ~ 1%      +2.3%       1.24       brickland1/micro/will-it-scale/mmap1
      1.18 ~ 1%      +6.6%       1.26       brickland1/micro/will-it-scale/mmap2
      1.10 ~15%      +5.8%       1.16       brickland1/micro/will-it-scale/open1
      1.11 ~15%      +4.9%       1.16       brickland1/micro/will-it-scale/open2
      1.08 ~13%      +4.2%       1.13       brickland1/micro/will-it-scale/page_fault1
      1.08 ~14%      +5.8%       1.14       brickland1/micro/will-it-scale/page_fault2
      1.09 ~14%      +5.0%       1.14       brickland1/micro/will-it-scale/page_fault3
      1.08 ~14%      +4.2%       1.13       brickland1/micro/will-it-scale/pipe1
      1.09 ~15%      +5.6%       1.15       brickland1/micro/will-it-scale/poll1
      1.07 ~14%      +5.2%       1.13       brickland1/micro/will-it-scale/poll2
      1.09 ~14%      +4.9%       1.14       brickland1/micro/will-it-scale/posix_semaphore1
      1.07 ~14%     +10.8%       1.19       brickland1/micro/will-it-scale/pread1
      1.12 ~15%      +4.5%       1.17       brickland1/micro/will-it-scale/pread2
      1.08 ~14%      +5.3%       1.14       brickland1/micro/will-it-scale/pthread_mutex1
      1.08 ~14%      +4.3%       1.13       brickland1/micro/will-it-scale/pthread_mutex2
      1.09 ~14%      +4.0%       1.13       brickland1/micro/will-it-scale/pwrite1
      1.07 ~14%      +5.1%       1.12       brickland1/micro/will-it-scale/pwrite2
      1.07 ~14%      +8.2%       1.16       brickland1/micro/will-it-scale/read1
      1.07 ~14%      +5.3%       1.13       brickland1/micro/will-it-scale/read2
      1.09 ~14%      +6.4%       1.16       brickland1/micro/will-it-scale/readseek
      1.14 ~ 0%      +0.4%       1.14       brickland1/micro/will-it-scale/sched_yield
      1.36 ~ 5%      +1.3%       1.38       brickland1/micro/will-it-scale/signal1
      1.15 ~ 2%      -2.4%       1.12       brickland1/micro/will-it-scale/unix1
      1.11 ~ 0%      +1.5%       1.13       brickland1/micro/will-it-scale/unlink1
      1.18 ~ 1%      +0.8%       1.19       brickland1/micro/will-it-scale/unlink2
      1.13 ~ 0%      +0.2%       1.13       brickland1/micro/will-it-scale/write1
      1.15 ~ 1%      +0.6%       1.16       brickland1/micro/will-it-scale/writeseek
      0.63           +0.0%       0.63       brickland2/micro/vm-scalability/300s-anon-cow-rand-64G
      0.63           +0.0%       0.63       brickland2/micro/vm-scalability/300s-anon-cow-rand-mt-64G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-anon-cow-seq-1T
      0.64           -1.6%       0.63       brickland2/micro/vm-scalability/300s-anon-cow-seq-mt-1T
      0.94 ~27%     -28.7%       0.67       brickland2/micro/vm-scalability/300s-anon-r-rand-mt
      0.88 ~28%     -29.1%       0.62       brickland2/micro/vm-scalability/300s-anon-r-rand
      0.94 ~28%     -28.3%       0.67       brickland2/micro/vm-scalability/300s-anon-r-seq-mt
      0.87 ~28%     -28.7%       0.62       brickland2/micro/vm-scalability/300s-anon-r-seq
      0.92 ~31%     -31.1%       0.63       brickland2/micro/vm-scalability/300s-anon-rx-rand-mt
      0.88 ~28%     -28.0%       0.63       brickland2/micro/vm-scalability/300s-anon-rx-seq-mt
      0.63           +0.0%       0.63       brickland2/micro/vm-scalability/300s-anon-w-rand-64G
      0.63           +0.0%       0.63       brickland2/micro/vm-scalability/300s-anon-w-rand-mt-64G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-anon-w-seq-1T
      0.66           +0.0%       0.66       brickland2/micro/vm-scalability/300s-anon-w-seq-mt-64G
      0.63           +0.0%       0.63       brickland2/micro/vm-scalability/300s-anon-wx-rand-mt-64G
      0.88 ~28%     -28.0%       0.63       brickland2/micro/vm-scalability/300s-lru-file-mmap-read-rand
      0.89 ~28%     -28.8%       0.63       brickland2/micro/vm-scalability/300s-lru-file-mmap-read
      0.63 ~ 0%      +0.0%       0.63       brickland2/micro/vm-scalability/300s-lru-file-readonce
      0.92 ~31%     -31.1%       0.63       brickland2/micro/vm-scalability/300s-lru-file-readtwice
      0.61           +0.0%       0.61       brickland2/micro/vm-scalability/300s-lru-shm-128G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-lru-shm-rand-64G
      0.87 ~28%     -28.7%       0.62       brickland2/micro/vm-scalability/300s-mmap-pread-rand-mt
      0.92 ~32%     -32.2%       0.62       brickland2/micro/vm-scalability/300s-mmap-pread-rand
      0.94 ~28%     -28.3%       0.67       brickland2/micro/vm-scalability/300s-mmap-pread-seq-mt
      0.89 ~30%     -30.3%       0.62       brickland2/micro/vm-scalability/300s-mmap-pread-seq
      0.87 ~28%     -28.7%       0.62       brickland2/micro/vm-scalability/300s-mmap-xread-rand-mt
      0.88 ~27%     -27.3%       0.64       brickland2/micro/vm-scalability/300s-mmap-xread-seq-mt
      0.89 ~30%     -30.3%       0.62       brickland2/micro/vm-scalability/300s-mremap-xread-rand-mt
      0.63           +0.0%       0.63       brickland2/micro/vm-scalability/300s-msync-mt-64G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-remap-128G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-shm-pread-rand-16G
      0.67           +0.0%       0.67       brickland2/micro/vm-scalability/300s-shm-pread-rand-mt-16G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-shm-pread-seq-1T
      0.67           +0.0%       0.67       brickland2/micro/vm-scalability/300s-shm-pread-seq-mt-1T
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-shm-xread-rand-16G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-shm-xread-rand-mt-16G
      0.62           +0.0%       0.62       brickland2/micro/vm-scalability/300s-shm-xread-seq-1T
      0.63           -1.6%       0.62       brickland2/micro/vm-scalability/300s-shm-xread-seq-mt-1T
      0.89 ~27%     -27.7%       0.64       brickland2/micro/vm-scalability/300s-small-allocs-mt
      0.87 ~28%     -28.7%       0.62       brickland2/micro/vm-scalability/300s-small-allocs
      0.61           +0.0%       0.61       brickland2/micro/vm-scalability/300s-truncate-16G
      2.44           +0.0%       2.44       grantley/micro/kbuild/200%-1HDD-ext4
      2.44 ~ 0%      -0.0%       2.44       grantley/micro/kbuild/200%
      2.08           +0.0%       2.08       grantley/micro/kbuild/50%-1HDD-ext4
      2.08           +0.0%       2.08       grantley/micro/kbuild/50%
      2.26           +0.0%       2.26       lkp-nex04/micro/ebizzy/200%-100-10
      3.34           -0.3%       3.33       lkp-sb03/micro/nepim/300s-100%-tcp
      3.31           +0.6%       3.33       lkp-sb03/micro/nepim/300s-100%-tcp6
      3.49           -3.2%       3.38       lkp-sb03/micro/nepim/300s-100%-udp
      3.49           -2.6%       3.40       lkp-sb03/micro/nepim/300s-100%-udp6
      3.47           -4.0%       3.33       lkp-sb03/micro/nepim/300s-25%-tcp
      3.36           +0.0%       3.36       lkp-sb03/micro/nepim/300s-25%-tcp6
      3.49           +0.0%       3.49       lkp-sb03/micro/nepim/300s-25%-udp
      3.49           +0.0%       3.49       lkp-sb03/micro/nepim/300s-25%-udp6
      3.34 ~ 0%      +0.2%       3.35       lkp-sb03/micro/nuttcp/300s
      3.08 ~ 0%      +0.2%       3.09       lkp-snb01/micro/hackbench/1600%-process-pipe
      3.09 ~ 0%      +0.0%       3.09       lkp-snb01/micro/hackbench/1600%-process-socket
      3.09 ~ 0%      +0.0%       3.09       lkp-snb01/micro/hackbench/1600%-threads-pipe
      3.09 ~ 0%      +0.0%       3.09       lkp-snb01/micro/hackbench/1600%-threads-socket
      3.09 ~ 0%      +0.0%       3.09       lkp-snb01/micro/hackbench/50%-process-pipe
      3.09 ~ 0%      +0.0%       3.09       lkp-snb01/micro/hackbench/50%-process-socket
      3.09 ~ 0%      +0.0%       3.09       lkp-snb01/micro/hackbench/50%-threads-pipe
      3.09 ~ 0%      +0.0%       3.09       lkp-snb01/micro/hackbench/50%-threads-socket
      2.80 ~ 0%      -0.0%       2.80       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      2.78 ~ 0%      -0.0%       2.78       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      2.76 ~ 0%      +0.2%       2.77 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      2.80 ~ 0%      -0.0%       2.80       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-100dd
      2.76 ~ 0%      -0.1%       2.76       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      2.72 ~ 0%      -1.1%       2.69       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-1dd
      2.78 ~ 0%      +0.4%       2.79       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-100dd
      2.76 ~ 0%      +0.1%       2.76       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd
      2.69 ~ 0%      -0.4%       2.68       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-1dd
      2.73 ~ 0%      -0.2%       2.72       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      2.66 ~ 0%      -1.1%       2.63       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      2.69 ~ 0%      +0.1%       2.69       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-1dd
      2.70 ~ 3%      +8.6%       2.93 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      3.51 ~ 0%      -3.7%       3.38       nhm8/micro/dbench/100%
      1.79 ~ 0%      +0.1%       1.79       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndrd-sync
      2.93 ~ 0%      +0.0%       2.93       xps2/micro/pigz/100%
    185.24           -2.0%     181.62       TOTAL turbostat.GHz
