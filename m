Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaCNGQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:16:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:20783 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbaCNGQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:16:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,652,1389772800"; 
   d="scan'208";a="491745963"
Date: Fri, 14 Mar 2014 14:16:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] INFO: possible recursive locking detected
Message-ID: <20140314061643.GA28194@localhost>
References: <20140303142526.GA8517@localhost>
 <5321618F.3090801@linaro.org>
 <20140313085341.GC27627@localhost>
 <5321739B.1000506@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5321739B.1000506@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

Here are the test results for branch alexshi/single-balance

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       100 ~ 0%     +69.7%        170 ~ 0%  lkp-nex04/micro/ebizzy/200%-100-10
       100 ~ 0%     +69.7%        170 ~ 0%  TOTAL ebizzy.throughput.per_thread.max

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
        70 ~ 0%     -24.1%         53 ~ 2%  lkp-nex04/micro/ebizzy/200%-100-10
        70 ~ 0%     -24.1%         53 ~ 2%  TOTAL ebizzy.throughput.per_thread.min

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      8259 ~ 0%     -21.1%       6513 ~ 0%  nhm8/micro/dbench/100%
      8259 ~ 0%     -21.1%       6513 ~ 0%  TOTAL dbench.throughput-MB/sec

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       273 ~ 0%     -12.2%        239 ~ 0%  lkp-a06/micro/qperf/600s
       273 ~ 0%     -12.2%        239 ~ 0%  TOTAL qperf.udp_bw.send_bw.MB_sec

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       266 ~ 0%     -11.5%        236 ~ 1%  lkp-a06/micro/qperf/600s
       266 ~ 0%     -11.5%        236 ~ 1%  TOTAL qperf.udp_bw.recv_bw.MB_sec

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1305 ~ 0%      -1.6%       1284 ~ 0%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
      1305 ~ 0%      -1.6%       1284 ~ 0%  TOTAL netperf.Throughput_tps

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
         0 ~ 0%      +Inf%         15 ~37%  xps2/micro/pigz/100%
         0 ~ 0%      +Inf%         15 ~37%  TOTAL cpuidle.POLL.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
         0 ~ 0%      +Inf%          1 ~35%  xps2/micro/pigz/100%
         0 ~ 0%      +Inf%          1 ~35%  TOTAL cpuidle.POLL.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       652 ~ 8%  +12247.8%      80606 ~37%  lkp-a06/micro/qperf/600s
       652 ~ 8%  +12247.8%      80606 ~37%  TOTAL interrupts.46:PCI-MSI-edge.eth0-rx-0

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
 2.076e+08 ~ 2%     -38.8%  1.271e+08 ~ 4%  lkp-a06/micro/qperf/600s
 2.076e+08 ~ 2%     -38.8%  1.271e+08 ~ 4%  TOTAL cpuidle.C1.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       272 ~28%     -77.7%         60 ~33%  nhm8/micro/dbench/100%
       272 ~28%     -77.7%         60 ~33%  TOTAL cpuidle.C1E-NHM.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    150897 ~17%    +170.9%     408742 ~25%  xps2/micro/pigz/100%
    150897 ~17%    +170.9%     408742 ~25%  TOTAL cpuidle.C1-NHM.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       396 ~ 8%     +44.0%        570 ~15%  xps2/micro/pigz/100%
       396 ~ 8%     +44.0%        570 ~15%  TOTAL cpuidle.C1-NHM.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    142164 ~38%    +134.0%     332734 ~13%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
    107420 ~11%     +60.7%     172632 ~34%  lkp-a04/micro/netperf/120s-200%-SCTP_STREAM
  52277488 ~ 4%     -27.7%   37785333 ~ 3%  lkp-a06/micro/qperf/600s
  52527073 ~ 5%     -27.1%   38290700 ~ 3%  TOTAL cpuidle.C2.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       259 ~12%     +40.6%        365 ~20%  lkp-a04/micro/netperf/120s-200%-SCTP_STREAM
       259 ~12%     +40.6%        365 ~20%  TOTAL cpuidle.C2.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     17249 ~44%    +234.0%      57611 ~37%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
    115242 ~18%     +42.2%     163908 ~20%  lkp-a04/micro/netperf/120s-200%-SCTP_STREAM
     15808 ~33%    +323.3%      66910 ~31%  lkp-a04/micro/netperf/120s-200%-TCP_CRR
     21121 ~42%    +194.6%      62220 ~39%  lkp-a04/micro/netperf/120s-200%-TCP_RR
  10201776 ~14%     -44.2%    5690345 ~32%  lkp-a06/micro/qperf/600s
  10371197 ~14%     -41.8%    6040996 ~31%  TOTAL cpuidle.C3.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     13692 ~ 2%    +115.8%      29549 ~ 1%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
     15001 ~ 2%     +33.6%      20043 ~ 4%  lkp-a04/micro/netperf/120s-200%-SCTP_STREAM
     14224 ~ 6%    +105.2%      29188 ~ 1%  lkp-a04/micro/netperf/120s-200%-SCTP_STREAM_MANY
     13113 ~ 2%    +142.4%      31788 ~10%  lkp-a04/micro/netperf/120s-200%-TCP_CRR
     13398 ~ 3%    +121.7%      29701 ~ 1%  lkp-a04/micro/netperf/120s-200%-TCP_RR
     13536 ~ 3%    +114.7%      29056 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
     13358 ~ 2%    +118.8%      29228 ~ 2%  lkp-a04/micro/netperf/120s-200%-UDP_RR
     48281 ~ 2%     +84.3%      89003 ~ 1%  lkp-a06/micro/qperf/600s
    442360 ~ 5%     -67.9%     142104 ~ 7%  lkp-nex04/micro/ebizzy/200%-100-10
     42185 ~ 1%    +127.7%      96035 ~ 0%  nhm8/micro/dbench/100%
     12519 ~ 1%    +216.1%      39573 ~ 0%  xps2/micro/pigz/100%
    641672 ~ 4%     -11.9%     565273 ~ 3%  TOTAL softirqs.SCHED

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
        19 ~35%    +135.6%         45 ~39%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
        13 ~39%    +132.3%         30 ~47%  lkp-a04/micro/netperf/120s-200%-TCP_RR
         9 ~35%     +81.8%         18 ~43%  lkp-a04/micro/netperf/120s-200%-UDP_RR
        42 ~36%    +122.0%         93 ~42%  TOTAL cpuidle.C3.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       804 ~ 3%     +76.0%       1416 ~ 2%  xps2/micro/pigz/100%
       804 ~ 3%     +76.0%       1416 ~ 2%  TOTAL cpuidle.C6-NHM.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       294 ~19%     -27.5%        213 ~14%  nhm-white/sysbench/oltp/600s-100%-1000000
       294 ~19%     -27.5%        213 ~14%  TOTAL slabinfo.kmem_cache_node.active_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       294 ~19%     -27.5%        213 ~14%  nhm-white/sysbench/oltp/600s-100%-1000000
       294 ~19%     -27.5%        213 ~14%  TOTAL slabinfo.kmem_cache_node.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     70129 ~ 8%     +92.8%     135238 ~ 3%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
      9767 ~16%     +85.7%      18135 ~13%  lkp-a04/micro/netperf/120s-200%-TCP_RR
      6958 ~ 7%     +84.1%      12811 ~17%  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
     11628 ~22%     +57.4%      18299 ~10%  lkp-a04/micro/netperf/120s-200%-UDP_RR
   1359067 ~ 4%     -27.3%     988271 ~ 6%  lkp-a06/micro/qperf/600s
     13337 ~ 0%     +18.7%      15838 ~ 0%  nhm8/micro/dbench/100%
   1470889 ~ 4%     -19.2%    1188592 ~ 6%  TOTAL interrupts.RES

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    377510 ~ 6%     +52.0%     573994 ~ 5%  xps2/micro/pigz/100%
    377510 ~ 6%     +52.0%     573994 ~ 5%  TOTAL cpuidle.C3-NHM.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      0.89 ~15%     +39.3%       1.24 ~12%  lkp-a04/micro/netperf/120s-200%-SCTP_STREAM
      0.89 ~15%     +39.3%       1.24 ~12%  TOTAL perf-profile.cpu-cycles._dl_addr

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      3.38 ~ 0%     -32.0%       2.30 ~ 0%  nhm8/micro/dbench/100%
      3.38 ~ 0%     -32.0%       2.30 ~ 0%  TOTAL turbostat.GHz

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      8.47 ~ 0%     -29.0%       6.01 ~ 1%  nhm8/micro/dbench/100%
      8.47 ~ 0%     -29.0%       6.01 ~ 1%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.generic_file_buffered_write.__generic_file_aio_write.generic_file_aio_write.do_sync_write

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
        59 ~10%     -30.3%         41 ~ 4%  nhm8/micro/dbench/100%
        59 ~10%     -30.3%         41 ~ 4%  TOTAL turbostat.CTMP

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       197 ~ 3%     +44.9%        286 ~24%  lkp-a04/micro/netperf/120s-200%-TCP_RR
       878 ~ 0%     +31.3%       1153 ~17%  nhm8/micro/dbench/100%
      1076 ~ 0%     +33.8%       1439 ~18%  TOTAL uptime.idle

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     18.12 ~ 0%     -26.8%      13.26 ~ 0%  nhm8/micro/dbench/100%
     18.12 ~ 0%     -26.8%      13.26 ~ 0%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.generic_file_aio_read.do_sync_read.vfs_read.sys_pread64

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     83961 ~ 1%     -23.3%      64373 ~ 0%  nhm8/micro/dbench/100%
     83961 ~ 1%     -23.3%      64373 ~ 0%  TOTAL slabinfo.kmalloc-256.active_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      2641 ~ 1%     -23.3%       2027 ~ 0%  nhm8/micro/dbench/100%
      2641 ~ 1%     -23.3%       2027 ~ 0%  TOTAL slabinfo.kmalloc-256.active_slabs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      2641 ~ 1%     -23.3%       2027 ~ 0%  nhm8/micro/dbench/100%
      2641 ~ 1%     -23.3%       2027 ~ 0%  TOTAL slabinfo.kmalloc-256.num_slabs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     84537 ~ 1%     -23.3%      64881 ~ 0%  nhm8/micro/dbench/100%
     84537 ~ 1%     -23.3%      64881 ~ 0%  TOTAL slabinfo.kmalloc-256.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    532900 ~ 6%     +60.2%     853805 ~32%  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
    532900 ~ 6%     +60.2%     853805 ~32%  TOTAL cpuidle.C4.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
   6321734 ~ 4%     +28.9%    8150707 ~ 5%  xps2/micro/pigz/100%
   6321734 ~ 4%     +28.9%    8150707 ~ 5%  TOTAL cpuidle.C6-NHM.time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       304 ~31%     +69.9%        518 ~28%  nhm8/micro/dbench/100%
       304 ~31%     +69.9%        518 ~28%  TOTAL cpuidle.C3-NHM.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
   7067435 ~ 0%     -21.1%    5576507 ~ 0%  nhm8/micro/dbench/100%
   7067435 ~ 0%     -21.1%    5576507 ~ 0%  TOTAL proc-vmstat.pgactivate

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      0.74 ~ 1%     +28.8%       0.96 ~ 3%  nhm8/micro/dbench/100%
      0.74 ~ 1%     +28.8%       0.96 ~ 3%  TOTAL perf-profile.cpu-cycles.strchr@plt

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       238 ~ 6%     +80.8%        432 ~43%  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
       238 ~ 6%     +80.8%        432 ~43%  TOTAL cpuidle.C4.usage

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1.48 ~ 1%     +24.4%       1.85 ~ 1%  nhm8/micro/dbench/100%
      1.48 ~ 1%     +24.4%       1.85 ~ 1%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpath

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1.23 ~ 2%     +27.1%       1.56 ~ 1%  nhm8/micro/dbench/100%
      1.23 ~ 2%     +27.1%       1.56 ~ 1%  TOTAL perf-profile.cpu-cycles.link_path_walk.path_lookupat.filename_lookup.user_path_at_empty.user_path_at

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      8810 ~ 9%     -15.4%       7452 ~12%  nhm-white/sysbench/oltp/600s-100%-1000000
      8810 ~ 9%     -15.4%       7452 ~12%  TOTAL slabinfo.kmalloc-64.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    110153 ~ 0%     +12.5%     123905 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
 1.512e+08 ~ 0%     -22.1%  1.178e+08 ~ 0%  nhm8/micro/dbench/100%
 1.514e+08 ~ 0%     -22.1%  1.179e+08 ~ 0%  TOTAL proc-vmstat.pgalloc_normal

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      0.86 ~ 4%     +23.4%       1.06 ~ 7%  lkp-a04/micro/netperf/120s-200%-UDP_RR
      0.86 ~ 4%     +23.4%       1.06 ~ 7%  TOTAL perf-profile.cpu-cycles.inet_getpeer.__ip_select_ident.__ip_make_skb.ip_make_skb.udp_sendmsg

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      0.89 ~ 6%     +16.7%       1.04 ~ 7%  lkp-a04/micro/netperf/120s-200%-UDP_RR
      0.89 ~ 6%     +16.7%       1.04 ~ 7%  TOTAL perf-profile.cpu-cycles.process_backlog.net_rx_action.__do_softirq.do_softirq_own_stack.do_softirq

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    175749 ~ 0%     +12.1%     197084 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
  3.18e+08 ~ 0%     -21.8%  2.486e+08 ~ 0%  nhm8/micro/dbench/100%
 3.182e+08 ~ 0%     -21.8%  2.488e+08 ~ 0%  TOTAL proc-vmstat.pgfree

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    173116 ~ 0%     +12.4%     194610 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
 3.057e+08 ~ 0%     -21.5%  2.401e+08 ~ 0%  nhm8/micro/dbench/100%
 3.059e+08 ~ 0%     -21.5%  2.403e+08 ~ 0%  TOTAL proc-vmstat.numa_local

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    173116 ~ 0%     +12.4%     194610 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
 3.057e+08 ~ 0%     -21.5%  2.401e+08 ~ 0%  nhm8/micro/dbench/100%
 3.059e+08 ~ 0%     -21.5%  2.403e+08 ~ 0%  TOTAL proc-vmstat.numa_hit

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     65176 ~ 1%     +12.3%      73177 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
 1.668e+08 ~ 0%     -21.6%  1.309e+08 ~ 0%  nhm8/micro/dbench/100%
 1.669e+08 ~ 0%     -21.5%  1.309e+08 ~ 0%  TOTAL proc-vmstat.pgalloc_dma32

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      8610 ~10%     -15.9%       7241 ~13%  nhm-white/sysbench/oltp/600s-100%-1000000
      8075 ~ 6%     +10.7%       8943 ~ 1%  xps2/micro/pigz/100%
     16685 ~ 8%      -3.0%      16184 ~ 6%  TOTAL slabinfo.kmalloc-64.active_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      0.88 ~ 7%     +13.3%       1.00 ~ 5%  lkp-a04/micro/netperf/120s-200%-TCP_RR
      0.88 ~ 7%     +13.3%       1.00 ~ 5%  TOTAL perf-profile.cpu-cycles.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1.08 ~ 8%     +20.4%       1.31 ~ 4%  lkp-a04/micro/netperf/120s-200%-UDP_RR
      1.08 ~ 8%     +20.4%       1.31 ~ 4%  TOTAL perf-profile.cpu-cycles.ip_finish_output.ip_output.ip_local_out.ip_send_skb.udp_send_skb

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    554264 ~ 0%     +11.7%     619196 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
    554264 ~ 0%     +11.7%     619196 ~ 7%  TOTAL proc-vmstat.pgfault

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     93717 ~ 0%     -13.9%      80677 ~ 0%  nhm8/micro/dbench/100%
     93717 ~ 0%     -13.9%      80677 ~ 0%  TOTAL slabinfo.dentry.active_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      3960 ~ 5%     +14.7%       4540 ~ 4%  nhm8/micro/dbench/100%
      3960 ~ 5%     +14.7%       4540 ~ 4%  TOTAL slabinfo.anon_vma.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      3960 ~ 5%     +14.7%       4540 ~ 4%  nhm8/micro/dbench/100%
      3960 ~ 5%     +14.7%       4540 ~ 4%  TOTAL slabinfo.anon_vma.active_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
   2289504 ~ 2%     -13.6%    1977520 ~ 5%  lkp-nex04/micro/ebizzy/200%-100-10
   2289504 ~ 2%     -13.6%    1977520 ~ 5%  TOTAL softirqs.RCU

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      2278 ~ 0%     -13.7%       1965 ~ 0%  nhm8/micro/dbench/100%
      2278 ~ 0%     -13.7%       1965 ~ 0%  TOTAL slabinfo.dentry.num_slabs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      2278 ~ 0%     -13.7%       1965 ~ 0%  nhm8/micro/dbench/100%
      2278 ~ 0%     -13.7%       1965 ~ 0%  TOTAL slabinfo.dentry.active_slabs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     95702 ~ 0%     -13.7%      82551 ~ 0%  nhm8/micro/dbench/100%
     95702 ~ 0%     -13.7%      82551 ~ 0%  TOTAL slabinfo.dentry.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     32391 ~ 5%     +12.6%      36485 ~ 5%  lkp-nex04/micro/ebizzy/200%-100-10
     32418 ~ 7%     +19.8%      38832 ~ 9%  nhm8/micro/dbench/100%
     64810 ~ 6%     +16.2%      75317 ~ 7%  TOTAL meminfo.DirectMap4k

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     40261 ~ 1%     -13.1%      34986 ~ 0%  nhm8/micro/dbench/100%
     40261 ~ 1%     -13.1%      34986 ~ 0%  TOTAL meminfo.SUnreclaim

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1.81 ~ 5%     -13.1%       1.57 ~ 3%  lkp-a04/micro/netperf/120s-200%-UDP_RR
      1.81 ~ 5%     -13.1%       1.57 ~ 3%  TOTAL perf-profile.cpu-cycles.udp_sendmsg.inet_sendmsg.sock_sendmsg.sys_sendto.system_call_fastpath

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     10059 ~ 1%     -12.4%       8807 ~ 0%  nhm8/micro/dbench/100%
     10059 ~ 1%     -12.4%       8807 ~ 0%  TOTAL proc-vmstat.nr_slab_unreclaimable

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       185 ~ 0%     +12.8%        209 ~ 8%  lkp-a04/micro/netperf/120s-200%-TCP_RR
       185 ~ 0%     +12.8%        209 ~ 8%  TOTAL uptime.boot

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1781 ~ 7%      +9.1%       1944 ~ 5%  lkp-a04/micro/netperf/120s-200%-SCTP_STREAM
      2706 ~ 8%     +12.7%       3050 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      4488 ~ 8%     +11.3%       4994 ~ 2%  TOTAL slabinfo.kmalloc-128.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       907 ~ 3%     -13.9%        782 ~ 6%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
       907 ~ 3%     -13.9%        782 ~ 6%  TOTAL slabinfo.Acpi-Namespace.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       907 ~ 3%     -13.9%        782 ~ 6%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
       907 ~ 3%     -13.9%        782 ~ 6%  TOTAL slabinfo.Acpi-Namespace.active_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1.13 ~ 4%      -9.6%       1.02 ~ 3%  lkp-a04/micro/netperf/120s-200%-TCP_RR
      1.36 ~ 5%     -12.0%       1.19 ~ 3%  lkp-a04/micro/netperf/120s-200%-UDP_RR
      2.49 ~ 5%     -10.9%       2.22 ~ 3%  TOTAL perf-profile.cpu-cycles.dequeue_task_fair.dequeue_task.deactivate_task.__schedule.schedule

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      0.93 ~ 5%      -9.1%       0.84 ~ 1%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
      0.93 ~ 5%      -9.1%       0.84 ~ 1%  TOTAL perf-profile.cpu-cycles.sctp_rcv.ip_local_deliver.ip_rcv.__netif_receive_skb_core.__netif_receive_skb

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1.46 ~ 1%     +11.6%       1.63 ~ 1%  nhm8/micro/dbench/100%
      1.46 ~ 1%     +11.6%       1.63 ~ 1%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.dcache_readdir.iterate_dir.sys_getdents.system_call_fastpath

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     93450 ~ 0%      -9.9%      84228 ~ 0%  nhm8/micro/dbench/100%
     93450 ~ 0%      -9.9%      84228 ~ 0%  TOTAL meminfo.Slab

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1.10 ~ 4%      -9.1%       1.00 ~ 4%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
      1.10 ~ 4%      -9.1%       1.00 ~ 4%  TOTAL perf-profile.cpu-cycles.kfree.skb_free_head.skb_release_data.skb_release_all.__kfree_skb

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      4174 ~ 7%     -12.6%       3646 ~ 4%  nhm8/micro/dbench/100%
      4174 ~ 7%     -12.6%       3646 ~ 4%  TOTAL slabinfo.kmalloc-192.num_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      2608 ~12%     +16.9%       3050 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      2608 ~12%     +16.9%       3050 ~ 0%  TOTAL slabinfo.kmalloc-128.active_objs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      2130 ~ 4%     -10.2%       1913 ~ 4%  lkp-nex04/micro/ebizzy/200%-100-10
      2130 ~ 4%     -10.2%       1913 ~ 4%  TOTAL numa-vmstat.node2.nr_alloc_batch

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     17.13 ~ 0%     -20.5%      13.62 ~18%  nhm-white/sysbench/oltp/600s-100%-1000000
     17.13 ~ 0%     -20.5%      13.62 ~18%  TOTAL iostat.sda.rrqm/s

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      2067 ~ 2%     +29.5%       2677 ~ 3%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
      1652 ~ 1%      +3.9%       1716 ~ 1%  lkp-a04/micro/netperf/120s-200%-UDP_RR
      2961 ~ 3%     -16.9%       2461 ~ 3%  lkp-a06/micro/qperf/600s
      6680 ~ 2%      +2.6%       6855 ~ 2%  TOTAL vmstat.system.in

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    452653 ~ 2%     +16.7%     528434 ~ 4%  lkp-nex04/micro/ebizzy/200%-100-10
    452653 ~ 2%     +16.7%     528434 ~ 4%  TOTAL time.voluntary_context_switches

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
       125 ~ 0%      +5.3%        132 ~ 5%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
       121 ~ 0%     +12.3%        136 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
       246 ~ 0%      +8.8%        268 ~ 6%  TOTAL time.elapsed_time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
     20982 ~ 0%      -5.4%      19846 ~ 5%  lkp-a04/micro/netperf/120s-200%-SCTP_RR
     33453 ~ 0%     -10.5%      29936 ~ 7%  lkp-a04/micro/netperf/120s-200%-TCP_RR
     54436 ~ 0%      -8.5%      49782 ~ 6%  TOTAL vmstat.system.cs

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      3111 ~ 0%      +9.8%       3418 ~ 0%  nhm8/micro/dbench/100%
      3111 ~ 0%      +9.8%       3418 ~ 0%  TOTAL time.user_time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      5499 ~ 0%      -5.7%       5183 ~ 0%  nhm8/micro/dbench/100%
      5499 ~ 0%      -5.7%       5183 ~ 0%  TOTAL time.system_time

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
      1195 ~ 0%      -2.0%       1171 ~ 1%  nhm8/micro/dbench/100%
      1195 ~ 0%      -2.0%       1171 ~ 1%  TOTAL time.percent_of_cpu_this_job_got

      v3.14-rc6  c3ccbcb772e3b1c7b976dfb1c  
---------------  -------------------------  
    225296 ~ 0%      +1.6%     228829 ~ 0%  nhm8/micro/dbench/100%
    225296 ~ 0%      +1.6%     228829 ~ 0%  TOTAL time.involuntary_context_switches

Thanks,
Fengguang
