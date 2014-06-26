Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbaFZCPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:15:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52061 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbaFZCPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:15:40 -0400
Date: Wed, 25 Jun 2014 19:15:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Jet Chen <jet.chen@intel.com>
Subject: Re: [rcu] 34577530114: +247.4% qperf.tcp.bw, -3.3% turbostat.Pkg_W
Message-ID: <20140626021533.GP4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140626020011.GE12239@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626020011.GE12239@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062602-3532-0000-0000-000002BBCA1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 10:00:11AM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> We are pleased to notice huge throughput increases in the qperf/iperf
> tests, together with noticeable reduce of power consumption!

This one was identified by your testing efforts, so thank you for giving
me the hints needed to make this change!  Looks like some negatives to
go with the positives, though eyeballing it looks mostly positive.

Just out of curiosity, what hardware configuration is this running on?
I am guessing a largish number of CPUs.

							Thanx, Paul

> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev
> commit 34577530114e9b1de10f3aa9665bb28c8ce585ba ("rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs")
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   8.23e+08 ~ 6%    +247.4%  2.859e+09 ~ 0%  bens/qperf/600s
>   8.23e+08 ~ 6%    +247.4%  2.859e+09 ~ 0%  TOTAL qperf.tcp.bw
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>  7.065e+09 ~ 3%    +210.0%   2.19e+10 ~ 8%  bens/iperf/300s-tcp
>  7.065e+09 ~ 3%    +210.0%   2.19e+10 ~ 8%  TOTAL iperf.tcp.sender.bps
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>  7.065e+09 ~ 3%    +210.0%   2.19e+10 ~ 8%  bens/iperf/300s-tcp
>  7.065e+09 ~ 3%    +210.0%   2.19e+10 ~ 8%  TOTAL iperf.tcp.receiver.bps
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>  7.718e+08 ~ 3%    +177.8%  2.144e+09 ~ 1%  bens/qperf/600s
>  7.718e+08 ~ 3%    +177.8%  2.144e+09 ~ 1%  TOTAL qperf.udp.recv_bw
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>  7.745e+08 ~ 3%    +177.0%  2.145e+09 ~ 1%  bens/qperf/600s
>  7.745e+08 ~ 3%    +177.0%  2.145e+09 ~ 1%  TOTAL qperf.udp.send_bw
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   1.65e+09 ~ 1%      +4.3%  1.721e+09 ~ 0%  bens/qperf/600s
>   1.65e+09 ~ 1%      +4.3%  1.721e+09 ~ 0%  TOTAL qperf.sctp.bw
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      13579 ~ 1%      -2.3%      13264 ~ 1%  bens/qperf/600s
>      13579 ~ 1%      -2.3%      13264 ~ 1%  TOTAL qperf.sctp.latency
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       8545 ~ 0%      +1.9%       8705 ~ 0%  bens/qperf/600s
>       8545 ~ 0%      +1.9%       8705 ~ 0%  TOTAL qperf.udp.latency
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      12770 ~ 0%      -1.0%      12637 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>      12770 ~ 0%      -1.0%      12637 ~ 0%  TOTAL netperf.Throughput_tps
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       1015 ~ 2%     -92.1%         80 ~24%  ivb43/netperf/300s-25%-TCP_CRR
>       1015 ~ 2%     -92.1%         80 ~24%  TOTAL cpuidle.POLL.usage
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>     104620 ~31%     -83.2%      17544 ~11%  ivb43/netperf/300s-25%-TCP_CRR
>     104620 ~31%     -83.2%      17544 ~11%  TOTAL numa-vmstat.node1.numa_other
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       0.12 ~ 7%     -73.3%       0.03 ~12%  ivb43/netperf/300s-25%-TCP_CRR
>       0.12 ~ 7%     -73.3%       0.03 ~12%  TOTAL turbostat.%c3
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   53226067 ~ 3%     -78.2%   11579930 ~14%  ivb43/netperf/300s-25%-TCP_CRR
>    3327687 ~28%     +86.6%    6208767 ~42%  ivb44/pigz/25%-128K
>   56553754 ~ 4%     -68.5%   17788697 ~24%  TOTAL cpuidle.C1E-IVT.time
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>     878601 ~ 3%     -75.2%     217607 ~12%  ivb43/netperf/300s-25%-TCP_CRR
>       9282 ~27%     +99.2%      18495 ~49%  ivb44/pigz/25%-128K
>     887884 ~ 4%     -73.4%     236102 ~15%  TOTAL cpuidle.C1E-IVT.usage
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   28174239 ~ 6%     -61.0%   10981001 ~ 8%  ivb43/netperf/300s-25%-TCP_CRR
>   28174239 ~ 6%     -61.0%   10981001 ~ 8%  TOTAL cpuidle.C3-IVT.time
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        237 ~20%    +141.1%        572 ~ 9%  xbm/pigz/25%-512K
>        237 ~20%    +141.1%        572 ~ 9%  TOTAL cpuidle.C3-SNB.usage
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>    8192746 ~ 3%    +202.8%   24806641 ~ 7%  bens/iperf/300s-tcp
>   15458478 ~ 1%     +69.2%   26148854 ~ 0%  bens/qperf/600s
>   23651225 ~ 2%    +115.4%   50955496 ~ 4%  TOTAL proc-vmstat.numa_hit
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>    8192746 ~ 3%    +202.8%   24806641 ~ 7%  bens/iperf/300s-tcp
>   15458478 ~ 1%     +69.2%   26148854 ~ 0%  bens/qperf/600s
>   23651225 ~ 2%    +115.4%   50955496 ~ 4%  TOTAL proc-vmstat.numa_local
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   63502648 ~ 3%    +209.1%  1.963e+08 ~ 8%  bens/iperf/300s-tcp
>  2.191e+08 ~ 1%     +55.9%  3.416e+08 ~ 0%  bens/qperf/600s
>  2.826e+08 ~ 2%     +90.3%  5.379e+08 ~ 3%  TOTAL proc-vmstat.pgfree
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   15752293 ~ 3%    +209.0%   48677753 ~ 8%  bens/iperf/300s-tcp
>   54168455 ~ 1%     +56.0%   84483873 ~ 0%  bens/qperf/600s
>   69920749 ~ 2%     +90.4%  133161627 ~ 3%  TOTAL proc-vmstat.pgalloc_normal
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>    9737163 ~ 2%     -56.7%    4213811 ~ 6%  ivb43/netperf/300s-25%-TCP_CRR
>    9737163 ~ 2%     -56.7%    4213811 ~ 6%  TOTAL cpuidle.C6-IVT.usage
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>    5033341 ~ 3%    +192.9%   14743041 ~12%  bens/iperf/300s-tcp
>   21147143 ~ 0%     +30.9%   27679992 ~ 0%  bens/qperf/600s
>   26180485 ~ 1%     +62.0%   42423033 ~ 4%  TOTAL softirqs.NET_RX
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       0.45 ~37%    +109.7%       0.95 ~34%  bens/qperf/600s
>       0.45 ~37%    +109.7%       0.95 ~34%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.skb_copy_datagram_iovec.tcp_recvmsg.inet_recvmsg.sock_aio_read
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      87907 ~29%    +145.9%     216127 ~27%  xbm/pigz/25%-512K
>      87907 ~29%    +145.9%     216127 ~27%  TOTAL cpuidle.C3-SNB.time
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>     646521 ~ 7%     -49.5%     326622 ~ 9%  ivb43/netperf/300s-25%-TCP_CRR
>     646521 ~ 7%     -49.5%     326622 ~ 9%  TOTAL cpuidle.C3-IVT.usage
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        658 ~13%    +109.3%       1377 ~11%  xbm/pigz/25%-512K
>        658 ~13%    +109.3%       1377 ~11%  TOTAL cpuidle.C1E-SNB.usage
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   47748828 ~ 3%    +209.2%  1.476e+08 ~ 8%  bens/iperf/300s-tcp
>   1.65e+08 ~ 1%     +55.9%  2.571e+08 ~ 0%  bens/qperf/600s
>    2741315 ~ 3%      +7.4%    2943780 ~ 5%  ivb43/netperf/300s-25%-TCP_CRR
>  2.155e+08 ~ 2%     +89.2%  4.077e+08 ~ 3%  TOTAL proc-vmstat.pgalloc_dma32
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>  2.826e+08 ~ 9%     -31.4%  1.938e+08 ~16%  lkp-sb03/nuttcp/300s
>  2.826e+08 ~ 9%     -31.4%  1.938e+08 ~16%  TOTAL cpuidle.C1-SNB.time
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      47008 ~ 4%     +52.7%      71784 ~ 4%  bens/qperf/600s
>      20704 ~ 4%     +49.2%      30899 ~ 3%  xbm/pigz/25%-512K
>      67712 ~ 4%     +51.6%     102683 ~ 4%  TOTAL softirqs.RCU
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       8643 ~ 7%     -32.8%       5805 ~ 1%  ivb43/netperf/300s-25%-TCP_CRR
>       8643 ~ 7%     -32.8%       5805 ~ 1%  TOTAL proc-vmstat.numa_hint_faults
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       8949 ~ 7%     -31.5%       6129 ~ 1%  ivb43/netperf/300s-25%-TCP_CRR
>       8949 ~ 7%     -31.5%       6129 ~ 1%  TOTAL proc-vmstat.numa_pte_updates
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      29.25 ~ 0%     +41.8%      41.49 ~ 1%  ivb43/netperf/300s-25%-TCP_CRR
>      29.25 ~ 0%     +41.8%      41.49 ~ 1%  TOTAL turbostat.%c6
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        486 ~ 6%     -26.3%        358 ~ 8%  ivb43/netperf/300s-25%-TCP_CRR
>        524 ~ 9%     -24.4%        396 ~ 6%  ivb44/pigz/25%-128K
>        486 ~ 6%     -31.6%        332 ~ 7%  lkp-sb03/nuttcp/300s
>       1497 ~ 7%     -27.4%       1088 ~ 7%  TOTAL slabinfo.kmem_cache.num_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        486 ~ 6%     -26.3%        358 ~ 8%  ivb43/netperf/300s-25%-TCP_CRR
>        524 ~ 9%     -24.4%        396 ~ 6%  ivb44/pigz/25%-128K
>        486 ~ 6%     -31.6%        332 ~ 7%  lkp-sb03/nuttcp/300s
>       1497 ~ 7%     -27.4%       1088 ~ 7%  TOTAL slabinfo.kmem_cache.active_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       7914 ~ 6%     -29.6%       5575 ~ 1%  ivb43/netperf/300s-25%-TCP_CRR
>       7914 ~ 6%     -29.6%       5575 ~ 1%  TOTAL proc-vmstat.numa_hint_faults_local
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      37.08 ~ 0%     -34.3%      24.36 ~ 2%  ivb43/netperf/300s-25%-TCP_CRR
>      12.48 ~ 3%     -13.8%      10.76 ~ 6%  lkp-sb03/nuttcp/300s
>      49.56 ~ 1%     -29.2%      35.11 ~ 3%  TOTAL turbostat.%c1
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        596 ~ 5%     -21.5%        468 ~ 6%  ivb43/netperf/300s-25%-TCP_CRR
>        634 ~ 7%     -20.2%        506 ~ 5%  ivb44/pigz/25%-128K
>        596 ~ 5%     -25.8%        442 ~ 5%  lkp-sb03/nuttcp/300s
>       1827 ~ 6%     -22.4%       1418 ~ 5%  TOTAL slabinfo.kmem_cache_node.active_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      98347 ~ 1%     +66.0%     163290 ~ 9%  bens/iperf/300s-tcp
>     263164 ~ 0%     +15.4%     303781 ~ 1%  bens/qperf/600s
>     181866 ~ 3%     -15.0%     154551 ~ 7%  ivb44/pigz/25%-128K
>      16865 ~ 1%     +14.6%      19322 ~ 4%  xbm/pigz/25%-512K
>     560243 ~ 1%     +14.4%     640945 ~ 5%  TOTAL softirqs.SCHED
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        614 ~ 5%     -20.8%        486 ~ 6%  ivb43/netperf/300s-25%-TCP_CRR
>        652 ~ 7%     -19.6%        524 ~ 4%  ivb44/pigz/25%-128K
>        614 ~ 5%     -25.0%        460 ~ 5%  lkp-sb03/nuttcp/300s
>       1881 ~ 5%     -21.8%       1472 ~ 5%  TOTAL slabinfo.kmem_cache_node.num_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       1.05 ~ 6%     -20.1%       0.84 ~ 5%  bens/qperf/600s
>       1.05 ~ 6%     -20.1%       0.84 ~ 5%  TOTAL perf-profile.cpu-cycles.tcp_rcv_established.tcp_v4_do_rcv.tcp_prequeue_process.tcp_recvmsg.inet_recvmsg
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      10097 ~ 0%     +26.7%      12797 ~ 2%  bens/qperf/600s
>      10097 ~ 0%     +26.7%      12797 ~ 2%  TOTAL softirqs.HRTIMER
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       0.78 ~ 3%     +22.5%       0.96 ~ 3%  bens/qperf/600s
>       0.78 ~ 3%     +22.5%       0.96 ~ 3%  TOTAL perf-profile.cpu-cycles.tcp_v4_rcv.ip_local_deliver_finish.ip_local_deliver.ip_rcv_finish.ip_rcv
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>  2.835e+09 ~ 0%     -16.5%  2.368e+09 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>  2.835e+09 ~ 0%     -16.5%  2.368e+09 ~ 0%  TOTAL cpuidle.C1-IVT.time
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>    5915033 ~13%     +14.3%    6761676 ~ 7%  ivb43/netperf/300s-25%-TCP_CRR
>    5915033 ~13%     +14.3%    6761676 ~ 7%  TOTAL meminfo.DirectMap2M
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>     264559 ~ 0%     +15.6%     305707 ~ 0%  bens/iperf/300s-tcp
>     264559 ~ 0%     +15.6%     305707 ~ 0%  TOTAL softirqs.TIMER
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      92365 ~ 3%     -12.9%      80487 ~ 9%  ivb44/pigz/25%-128K
>      92365 ~ 3%     -12.9%      80487 ~ 9%  TOTAL meminfo.DirectMap4k
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   24143956 ~ 3%      -8.1%   22198708 ~ 5%  ivb43/netperf/300s-25%-TCP_CRR
>   24143956 ~ 3%      -8.1%   22198708 ~ 5%  TOTAL numa-numastat.node1.numa_hit
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   24140149 ~ 3%      -8.1%   22196166 ~ 5%  ivb43/netperf/300s-25%-TCP_CRR
>   24140149 ~ 3%      -8.1%   22196166 ~ 5%  TOTAL numa-numastat.node1.local_node
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   12512229 ~ 3%      -7.6%   11556940 ~ 6%  ivb43/netperf/300s-25%-TCP_CRR
>   12512229 ~ 3%      -7.6%   11556940 ~ 6%  TOTAL numa-vmstat.node1.numa_hit
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   12407607 ~ 3%      -7.0%   11539395 ~ 6%  ivb43/netperf/300s-25%-TCP_CRR
>   12407607 ~ 3%      -7.0%   11539395 ~ 6%  TOTAL numa-vmstat.node1.numa_local
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   25536237 ~ 3%      +6.8%   27272147 ~ 5%  ivb43/netperf/300s-25%-TCP_CRR
>   25536237 ~ 3%      +6.8%   27272147 ~ 5%  TOTAL numa-numastat.node0.local_node
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   25538777 ~ 3%      +6.8%   27275952 ~ 5%  ivb43/netperf/300s-25%-TCP_CRR
>   25538777 ~ 3%      +6.8%   27275952 ~ 5%  TOTAL numa-numastat.node0.numa_hit
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       1159 ~ 3%     -10.9%       1033 ~ 1%  xbm/pigz/25%-512K
>       1159 ~ 3%     -10.9%       1033 ~ 1%  TOTAL slabinfo.kmalloc-96.num_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       1159 ~ 3%     -10.9%       1033 ~ 1%  xbm/pigz/25%-512K
>       1159 ~ 3%     -10.9%       1033 ~ 1%  TOTAL slabinfo.kmalloc-96.active_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       1.33 ~ 2%     -10.5%       1.19 ~ 3%  bens/qperf/600s
>       1.33 ~ 2%     -10.5%       1.19 ~ 3%  TOTAL perf-profile.cpu-cycles.tcp_sendmsg.inet_sendmsg.sock_aio_write.do_sync_write.vfs_write
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       1126 ~ 1%      -9.7%       1017 ~ 1%  bens/iperf/300s-tcp
>       1126 ~ 1%      -9.7%       1017 ~ 1%  TOTAL proc-vmstat.pgactivate
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      12269 ~ 4%      +5.5%      12946 ~ 4%  ivb43/netperf/300s-25%-TCP_CRR
>      12269 ~ 4%      +5.5%      12946 ~ 4%  TOTAL slabinfo.kmalloc-192.num_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      12258 ~ 4%      +5.6%      12946 ~ 4%  ivb43/netperf/300s-25%-TCP_CRR
>      12258 ~ 4%      +5.6%      12946 ~ 4%  TOTAL slabinfo.kmalloc-192.active_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       1.16 ~ 4%      +9.2%       1.26 ~ 3%  ivb43/netperf/300s-25%-TCP_CRR
>       1.16 ~ 4%      +9.2%       1.26 ~ 3%  TOTAL perf-profile.cpu-cycles.get_next_timer_interrupt.tick_nohz_stop_sched_tick.__tick_nohz_idle_enter.tick_nohz_idle_enter.cpu_idle_loop
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       3135 ~ 2%      +8.4%       3398 ~ 1%  ivb44/pigz/25%-128K
>       3135 ~ 2%      +8.4%       3398 ~ 1%  TOTAL slabinfo.task_xstate.active_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>       3135 ~ 2%      +8.4%       3398 ~ 1%  ivb44/pigz/25%-128K
>       3135 ~ 2%      +8.4%       3398 ~ 1%  TOTAL slabinfo.task_xstate.num_objs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      11496 ~ 5%     -96.2%        435 ~12%  bens/iperf/300s-tcp
>      23777 ~ 1%     -86.3%       3264 ~10%  bens/qperf/600s
>      22961 ~ 1%     -76.7%       5351 ~ 4%  ivb44/pigz/25%-128K
>      13976 ~ 2%     -97.5%        349 ~22%  lkp-sb03/nuttcp/300s
>      11345 ~ 0%     -88.0%       1361 ~25%  xbm/pigz/25%-512K
>      83555 ~ 2%     -87.1%      10761 ~ 9%  TOTAL time.involuntary_context_switches
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>   36820683 ~ 0%     +17.5%   43253042 ~ 0%  bens/qperf/600s
>   36820683 ~ 0%     +17.5%   43253042 ~ 0%  TOTAL time.voluntary_context_switches
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      13302 ~ 0%     +49.0%      19817 ~14%  bens/iperf/300s-tcp
>      62977 ~ 0%     +17.3%      73856 ~ 0%  bens/qperf/600s
>      76279 ~ 0%     +22.8%      93674 ~ 3%  TOTAL vmstat.system.in
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      23681 ~ 0%     +48.9%      35273 ~15%  bens/iperf/300s-tcp
>     122654 ~ 0%     +17.4%     143989 ~ 0%  bens/qperf/600s
>     759769 ~ 0%     -10.5%     680088 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>     906105 ~ 0%      -5.2%     859351 ~ 1%  TOTAL vmstat.system.cs
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        144 ~ 0%      +5.4%        152 ~ 0%  bens/qperf/600s
>        144 ~ 0%      +5.4%        152 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        122 ~ 0%      -4.2%        116 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>            ~ 0%      -4.2%            ~ 0%  TOTAL turbostat.Cor_W
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        299 ~ 0%      -2.8%        290 ~ 2%  bens/iperf/300s-tcp
>        863 ~ 0%      +5.2%        908 ~ 0%  bens/qperf/600s
>       1162 ~ 0%      +3.2%       1199 ~ 0%  TOTAL time.system_time
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>        153 ~ 0%      -3.3%        147 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>            ~ 0%      -3.3%            ~ 0%  TOTAL turbostat.Pkg_W
> 
> 221031cb1b33258  34577530114e9b1de10f3aa96  
> ---------------  -------------------------  
>      33.55 ~ 0%      +1.7%      34.12 ~ 0%  ivb43/netperf/300s-25%-TCP_CRR
>      33.55 ~ 0%      +1.7%      34.12 ~ 0%  TOTAL turbostat.%c0
> 
> 
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
> 
> 
>                                  iperf.tcp.sender.bps
> 
>   2.4e+10 ++----------O--------------------------------------O--------------+
>           O     O  O     O     O  O  O  O  O  O  O  O  O        O           |
>   2.2e+10 ++ O              O                                      O        |
>     2e+10 ++                                                                |
>           |                                               O                 |
>   1.8e+10 ++                                                                |
>   1.6e+10 ++                                                                |
>           |                                                                 |
>   1.4e+10 ++                                                                |
>   1.2e+10 ++                                                                |
>           |                                                                 |
>     1e+10 ++                                                                |
>     8e+09 ++                                                                |
>           *..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*
>     6e+09 ++----------------------------------------------------------------+
> 
> 
>                                 iperf.tcp.receiver.bps
> 
>   2.4e+10 ++----------O--------------------------------------O--------------+
>           O     O  O     O     O  O  O  O  O  O  O  O  O        O           |
>   2.2e+10 ++ O              O                                      O        |
>     2e+10 ++                                                                |
>           |                                               O                 |
>   1.8e+10 ++                                                                |
>   1.6e+10 ++                                                                |
>           |                                                                 |
>   1.4e+10 ++                                                                |
>   1.2e+10 ++                                                                |
>           |                                                                 |
>     1e+10 ++                                                                |
>     8e+09 ++                                                                |
>           *..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*
>     6e+09 ++----------------------------------------------------------------+
> 
> 
>                           time.involuntary_context_switches
> 
>   14000 ++------------------------------------------------------------------+
>         |                                                                   |
>   12000 *+.        .*..  ..*..*..*..*..  .*..*..*..*..*..  ..*..*..*..*..   *
>         |    .*..*.    *.              *.                *.               ..|
>   10000 ++ *.                                                            *  |
>         |                                                                   |
>    8000 ++                                                                  |
>         |                                                                   |
>    6000 ++                                                                  |
>         |                                                                   |
>    4000 ++                                                                  |
>         |                                                                   |
>    2000 ++                                                                  |
>         |     O                                          O                  |
>       0 O+-O-----O--O--O---O--O--O--O--O--O--O--O--O--O------O--O--O--------+
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> Thanks,
> Fengguang

> ./iperf3 -s
> ./iperf3 -t 300 -f M -J -c 127.0.0.1

