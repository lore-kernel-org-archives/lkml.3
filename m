Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161081AbaDJNJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:09:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:29657 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030658AbaDJNJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="510888241"
Date: Thu, 10 Apr 2014 21:08:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        lkp@01.org
Subject: Re: [writeback] 6903673566d: +2.5% fileio.requests_per_sec
Message-ID: <20140410130821.GB17871@localhost>
References: <20140410124137.GA17720@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410124137.GA17720@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:41:37PM +0800, Fengguang Wu wrote:
> Hi Jan,
> 
> I tried your writeback dirty list patchset and noticed some ups/downs.
> The main performance changes are
> 
> 1) +2.5% fileio.requests_per_sec
> 2) -7.1% iostat.md0.wkB/s
> 
> git://bee.sh.intel.com/git/wfg/linux-devel.git jan-dirty-list
> commit 6903673566d0289680e593dac088c787d119b067 ("writeback: Replace several writeback lists with inode tagging")
> 
> 836ecc5f024669e  6903673566d0289680e593dac  
> ---------------  -------------------------  
>       6526 ~ 0%      +3.2%       6736 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
>       6441 ~ 0%      +1.8%       6558 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
>      12968 ~ 0%      +2.5%      13295 ~ 0%  TOTAL fileio.requests_per_sec
> 
> 836ecc5f024669e  6903673566d0289680e593dac  
> ---------------  -------------------------  
>     398147 ~ 0%      -7.1%     369866 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
>     398147 ~ 0%      -7.1%     369866 ~ 0%  TOTAL iostat.md0.wkB/s

Here are the complete power performance comparisons:

