Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaJFFzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:55:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:4463 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaJFFzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:55:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,662,1406617200"; 
   d="scan'208";a="482171764"
Date: Mon, 6 Oct 2014 13:54:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [rcu] 5057f55e543:  dmesg.BUG:soft_lockup-CPU_stuck_for_s
Message-ID: <20141006055456.GA650@wfg-t540p.sh.intel.com>
References: <20141006055024.GD28732@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141006055024.GD28732@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 01:50:24PM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> FYI, we noticed a number of ups and downs for commit
> 
> 5057f55e543b7859cfd26bc281291795eac93f8a ("rcu: Bind RCU grace-period kthreads if NO_HZ_FULL")

Here is an overview of the performance/power/latency/kernel size
index. The baseline (71a9b26963f8c2d) number is 100, the larger, the better.

    96      perf-index  5057f55e543b7859cfd26bc281291795eac93f8a
    99     power-index  5057f55e543b7859cfd26bc281291795eac93f8a
   101   latency-index  5057f55e543b7859cfd26bc281291795eac93f8a
   102      size-index  5057f55e543b7859cfd26bc281291795eac93f8a

71a9b26963f8c2d  5057f55e543b7859cfd26bc28  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     %stddev        %change               %stddev
            \          |                 /
    329.95 ± 0%      -0.0%     329.95 ± 1%  lkp-a04/netperf/300s-200%-10K-SCTP_STREAM_MANY
      2.13 ± 0%      +0.0%       2.13 ± 0%  lkp-a04/netperf/300s-200%-SCTP_STREAM
   1613.32 ± 0%      +0.0%    1613.78 ± 0%  lkp-a04/netperf/300s-200%-TCP_SENDFILE
    618.16 ± 0%      -0.2%     616.64 ± 0%  lkp-a04/netperf/900s-200%-TCP_MAERTS
    616.08 ± 0%      +0.5%     619.11 ± 0%  lkp-a04/netperf/900s-200%-TCP_STREAM
   3179.63 ± 0%      +0.1%    3181.60 ± 0%  TOTAL netperf.Throughput_Mbps

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     13.93          +21.9%      16.98       lkp-a04/boot/1
     13.84           -2.0%      13.56       lkp-a05/boot/1
     13.48           +1.2%      13.64       lkp-a06/boot/1
     21.24           -0.0%      21.24       lkp-nex04/boot/1
     16.27          +26.1%      20.52       lkp-sb03/boot/1
     15.28          -10.3%      13.71       lkp-snb01/boot/1
      5.45          +93.7%      10.56       xps/boot/1
      6.46          +21.3%       7.83       xps2/boot/1
    105.95          +11.4%     118.03       TOTAL boottime.dhcp

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     31.78           +4.0%      33.04       lkp-a04/boot/1
     31.02           -1.2%      30.65       lkp-a05/boot/1
     29.63           +1.6%      30.10       lkp-a06/boot/1
     36.97           +0.9%      37.29       lkp-nex04/boot/1
     22.44          +35.5%      30.40       lkp-sb03/boot/1
     17.88           +9.1%      19.50       lkp-snb01/boot/1
      8.45          +60.6%      13.57       xps/boot/1
     16.62          -18.0%      13.63       xps2/boot/1
    194.79           +6.9%     208.18       TOTAL boottime.boot

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
  13101199           +0.0%   13101263       brickland1/boot/1
  13101199           +0.0%   13101263       lkp-a04/boot/1
  13101199           +0.0%   13101263       lkp-a05/boot/1
  13101199           +0.0%   13101263       lkp-a06/boot/1
  13101199           +0.0%   13101263       lkp-nex04/boot/1
  13101199           +0.0%   13101263       lkp-sb03/boot/1
  13101199           +0.0%   13101263       lkp-snb01/boot/1
  13101199           +0.0%   13101263       xps/boot/1
  13101199           +0.0%   13101263       xps2/boot/1
 117910791           +0.0%  117911367       TOTAL kernel-size.text

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   3024216           +0.0%    3024216       brickland1/boot/1
   3024216           +0.0%    3024216       lkp-a04/boot/1
   3024216           +0.0%    3024216       lkp-a05/boot/1
   3024216           +0.0%    3024216       lkp-a06/boot/1
   3024216           +0.0%    3024216       lkp-nex04/boot/1
   3024216           +0.0%    3024216       lkp-sb03/boot/1
   3024216           +0.0%    3024216       lkp-snb01/boot/1
   3024216           +0.0%    3024216       xps/boot/1
   3024216           +0.0%    3024216       xps2/boot/1
  27217944           +0.0%   27217944       TOTAL kernel-size.data

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   6586368           +0.0%    6586368       brickland1/boot/1
   6586368           +0.0%    6586368       lkp-a04/boot/1
   6586368           +0.0%    6586368       lkp-a05/boot/1
   6586368           +0.0%    6586368       lkp-a06/boot/1
   6586368           +0.0%    6586368       lkp-nex04/boot/1
   6586368           +0.0%    6586368       lkp-sb03/boot/1
   6586368           +0.0%    6586368       lkp-snb01/boot/1
   6586368           +0.0%    6586368       xps/boot/1
   6586368           +0.0%    6586368       xps2/boot/1
  59277312           +0.0%   59277312       TOTAL kernel-size.bss

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   8165908           +0.0%    8165908       lkp-a04/boot/1
   8165924           +0.0%    8165924       lkp-a05/boot/1
   8165924           +0.0%    8165924       lkp-a06/boot/1
  2.64e+08           +0.0%   2.64e+08       lkp-nex04/boot/1
  65921696           +0.0%   65921696       lkp-sb03/boot/1
  32891580           +0.0%   32891580       lkp-snb01/boot/1
   4036024           +0.0%    4036024       xps/boot/1
   4036024           +0.0%    4036024       xps2/boot/1
 3.954e+08           +0.0%  3.954e+08       TOTAL boot-meminfo.MemTotal

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   7607680           +0.0%    7607908       lkp-a04/boot/1
   7607636           +0.0%    7608252       lkp-a05/boot/1
   7607292           +0.0%    7608364       lkp-a06/boot/1
 2.618e+08           +0.0%  2.618e+08       lkp-nex04/boot/1
  64924852           -0.0%   64922732       lkp-sb03/boot/1
  32074152           +0.0%   32076064       lkp-snb01/boot/1
   3497996           +0.0%    3498424       xps/boot/1
   3497740           +0.0%    3499356       xps2/boot/1
 3.886e+08           +0.0%  3.886e+08       TOTAL boot-meminfo.MemFree

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   7871460           +0.0%    7871904       lkp-a04/boot/1
   7871476           +0.0%    7872044       lkp-a05/boot/1
   7871300           +0.0%    7872156       lkp-a06/boot/1
 2.619e+08           +0.0%  2.619e+08       lkp-nex04/boot/1
  65137100           -0.0%   65134668       lkp-sb03/boot/1
  32286200           +0.0%   32287684       lkp-snb01/boot/1
   3762164           +0.0%    3762352       xps/boot/1
   3761832           +0.0%    3763320       xps2/boot/1
 3.905e+08           +0.0%  3.905e+08       TOTAL boot-meminfo.MemAvailable

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     29296           +0.5%      29428       lkp-a04/boot/1
     29144           +0.5%      29300       lkp-a05/boot/1
     29560           -1.4%      29152       lkp-a06/boot/1
     42412           -0.6%      42172       lkp-nex04/boot/1
     37692           +0.5%      37896       lkp-sb03/boot/1
     37384           +0.1%      37432       lkp-snb01/boot/1
     29792           +0.1%      29832       xps/boot/1
     29644           -0.0%      29636       xps2/boot/1
    264924           -0.0%     264848       TOTAL boot-meminfo.SReclaimable

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     14744           +0.4%      14808       lkp-a04/boot/1
     14684           -0.1%      14668       lkp-a05/boot/1
     14780           -0.4%      14724       lkp-a06/boot/1
     83388           +1.6%      84724       lkp-nex04/boot/1
     64248           -1.5%      63316       lkp-sb03/boot/1
     62864           +0.9%      63428       lkp-snb01/boot/1
     19192           -3.9%      18452       xps/boot/1
     19032           -1.3%      18792       xps2/boot/1
    292932           -0.0%     292912       TOTAL boot-meminfo.SUnreclaim

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
       920           -2.6%        896       lkp-a04/boot/1
       920           -4.3%        880       lkp-a05/boot/1
       904           -0.9%        896       lkp-a06/boot/1
      5336           -0.6%       5304       lkp-nex04/boot/1
      5264           -0.6%       5232       lkp-sb03/boot/1
      6032          -12.5%       5280       lkp-snb01/boot/1
      1288           -5.0%       1224       xps/boot/1
      1208           +0.0%       1208       xps2/boot/1
     21872           -4.4%      20920       TOTAL boot-meminfo.KernelStack

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      1692          -15.6%       1428       lkp-a04/boot/1
      1428          -38.4%        880       lkp-a05/boot/1
      1188           +1.7%       1208       lkp-a06/boot/1
      3028          -31.0%       2088       lkp-nex04/boot/1
      1572           +7.6%       1692       lkp-sb03/boot/1
      2128          -37.6%       1328       lkp-snb01/boot/1
      1328          -19.9%       1064       xps/boot/1
      1276          -36.4%        812       xps2/boot/1
     13640          -23.0%      10500       TOTAL boot-meminfo.PageTables

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    168143           +0.2%     168548       lkp-a04/boot/1
    168027           +0.1%     168195       lkp-a05/boot/1
    169507           -0.7%     168340       lkp-a06/boot/1
    572994           +1.0%     578836       lkp-nex04/boot/1
    469825           -0.3%     468578       lkp-sb03/boot/1
    461793           -0.2%     460775       lkp-snb01/boot/1
    186349           -0.3%     185814       xps/boot/1
    188185           -1.9%     184695       xps2/boot/1
   2384823           -0.0%    2383781       TOTAL boot-slabinfo.num_objs

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     11017           +0.5%      11071       lkp-a04/boot/1
     10970           +0.5%      11025       lkp-a05/boot/1
     11133           -1.2%      10997       lkp-a06/boot/1
     31671           +0.5%      31832       lkp-nex04/boot/1
     25490           -0.6%      25346       lkp-sb03/boot/1
     25041           +0.4%      25135       lkp-snb01/boot/1
     12278           -1.2%      12126       xps/boot/1
     12300           -1.2%      12149       xps2/boot/1
    139900           -0.2%     139681       TOTAL boot-slabinfo.num_pages

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    274318           +0.0%     274318       lkp-a04/boot/1
    274303           +0.0%     274303       lkp-a05/boot/1
    274303           +0.0%     274303       lkp-a06/boot/1
    363232           +0.0%     363232       lkp-nex04/boot/1
    302259           +0.0%     302259       lkp-sb03/boot/1
    302254           +0.0%     302254       lkp-snb01/boot/1
     13561           +0.0%      13561       xps/boot/1
     13561           +0.0%      13561       xps2/boot/1
   1817791           +0.0%    1817791       TOTAL memmap.reserved

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    156776 ± 1%      +2.9%     161328 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
    136352 ± 1%      +5.3%     143641 ± 0%  lkp-snb01/hackbench/1600%-process-socket
    144955 ± 0%      +3.5%     149992 ± 0%  lkp-snb01/hackbench/1600%-threads-socket
    117112 ± 0%      -1.0%     115990 ± 0%  lkp-snb01/hackbench/50%-process-pipe
    100436 ± 0%      -0.3%     100136 ± 0%  lkp-snb01/hackbench/50%-process-socket
    109889 ± 0%      -0.3%     109582 ± 0%  lkp-snb01/hackbench/50%-threads-pipe
     90202 ± 0%      +0.2%      90400 ± 0%  lkp-snb01/hackbench/50%-threads-socket
    855724 ± 0%      +1.8%     871071 ± 0%  TOTAL hackbench.throughput

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     73.52 ± 1%      -0.3%      73.32 ± 1%  lkp-sb03/nepim/300s-100%-tcp
     72.37 ± 0%      -0.8%      71.80 ± 0%  lkp-sb03/nepim/300s-100%-tcp6
     84.41 ± 1%      -1.3%      83.29 ± 0%  lkp-sb03/nepim/300s-100%-udp
     83.75 ± 0%      -0.1%      83.63 ± 0%  lkp-sb03/nepim/300s-100%-udp6
     70.53 ± 0%      +0.7%      71.00 ± 1%  lkp-sb03/nepim/300s-25%-tcp
     70.07 ± 0%      -1.7%      68.85 ± 1%  lkp-sb03/nepim/300s-25%-tcp6
     82.43 ± 0%      -0.5%      81.99 ± 0%  lkp-sb03/nepim/300s-25%-udp
     82.42 ± 0%      -0.4%      82.13 ± 0%  lkp-sb03/nepim/300s-25%-udp6
     69.29 ± 0%      +3.0%      71.34 ± 1%  lkp-sb03/nuttcp/300s
     71.43 ± 0%      +2.7%      73.35 ± 0%  lkp-sb03/thrulay/300s
    189.00 ± 0%      +0.2%     189.36 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
    195.36 ± 0%      +0.2%     195.73 ± 0%  lkp-snb01/hackbench/1600%-threads-socket
    195.50 ± 0%      -0.1%     195.37 ± 0%  lkp-snb01/hackbench/50%-process-pipe
    195.59 ± 0%      +0.1%     195.74 ± 0%  lkp-snb01/hackbench/50%-process-socket
    197.84 ± 0%      -0.0%     197.76 ± 0%  lkp-snb01/hackbench/50%-threads-pipe
    196.47 ± 0%      +0.1%     196.64 ± 0%  lkp-snb01/hackbench/50%-threads-socket
    142.24 ± 0%      +0.1%     142.43 ± 0%  lkp-snb01/will-it-scale/open2
   2072.21 ± 0%      +0.1%    2073.75 ± 0%  TOTAL turbostat.Pkg_W

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     98.71 ± 0%      +0.0%      98.71 ± 0%  lkp-nex04/ebizzy/200%-100x-10s
      6.43 ± 1%      -0.1%       6.43 ± 0%  lkp-sb03/nepim/300s-100%-tcp
      6.43 ± 0%      -0.6%       6.39 ± 0%  lkp-sb03/nepim/300s-100%-tcp6
      6.93 ± 6%      -3.0%       6.72 ± 0%  lkp-sb03/nepim/300s-100%-udp
      6.75 ± 2%      -2.9%       6.55 ± 0%  lkp-sb03/nepim/300s-100%-udp6
      6.22 ± 0%      +0.2%       6.23 ± 1%  lkp-sb03/nepim/300s-25%-tcp
      6.19 ± 1%      -1.6%       6.09 ± 0%  lkp-sb03/nepim/300s-25%-tcp6
      6.42 ± 0%      +0.4%       6.44 ± 1%  lkp-sb03/nepim/300s-25%-udp
      6.40 ± 0%      -0.4%       6.37 ± 0%  lkp-sb03/nepim/300s-25%-udp6
      6.46 ± 0%      -0.2%       6.45 ± 0%  lkp-sb03/nuttcp/300s
      6.42 ± 0%      +1.9%       6.54 ± 0%  lkp-sb03/thrulay/300s
     94.38 ± 0%      -0.2%      94.18 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
     96.85 ± 0%      -0.2%      96.62 ± 0%  lkp-snb01/hackbench/1600%-threads-socket
     97.83 ± 0%      -0.1%      97.77 ± 0%  lkp-snb01/hackbench/50%-process-pipe
     95.25 ± 0%      +0.1%      95.30 ± 0%  lkp-snb01/hackbench/50%-process-socket
     98.72 ± 0%      -0.1%      98.64 ± 0%  lkp-snb01/hackbench/50%-threads-pipe
     96.23 ± 0%      +0.0%      96.25 ± 0%  lkp-snb01/hackbench/50%-threads-socket
     52.52 ± 0%      -0.1%      52.44 ± 0%  lkp-snb01/will-it-scale/open2
      6.60 ± 0%     +36.9%       9.03 ± 0%  xps/ftrace_onoff/5m
     99.66 ± 0%      +0.0%      99.67 ± 0%  xps2/pigz/100%-128K
     99.65 ± 0%      +0.0%      99.65 ± 0%  xps2/pigz/100%-512K
   1001.03 ± 0%      +0.1%    1002.47 ± 0%  TOTAL turbostat.%c0

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    140466 ± 0%      +0.7%     141408 ± 4%  lkp-sb03/nepim/300s-100%-udp
    124028 ± 2%      -1.7%     121963 ± 1%  lkp-sb03/nepim/300s-100%-udp6
    554919 ± 0%      +1.2%     561518 ± 1%  lkp-sb03/nepim/300s-25%-udp
    502901 ± 3%      +0.4%     504897 ± 2%  lkp-sb03/nepim/300s-25%-udp6
   1322316 ± 1%      +0.6%    1329787 ± 2%  TOTAL nepim.udp.avg.kbps_in

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    156817 ± 2%      +1.4%     159074 ± 5%  lkp-sb03/nepim/300s-100%-udp
    127089 ± 2%      -1.7%     124946 ± 2%  lkp-sb03/nepim/300s-100%-udp6
    613815 ± 1%      +7.4%     659052 ± 0%  lkp-sb03/nepim/300s-25%-udp
    510341 ± 2%      +5.9%     540461 ± 5%  lkp-sb03/nepim/300s-25%-udp6
   1408063 ± 2%      +5.4%    1483534 ± 2%  TOTAL nepim.udp.avg.kbps_out

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    732984 ± 0%      -0.3%     730688 ± 0%  lkp-snb01/will-it-scale/open2
    732984 ± 0%      -0.3%     730688 ± 0%  TOTAL will-it-scale.per_process_ops

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    253013 ± 0%      -1.2%     249916 ± 0%  lkp-snb01/will-it-scale/open2
    253013 ± 0%      -1.2%     249916 ± 0%  TOTAL will-it-scale.per_thread_ops

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      0.46 ± 0%      +0.1%       0.46 ± 1%  lkp-snb01/will-it-scale/open2
      0.46 ± 0%      +0.1%       0.46 ± 1%  TOTAL will-it-scale.scalability

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     44544 ± 0%      +0.6%      44791 ± 0%  lkp-sb03/nuttcp/300s
     44544 ± 0%      +0.6%      44791 ± 0%  TOTAL nuttcp.throughput_Mbps

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
  75221440 ± 0%      +0.0%   75230964 ± 0%  xps2/pigz/100%-128K
  76660493 ± 0%      +0.0%   76663354 ± 0%  xps2/pigz/100%-512K
 151881933 ± 0%      +0.0%  151894319 ± 0%  TOTAL pigz.throughput

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
 1.343e+08 ± 6%      +6.4%  1.429e+08 ± 8%  lkp-a06/qperf/600s
 1.343e+08 ± 6%      +6.4%  1.429e+08 ± 8%  TOTAL qperf.sctp.bw

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
 6.176e+08 ± 0%      +0.5%  6.209e+08 ± 0%  lkp-a06/qperf/600s
 6.176e+08 ± 0%      +0.5%  6.209e+08 ± 0%  TOTAL qperf.tcp.bw

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
 6.479e+08 ± 0%      -0.9%   6.42e+08 ± 0%  lkp-a06/qperf/600s
 6.479e+08 ± 0%      -0.9%   6.42e+08 ± 0%  TOTAL qperf.udp.recv_bw

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
 6.561e+08 ± 0%      -1.3%  6.477e+08 ± 0%  lkp-a06/qperf/600s
 6.561e+08 ± 0%      -1.3%  6.477e+08 ± 0%  TOTAL qperf.udp.send_bw

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     75582 ± 2%      -3.1%      73228 ± 0%  lkp-a06/qperf/600s
     75582 ± 2%      -3.1%      73228 ± 0%  TOTAL qperf.sctp.latency

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     53122 ± 0%      -1.0%      52615 ± 0%  lkp-a06/qperf/600s
     53122 ± 0%      -1.0%      52615 ± 0%  TOTAL qperf.tcp.latency

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     43756 ± 0%      -0.7%      43458 ± 0%  lkp-a06/qperf/600s
     43756 ± 0%      -0.7%      43458 ± 0%  TOTAL qperf.udp.latency

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    654746 ± 2%      -6.0%     615555 ± 2%  lkp-sb03/nepim/300s-100%-tcp
    600651 ± 1%      -1.2%     593478 ± 1%  lkp-sb03/nepim/300s-100%-tcp6
   2804100 ± 0%      -2.2%    2743293 ± 1%  lkp-sb03/nepim/300s-25%-tcp
   2585813 ± 0%      -2.9%    2510916 ± 1%  lkp-sb03/nepim/300s-25%-tcp6
   6645312 ± 1%      -2.7%    6463244 ± 1%  TOTAL nepim.tcp.avg.kbps_in

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    655257 ± 2%      -6.1%     615397 ± 2%  lkp-sb03/nepim/300s-100%-tcp
    600612 ± 1%      -1.2%     593143 ± 1%  lkp-sb03/nepim/300s-100%-tcp6
   2803859 ± 0%      -2.1%    2743881 ± 1%  lkp-sb03/nepim/300s-25%-tcp
   2585647 ± 0%      -2.9%    2510718 ± 1%  lkp-sb03/nepim/300s-25%-tcp6
   6645378 ± 1%      -2.7%    6463141 ± 1%  TOTAL nepim.tcp.avg.kbps_out

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
 4.534e+09 ± 1%      -1.0%  4.489e+09 ± 2%  lkp-a05/iperf/300s-tcp
 4.534e+09 ± 1%      -1.0%  4.489e+09 ± 2%  TOTAL iperf.tcp.receiver.bps

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
 4.534e+09 ± 1%      -1.0%  4.489e+09 ± 2%  lkp-a05/iperf/300s-tcp
 4.534e+09 ± 1%      -1.0%  4.489e+09 ± 2%  TOTAL iperf.tcp.sender.bps

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   1048360 ± 0%      +0.0%    1048360 ± 0%  lkp-a05/iperf/300s-udp
   1048360 ± 0%      +0.0%    1048360 ± 0%  TOTAL iperf.udp.bps

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     12681 ± 0%      -1.4%      12503 ± 0%  lkp-nex04/ebizzy/200%-100x-10s
     12681 ± 0%      -1.4%      12503 ± 0%  TOTAL ebizzy.throughput

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     47828 ± 1%      -5.5%      45180 ± 0%  lkp-sb03/thrulay/300s
     47828 ± 1%      -5.5%      45180 ± 0%  TOTAL thrulay.throughput

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      0.02 ± 4%      -7.0%       0.02 ± 2%  lkp-sb03/thrulay/300s
      0.02 ± 4%      -7.0%       0.02 ± 2%  TOTAL thrulay.jitter

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      0.10 ± 1%      +5.9%       0.10 ± 0%  lkp-sb03/thrulay/300s
      0.10 ± 1%      +5.9%       0.10 ± 0%  TOTAL thrulay.RTT

Thanks,
Fengguang
