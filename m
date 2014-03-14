Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaCNGUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:20:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:52179 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbaCNGUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:20:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,652,1389772800"; 
   d="scan'208";a="491746997"
Date: Fri, 14 Mar 2014 14:20:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched] 373e9ec30ad: -11.2% qperf.udp_bw.send_bw.MB_sec
Message-ID: <20140314062043.GA28336@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20140314061643.GA28194@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Alex, we noticed the below changes on

https://github.com/alexshi/power-scheduling.git single-balance
commit 373e9ec30ad1efee2c4ba6b58fc317626e6482d0 ("sched: only do load balance on tick_do_timer_cpu")

test case: lkp-a06/micro/qperf/600s

      v3.14-rc6  373e9ec30ad1efee2c4ba6b58  
---------------  -------------------------  
       273 ~ 0%     -11.2%        242 ~ 1%  TOTAL qperf.udp_bw.send_bw.MB_sec
       268 ~ 0%      -9.8%        242 ~ 0%  TOTAL qperf.tcp_bw.bw.MB_sec
       266 ~ 0%      -9.8%        240 ~ 1%  TOTAL qperf.udp_bw.recv_bw.MB_sec
     48281 ~ 2%     -81.3%       9035 ~ 1%  TOTAL softirqs.SCHED
   1359067 ~ 4%     -30.7%     942510 ~ 2%  TOTAL interrupts.RES
  10201776 ~14%     -30.1%    7133067 ~10%  TOTAL cpuidle.C3.time
  52277488 ~ 4%     -26.6%   38366608 ~ 6%  TOTAL cpuidle.C2.time
        28 ~14%     -25.3%         21 ~18%  TOTAL cpuidle.POLL.usage
      1516 ~16%     -27.0%       1107 ~22%  TOTAL cpuidle.POLL.time
      3955 ~ 7%     -24.8%       2972 ~14%  TOTAL cpuidle.C3.usage
      1.10 ~ 9%     -17.0%       0.91 ~16%  TOTAL perf-profile.cpu-cycles.menu_select.cpuidle_idle_call.arch_cpu_idle.cpu_startup_entry.start_secondary
   9066611 ~ 0%      -8.3%    8313872 ~ 1%  TOTAL proc-vmstat.pgalloc_dma32
  24350865 ~ 0%      -8.3%   22328921 ~ 1%  TOTAL proc-vmstat.pgfree
  15285179 ~ 0%      -8.3%   14016032 ~ 1%  TOTAL proc-vmstat.pgalloc_normal
      2961 ~ 3%     -19.7%       2378 ~ 3%  TOTAL vmstat.system.in
   3887389 ~20%      +9.7%    4262549 ~ 0%  TOTAL time.voluntary_context_switches
     14152 ~ 1%      +2.2%      14464 ~ 0%  TOTAL vmstat.system.cs

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                            qperf.udp_bw.send_bw.MB_sec

   280 ++-------------------------------------------------------------------+
       |                                        .*.....                     |
   275 *+...*.....*....        ...*....*....  ..       *                    |
   270 ++              *....*..             *.                              |
       |                                                                    |
   265 ++                                                                   |
   260 ++                                                                   |
       |                                                                    |
   255 ++                                                                   |
   250 ++                                              O                    |
       |                                                                    |
   245 ++                              O                                    |
   240 O+   O     O               O         O                    O     O    O
       |               O    O                               O               |
   235 ++----------------------------------------O--------------------------+

	[*] bisect-good sample
	[O] bisect-bad  sample

Thanks,
Fengguang

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

./qperf
./qperf 127.0.0.1 --time 100 tcp_bw tcp_lat udp_bw udp_lat sctp_bw sctp_lat quit

--HlL+5n6rz5pIUxbD--