# the higher index, the better
    98      perf-index  ea87e2e7e0905325c58cf5643
   105     power-index  ea87e2e7e0905325c58cf5643
    99   latency-index  ea87e2e7e0905325c58cf5643

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1193524           +8.9%    1299790       brickland2/micro/vm-scalability/300s-anon-cow-rand-64G
   2059999           -0.9%    2041914       brickland2/micro/vm-scalability/300s-anon-cow-rand-mt-64G
  10839519           -2.1%   10608884       brickland2/micro/vm-scalability/300s-anon-cow-seq-1T
  26035343          +22.6%   31908627       brickland2/micro/vm-scalability/300s-anon-cow-seq-mt-1T
   1814424 ~ 0%      -0.3%    1808366       brickland2/micro/vm-scalability/300s-anon-r-rand-mt
   3321379 ~14%     -14.9%    2824943       brickland2/micro/vm-scalability/300s-anon-r-rand
  10737450 ~ 8%     -13.4%    9300338       brickland2/micro/vm-scalability/300s-anon-r-seq-mt
  56930858 ~31%     -31.0%   39271193       brickland2/micro/vm-scalability/300s-anon-r-seq
   3895406 ~10%      -6.5%    3641748       brickland2/micro/vm-scalability/300s-anon-rx-rand-mt
   2815440 ~13%     -13.2%    2443920       brickland2/micro/vm-scalability/300s-anon-rx-seq-mt
   1744586           +0.5%    1752816       brickland2/micro/vm-scalability/300s-anon-w-rand-64G
   1485732           +0.5%    1493516       brickland2/micro/vm-scalability/300s-anon-w-rand-mt-64G
  23398782           -2.7%   22776628       brickland2/micro/vm-scalability/300s-anon-w-seq-1T
   6179895           -0.9%    6126126       brickland2/micro/vm-scalability/300s-anon-w-seq-mt-64G
   2050178           +8.8%    2230773       brickland2/micro/vm-scalability/300s-anon-wx-rand-mt-64G
    730440           -0.0%     730200       brickland2/micro/vm-scalability/300s-anon-wx-seq-mt-1T
   1753278 ~ 1%      -2.7%    1705762       brickland2/micro/vm-scalability/300s-lru-file-mmap-read-rand
   3548596 ~15%     -15.9%    2984023       brickland2/micro/vm-scalability/300s-lru-file-mmap-read
   2094887 ~ 0%      -0.3%    2088757       brickland2/micro/vm-scalability/300s-lru-file-readonce
   5288504 ~33%     -33.0%    3542054       brickland2/micro/vm-scalability/300s-lru-file-readtwice
  26681167           -1.5%   26273119       brickland2/micro/vm-scalability/300s-lru-shm-128G
   1352290           +2.7%    1388276       brickland2/micro/vm-scalability/300s-lru-shm-rand-64G
   1582183 ~ 4%     +10.1%    1742202       brickland2/micro/vm-scalability/300s-mmap-pread-rand-mt
   2530025 ~11%     -11.6%    2237193       brickland2/micro/vm-scalability/300s-mmap-pread-rand
   7963273 ~12%      -9.8%    7182114       brickland2/micro/vm-scalability/300s-mmap-pread-seq-mt
  38368788 ~37%     -39.9%   23048889       brickland2/micro/vm-scalability/300s-mmap-pread-seq
   1761540 ~ 1%      -0.3%    1755774       brickland2/micro/vm-scalability/300s-mmap-xread-rand-mt
  10933828 ~46%     -44.9%    6019920       brickland2/micro/vm-scalability/300s-mmap-xread-seq-mt
 3.384e+08 ~ 0%      +0.2%  3.391e+08       brickland2/micro/vm-scalability/300s-mremap-xread-rand-mt
   1291559           +1.6%    1311590       brickland2/micro/vm-scalability/300s-msync-mt-64G
   3555867           +4.8%    3728204       brickland2/micro/vm-scalability/300s-remap-128G
   3456703           +0.2%    3461950       brickland2/micro/vm-scalability/300s-shm-pread-rand-16G
   3294497           +0.2%    3299782       brickland2/micro/vm-scalability/300s-shm-pread-rand-mt-16G
  18343419           -1.6%   18056113       brickland2/micro/vm-scalability/300s-shm-pread-seq-1T
   8826997           -6.1%    8284733       brickland2/micro/vm-scalability/300s-shm-pread-seq-mt-1T
   3474590           -0.2%    3466782       brickland2/micro/vm-scalability/300s-shm-xread-rand-16G
   3277440           +0.5%    3294828       brickland2/micro/vm-scalability/300s-shm-xread-rand-mt-16G
  17871763           -0.3%   17818691       brickland2/micro/vm-scalability/300s-shm-xread-seq-1T
  11819716           -2.2%   11559350       brickland2/micro/vm-scalability/300s-shm-xread-seq-mt-1T
    221738 ~28%     -28.1%     159453       brickland2/micro/vm-scalability/300s-small-allocs-mt
   3334953 ~32%     -30.2%    2329160       brickland2/micro/vm-scalability/300s-small-allocs
 6.762e+08           -5.9%   6.36e+08       TOTAL vm-scalability.throughput

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    727.82 ~ 3%      +8.8%     791.84       brickland1/micro/will-it-scale/brk1
    507.58 ~ 2%      -0.7%     504.02       brickland1/micro/will-it-scale/context_switch1
   1205.64 ~ 1%      +0.6%    1212.98       brickland1/micro/will-it-scale/eventfd1
    666.91 ~ 2%      +5.8%     705.59       brickland1/micro/will-it-scale/futex1
    675.73 ~ 2%      +1.2%     683.64       brickland1/micro/will-it-scale/futex2
   1318.25 ~30%     -84.6%     203.10       brickland1/micro/will-it-scale/futex3
   1299.52 ~31%     -81.7%     237.83       brickland1/micro/will-it-scale/futex4
   1318.43 ~23%     -72.8%     358.46       brickland1/micro/will-it-scale/getppid1
   1029.00 ~18%     -34.0%     679.18       brickland1/micro/will-it-scale/lock1
   1304.56 ~11%     -76.5%     306.02       brickland1/micro/will-it-scale/lseek1
    204.65 ~ 1%      +2.1%     208.96       brickland1/micro/will-it-scale/malloc1
   1910.51 ~ 1%      +1.8%    1945.37       brickland1/micro/will-it-scale/malloc2
    199.50 ~ 1%      +0.9%     201.37       brickland1/micro/will-it-scale/mmap1
    195.08 ~ 1%      +5.0%     204.87       brickland1/micro/will-it-scale/mmap2
    740.77 ~14%      +7.3%     795.01       brickland1/micro/will-it-scale/open1
    742.22 ~15%      +8.0%     801.87       brickland1/micro/will-it-scale/open2
    419.75 ~13%      +4.0%     436.72       brickland1/micro/will-it-scale/page_fault1
    426.24 ~12%      +6.4%     453.69       brickland1/micro/will-it-scale/page_fault2
    494.03 ~13%      +3.6%     511.82       brickland1/micro/will-it-scale/page_fault3
   1169.21 ~14%      +6.7%    1247.89       brickland1/micro/will-it-scale/pipe1
   1423.79 ~15%      +6.0%    1508.78       brickland1/micro/will-it-scale/poll1
   1443.28 ~14%      +8.6%    1567.43       brickland1/micro/will-it-scale/poll2
    519.35 ~ 9%      +1.8%     528.65       brickland1/micro/will-it-scale/posix_semaphore1
   1627.45 ~11%      +0.3%    1632.45       brickland1/micro/will-it-scale/pread1
    217.45 ~12%      +4.4%     227.04       brickland1/micro/will-it-scale/pread2
    850.73 ~14%      +5.7%     899.39       brickland1/micro/will-it-scale/pthread_mutex1
   1083.32 ~15%      +5.8%    1146.68       brickland1/micro/will-it-scale/pthread_mutex2
   1381.38 ~15%      +5.7%    1459.67       brickland1/micro/will-it-scale/pwrite1
    484.41 ~ 8%      -8.4%     443.69       brickland1/micro/will-it-scale/pwrite2
   1143.32 ~15%      +2.7%    1174.07       brickland1/micro/will-it-scale/read1
    588.56 ~14%      +8.9%     641.00       brickland1/micro/will-it-scale/read2
   1478.60 ~12%      +5.6%    1561.00       brickland1/micro/will-it-scale/readseek
   1247.94 ~ 3%      +3.9%    1297.10       brickland1/micro/will-it-scale/sched_yield
    310.07 ~ 3%      -0.5%     308.53       brickland1/micro/will-it-scale/signal1
   1248.91 ~ 4%      -4.1%    1197.54       brickland1/micro/will-it-scale/unix1
    180.62 ~34%      -0.7%     179.37       brickland1/micro/will-it-scale/unlink1
    339.83 ~ 2%      +6.4%     361.52       brickland1/micro/will-it-scale/unlink2
   1219.38 ~ 0%      -0.3%    1215.65       brickland1/micro/will-it-scale/write1
   1389.61 ~ 2%      -3.2%    1345.16       brickland1/micro/will-it-scale/writeseek
    398.70           +2.8%     409.97       brickland2/micro/vm-scalability/300s-anon-cow-rand-64G
    398.85           +7.6%     429.08       brickland2/micro/vm-scalability/300s-anon-cow-rand-mt-64G
    441.56           +2.2%     451.41       brickland2/micro/vm-scalability/300s-anon-cow-seq-1T
    456.46          +11.1%     507.06       brickland2/micro/vm-scalability/300s-anon-cow-seq-mt-1T
    177.75 ~11%     -10.2%     159.55       brickland2/micro/vm-scalability/300s-anon-r-rand-mt
    494.00 ~16%     -16.7%     411.47       brickland2/micro/vm-scalability/300s-anon-r-rand
    409.63 ~ 9%     -12.1%     359.90       brickland2/micro/vm-scalability/300s-anon-r-seq-mt
   1332.45 ~38%     -38.3%     822.59       brickland2/micro/vm-scalability/300s-anon-r-seq
    512.37 ~ 5%      -3.8%     492.70       brickland2/micro/vm-scalability/300s-anon-rx-rand-mt
    483.40 ~ 0%      -0.6%     480.66       brickland2/micro/vm-scalability/300s-anon-rx-seq-mt
    449.67           +1.3%     455.43       brickland2/micro/vm-scalability/300s-anon-w-rand-64G
    273.69           -2.1%     268.03       brickland2/micro/vm-scalability/300s-anon-w-rand-mt-64G
    661.23           -0.6%     657.39       brickland2/micro/vm-scalability/300s-anon-w-seq-1T
    167.26           +0.7%     168.39       brickland2/micro/vm-scalability/300s-anon-w-seq-mt-64G
    461.64           +1.5%     468.45       brickland2/micro/vm-scalability/300s-anon-wx-rand-mt-64G
    476.92 ~14%     -13.8%     411.26       brickland2/micro/vm-scalability/300s-lru-file-mmap-read-rand
    585.97 ~16%     -17.7%     482.13       brickland2/micro/vm-scalability/300s-lru-file-mmap-read
    464.02 ~ 0%      -0.5%     461.53       brickland2/micro/vm-scalability/300s-lru-file-readonce
    523.67 ~11%     -11.9%     461.14       brickland2/micro/vm-scalability/300s-lru-file-readtwice
    132.25           +0.6%     133.00       brickland2/micro/vm-scalability/300s-lru-shm-128G
    226.65           +5.0%     237.93       brickland2/micro/vm-scalability/300s-lru-shm-rand-64G
    370.95 ~19%     -20.8%     293.64       brickland2/micro/vm-scalability/300s-mmap-pread-rand-mt
    429.04 ~17%     -17.2%     355.40       brickland2/micro/vm-scalability/300s-mmap-pread-rand
    319.46 ~15%     -15.1%     271.09       brickland2/micro/vm-scalability/300s-mmap-pread-seq-mt
    905.98 ~34%     -35.3%     586.51       brickland2/micro/vm-scalability/300s-mmap-pread-seq
    455.57 ~11%     -22.0%     355.47       brickland2/micro/vm-scalability/300s-mmap-xread-rand-mt
    541.86 ~13%     -13.3%     469.95       brickland2/micro/vm-scalability/300s-mmap-xread-seq-mt
    556.88 ~14%     -15.0%     473.44       brickland2/micro/vm-scalability/300s-mremap-xread-rand-mt
    309.70           +0.6%     311.51       brickland2/micro/vm-scalability/300s-msync-mt-64G
    194.81           -1.1%     192.72       brickland2/micro/vm-scalability/300s-remap-128G
    388.64           -0.5%     386.67       brickland2/micro/vm-scalability/300s-shm-pread-rand-16G
    102.90           +8.5%     111.61       brickland2/micro/vm-scalability/300s-shm-pread-rand-mt-16G
    576.40           -0.4%     574.33       brickland2/micro/vm-scalability/300s-shm-pread-seq-1T
    275.80           -3.1%     267.35       brickland2/micro/vm-scalability/300s-shm-pread-seq-mt-1T
    385.60           +0.4%     386.95       brickland2/micro/vm-scalability/300s-shm-xread-rand-16G
    372.72           +1.2%     377.03       brickland2/micro/vm-scalability/300s-shm-xread-rand-mt-16G
    573.73           +0.0%     573.87       brickland2/micro/vm-scalability/300s-shm-xread-seq-1T
    493.06           +0.1%     493.63       brickland2/micro/vm-scalability/300s-shm-xread-seq-mt-1T
    165.30 ~17%     -17.4%     136.53       brickland2/micro/vm-scalability/300s-small-allocs-mt
    386.38 ~24%     +40.0%     540.83       brickland2/micro/vm-scalability/300s-small-allocs
     50.36           +0.9%      50.79       brickland2/micro/vm-scalability/300s-truncate-16G
    141.92           -0.1%     141.71       grantley/micro/kbuild/200%-1HDD-ext4
    141.73 ~ 0%      +0.5%     142.44       grantley/micro/kbuild/200%
    116.55           -0.3%     116.21       grantley/micro/kbuild/50%-1HDD-ext4
    116.02           -0.5%     115.49       grantley/micro/kbuild/50%
     71.80           +0.2%      71.92       lkp-sb03/micro/nepim/300s-100%-tcp
     69.19           +0.9%      69.78       lkp-sb03/micro/nepim/300s-100%-tcp6
     82.00          -14.5%      70.07       lkp-sb03/micro/nepim/300s-100%-udp
     81.75          -14.7%      69.73       lkp-sb03/micro/nepim/300s-100%-udp6
     83.43          -14.5%      71.32       lkp-sb03/micro/nepim/300s-25%-tcp
     71.52           +0.2%      71.65       lkp-sb03/micro/nepim/300s-25%-tcp6
     81.74           +0.3%      82.01       lkp-sb03/micro/nepim/300s-25%-udp
     81.64           +0.5%      82.07       lkp-sb03/micro/nepim/300s-25%-udp6
     69.37 ~ 0%      +0.2%      69.53       lkp-sb03/micro/nuttcp/300s
    188.36 ~ 0%      +0.2%     188.76       lkp-snb01/micro/hackbench/1600%-process-pipe
    191.23 ~ 0%      -0.4%     190.49       lkp-snb01/micro/hackbench/1600%-process-socket
    198.03 ~ 0%      -0.2%     197.68       lkp-snb01/micro/hackbench/1600%-threads-pipe
    199.20 ~ 0%      -0.7%     197.85       lkp-snb01/micro/hackbench/1600%-threads-socket
    196.56 ~ 0%      -0.1%     196.35       lkp-snb01/micro/hackbench/50%-process-pipe
    196.24 ~ 0%      -0.0%     196.19       lkp-snb01/micro/hackbench/50%-process-socket
    199.15 ~ 0%      -0.7%     197.72       lkp-snb01/micro/hackbench/50%-threads-pipe
    197.18 ~ 0%      -0.3%     196.63       lkp-snb01/micro/hackbench/50%-threads-socket
      5.32 ~ 1%      +0.9%       5.37       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndrd-sync
  54896.61           -9.2%   49864.31       TOTAL turbostat.Pkg_W

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     14.91 ~ 0%      +0.0%      14.91       brickland1/micro/will-it-scale/brk1
     13.90 ~ 0%      +3.3%      14.36       brickland1/micro/will-it-scale/context_switch1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/eventfd1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/futex1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/futex2
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/futex3
     14.89 ~ 0%      -0.0%      14.89       brickland1/micro/will-it-scale/futex4
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/getppid1
     14.89 ~ 0%      +0.1%      14.90       brickland1/micro/will-it-scale/lock1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/lseek1
     14.91 ~ 0%      +0.0%      14.91       brickland1/micro/will-it-scale/malloc1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/malloc2
     14.91 ~ 0%      +0.0%      14.91       brickland1/micro/will-it-scale/mmap1
     14.91 ~ 0%      +0.0%      14.91       brickland1/micro/will-it-scale/mmap2
     15.11 ~ 0%      +0.1%      15.12       brickland1/micro/will-it-scale/open1
     15.10 ~ 0%      +0.2%      15.13       brickland1/micro/will-it-scale/open2
     17.06 ~ 3%      +0.6%      17.17       brickland1/micro/will-it-scale/page_fault1
     20.31 ~ 7%      +3.4%      21.00       brickland1/micro/will-it-scale/page_fault2
     14.94 ~ 0%      -0.0%      14.94       brickland1/micro/will-it-scale/page_fault3
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/pipe1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/poll1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/poll2
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/posix_semaphore1
     14.89 ~ 0%      -0.0%      14.89       brickland1/micro/will-it-scale/pread1
     14.93 ~ 0%      +0.0%      14.93       brickland1/micro/will-it-scale/pread2
     14.89 ~ 0%      -0.0%      14.89       brickland1/micro/will-it-scale/pthread_mutex1
     14.89 ~ 0%      +0.1%      14.90       brickland1/micro/will-it-scale/pthread_mutex2
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/pwrite1
     14.89 ~ 0%      -0.0%      14.89       brickland1/micro/will-it-scale/pwrite2
     14.89 ~ 0%      -0.0%      14.89       brickland1/micro/will-it-scale/read1
     14.92 ~ 0%      -0.1%      14.91       brickland1/micro/will-it-scale/read2
     14.89 ~ 0%      -0.0%      14.89       brickland1/micro/will-it-scale/readseek
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/sched_yield
     14.89 ~ 0%      -0.0%      14.89       brickland1/micro/will-it-scale/signal1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/unix1
     14.93 ~ 0%      -0.0%      14.92       brickland1/micro/will-it-scale/unlink1
     14.90 ~ 0%      -0.0%      14.90       brickland1/micro/will-it-scale/unlink2
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/write1
     14.89 ~ 0%      +0.0%      14.89       brickland1/micro/will-it-scale/writeseek
     15.78          -10.1%      14.19       brickland2/micro/vm-scalability/300s-anon-cow-rand-64G
     12.39           -0.8%      12.29       brickland2/micro/vm-scalability/300s-anon-cow-rand-mt-64G
     12.46           +0.6%      12.53       brickland2/micro/vm-scalability/300s-anon-cow-seq-1T
     12.14           -3.5%      11.72       brickland2/micro/vm-scalability/300s-anon-cow-seq-mt-1T
      8.75 ~ 0%      +0.1%       8.76       brickland2/micro/vm-scalability/300s-anon-r-rand-mt
      8.84 ~ 0%      -0.6%       8.78       brickland2/micro/vm-scalability/300s-anon-r-rand
      8.75 ~ 0%      +0.0%       8.75       brickland2/micro/vm-scalability/300s-anon-r-seq-mt
      8.75 ~ 0%      +0.0%       8.75       brickland2/micro/vm-scalability/300s-anon-r-seq
      8.75 ~ 0%      +0.0%       8.75       brickland2/micro/vm-scalability/300s-anon-rx-rand-mt
      8.75 ~ 0%      +0.0%       8.75       brickland2/micro/vm-scalability/300s-anon-rx-seq-mt
     17.57           +0.9%      17.72       brickland2/micro/vm-scalability/300s-anon-w-rand-64G
     13.77           -0.7%      13.68       brickland2/micro/vm-scalability/300s-anon-w-rand-mt-64G
     12.28           +2.0%      12.52       brickland2/micro/vm-scalability/300s-anon-w-seq-1T
      8.77           -0.1%       8.76       brickland2/micro/vm-scalability/300s-anon-w-seq-mt-64G
      8.75           +0.1%       8.76       brickland2/micro/vm-scalability/300s-anon-wx-rand-mt-64G
      8.93 ~ 0%      -0.6%       8.88       brickland2/micro/vm-scalability/300s-lru-file-mmap-read-rand
      8.86 ~ 0%      -0.8%       8.79       brickland2/micro/vm-scalability/300s-lru-file-mmap-read
      8.89 ~ 0%      +0.1%       8.90       brickland2/micro/vm-scalability/300s-lru-file-readonce
      9.53 ~ 4%      -4.5%       9.10       brickland2/micro/vm-scalability/300s-lru-file-readtwice
      8.86           +0.0%       8.86       brickland2/micro/vm-scalability/300s-lru-shm-128G
      8.97           -1.0%       8.88       brickland2/micro/vm-scalability/300s-lru-shm-rand-64G
      8.75 ~ 0%      +0.1%       8.76       brickland2/micro/vm-scalability/300s-mmap-pread-rand-mt
     10.46 ~16%     -16.2%       8.76       brickland2/micro/vm-scalability/300s-mmap-pread-rand
      9.61 ~ 8%      -8.8%       8.76       brickland2/micro/vm-scalability/300s-mmap-pread-seq-mt
     10.02 ~10%     -11.5%       8.87       brickland2/micro/vm-scalability/300s-mmap-pread-seq
      8.75 ~ 0%      -0.1%       8.75       brickland2/micro/vm-scalability/300s-mmap-xread-rand-mt
      8.79 ~ 0%      +0.0%       8.79       brickland2/micro/vm-scalability/300s-mmap-xread-seq-mt
      9.74 ~ 4%      -6.7%       9.09       brickland2/micro/vm-scalability/300s-mremap-xread-rand-mt
      8.80           +0.0%       8.80       brickland2/micro/vm-scalability/300s-msync-mt-64G
      8.84           -0.1%       8.83       brickland2/micro/vm-scalability/300s-remap-128G
      8.75           +0.0%       8.75       brickland2/micro/vm-scalability/300s-shm-pread-rand-16G
      8.77           +0.0%       8.77       brickland2/micro/vm-scalability/300s-shm-pread-rand-mt-16G
      8.88           +0.0%       8.88       brickland2/micro/vm-scalability/300s-shm-pread-seq-1T
      8.76           +0.0%       8.76       brickland2/micro/vm-scalability/300s-shm-pread-seq-mt-1T
      8.76           -0.1%       8.75       brickland2/micro/vm-scalability/300s-shm-xread-rand-16G
      8.79           +0.0%       8.79       brickland2/micro/vm-scalability/300s-shm-xread-rand-mt-16G
      8.88           +0.0%       8.88       brickland2/micro/vm-scalability/300s-shm-xread-seq-1T
      8.79           +0.0%       8.79       brickland2/micro/vm-scalability/300s-shm-xread-seq-mt-1T
      8.80 ~ 0%      +0.0%       8.80       brickland2/micro/vm-scalability/300s-small-allocs-mt
      8.80 ~ 0%      -0.3%       8.78       brickland2/micro/vm-scalability/300s-small-allocs
      8.77           +0.0%       8.77       brickland2/micro/vm-scalability/300s-truncate-16G
     12.65           -9.1%      11.50       grantley/micro/kbuild/200%-1HDD-ext4
     11.40 ~ 2%     +10.6%      12.61       grantley/micro/kbuild/200%
      8.64           -7.9%       7.96       grantley/micro/kbuild/50%-1HDD-ext4
      7.94           -5.8%       7.48       grantley/micro/kbuild/50%
   1029.69           -0.6%    1023.09       TOTAL turbostat.RAM_W

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      2.14 ~ 0%      +0.1%       2.14       lkp-a04/micro/netperf/300s-200%-SCTP_STREAM
     48.44 ~41%     -50.3%      24.08       lkp-a04/micro/netperf/900s-200%-SCTP_STREAM_MANY
    280.76 ~ 0%      -0.6%     279.04       lkp-a04/micro/netperf/900s-200%-TCP_MAERTS
    277.92 ~ 0%      -0.5%     276.44       lkp-a04/micro/netperf/900s-200%-TCP_STREAM
    609.26 ~ 3%      -4.5%     581.70       TOTAL netperf.Throughput_Mbps

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     34.61 ~ 0%      +0.2%      34.69       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndrd-sync
     33.90 ~ 0%      -0.5%      33.72       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndrw-sync
      0.03 ~ 0%      +0.0%       0.03       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      2.56 ~ 0%      +0.0%       2.56       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrd-sync
      0.04 ~ 0%      +0.0%       0.04       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync
      0.06 ~ 0%      +0.0%       0.06       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
     37.60 ~ 0%      +0.1%      37.62       snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrd-sync
     40.57 ~ 0%      +0.3%      40.68       snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndrw-sync
      0.02 ~ 0%      +0.0%       0.02       snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndwr-sync
      2.57 ~ 0%      +0.0%       2.57       snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrd-sync
      0.03 ~ 0%      +0.0%       0.03 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
      0.04 ~ 0%      +0.0%       0.04 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
    152.02 ~ 0%      +0.0%     152.06       TOTAL fileio.request_latency_95%_ms

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    249418 ~ 6%      -2.3%     243679       lkp-snb01/micro/hackbench/1600%-process-pipe
    158824 ~ 0%      -2.0%     155637       lkp-snb01/micro/hackbench/1600%-process-socket
    216465 ~ 3%      +1.4%     219484       lkp-snb01/micro/hackbench/1600%-threads-pipe
    164488 ~ 0%      -3.3%     158990       lkp-snb01/micro/hackbench/1600%-threads-socket
    136844 ~ 0%      +1.4%     138814       lkp-snb01/micro/hackbench/50%-process-pipe
    136781 ~ 0%      +4.7%     143245       lkp-snb01/micro/hackbench/50%-process-socket
    132993 ~ 0%      -2.6%     129573       lkp-snb01/micro/hackbench/50%-threads-pipe
    107699 ~ 0%      +6.6%     114823       lkp-snb01/micro/hackbench/50%-threads-socket
   1303516 ~ 2%      +0.1%    1304246       TOTAL hackbench.throughput

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     68.47 ~ 0%      -0.0%      68.44       xps2/micro/pigz/100%
     68.47 ~ 0%      -0.0%      68.44       TOTAL pigz.throughput

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      8392 ~ 0%      -1.8%       8239       nhm8/micro/dbench/100%
      8392 ~ 0%      -1.8%       8239       TOTAL dbench.throughput-MB/sec

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     11807           -5.0%      11221       lkp-nex04/micro/ebizzy/200%-100-10
     11807           -5.0%      11221       TOTAL ebizzy.throughput

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    671786           -1.0%     665130       lkp-sb03/micro/nepim/300s-100%-tcp
    640185           +2.5%     655892       lkp-sb03/micro/nepim/300s-100%-tcp6
   2048594          +39.8%    2864645       lkp-sb03/micro/nepim/300s-25%-tcp
   2734939           +0.8%    2755658       lkp-sb03/micro/nepim/300s-25%-tcp6
   6095506          +13.9%    6941327       TOTAL nepim.tcp.avg.kbps_in

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    671974           -1.0%     664986       lkp-sb03/micro/nepim/300s-100%-tcp
    640367           +2.5%     656073       lkp-sb03/micro/nepim/300s-100%-tcp6
   2048779          +39.8%    2864852       lkp-sb03/micro/nepim/300s-25%-tcp
   2735140           +0.8%    2755864       lkp-sb03/micro/nepim/300s-25%-tcp6
   6096261          +13.9%    6941777       TOTAL nepim.tcp.avg.kbps_out

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    133570          +63.5%     218380       lkp-sb03/micro/nepim/300s-100%-udp
    121428          +59.2%     193308       lkp-sb03/micro/nepim/300s-100%-udp6
    574674           +0.0%     574843       lkp-sb03/micro/nepim/300s-25%-udp
    519455           -1.4%     512438       lkp-sb03/micro/nepim/300s-25%-udp6
   1349129          +11.1%    1498971       TOTAL nepim.udp.avg.kbps_in

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    175444          +35.9%     238505       lkp-sb03/micro/nepim/300s-100%-udp
    139381          +38.7%     193318       lkp-sb03/micro/nepim/300s-100%-udp6
    640781           -3.0%     621650       lkp-sb03/micro/nepim/300s-25%-udp
    521341           +0.5%     523779       lkp-sb03/micro/nepim/300s-25%-udp6
   1476949           +6.8%    1577254       TOTAL nepim.udp.avg.kbps_out

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
  39437466 ~ 3%      +6.4%   41950249       lkp-a06/micro/qperf/600s
  39437466 ~ 3%      +6.4%   41950249       TOTAL qperf.sctp.bw

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
 2.705e+08 ~ 0%      -1.4%  2.669e+08       lkp-a06/micro/qperf/600s
 2.705e+08 ~ 0%      -1.4%  2.669e+08       TOTAL qperf.tcp.bw

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
 2.647e+08 ~ 0%      +1.0%  2.673e+08       lkp-a06/micro/qperf/600s
 2.647e+08 ~ 0%      +1.0%  2.673e+08       TOTAL qperf.udp.recv_bw

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
 2.701e+08 ~ 0%      +1.0%  2.728e+08       lkp-a06/micro/qperf/600s
 2.701e+08 ~ 0%      +1.0%  2.728e+08       TOTAL qperf.udp.send_bw

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    126792 ~ 0%      -0.8%     125820       lkp-a06/micro/qperf/600s
    126792 ~ 0%      -0.8%     125820       TOTAL qperf.sctp.latency

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     94015 ~ 0%      +0.6%      94623       lkp-a06/micro/qperf/600s
     94015 ~ 0%      +0.6%      94623       TOTAL qperf.tcp.latency

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     77865 ~ 0%      +0.9%      78587       lkp-a06/micro/qperf/600s
     77865 ~ 0%      +0.9%      78587       TOTAL qperf.udp.latency

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     50103 ~ 1%      -1.3%      49450       lkp-sb03/micro/nuttcp/300s
     50103 ~ 1%      -1.3%      49450       TOTAL nuttcp.throughput_Mbps
