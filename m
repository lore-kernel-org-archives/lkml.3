Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaCMJ3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:29:38 -0400
Received: from [143.182.124.37] ([143.182.124.37]:30517 "EHLO mga14.intel.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753677AbaCMJ3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:29:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,646,1389772800"; 
   d="scan'208";a="491125084"
Date: Thu, 13 Mar 2014 17:29:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        netdev@vger.kernel.org
Subject: [loopback] b17c706987f: +91.0% qperf.sctp_bw.bw.MB_sec
Message-ID: <20140313092933.GA31360@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

We are glad to notice this big performance gain on

git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
commit b17c706987fa6f28bdc1771c8266e7a69e22adcb ("loopback: sctp: add NETIF_F_SCTP_CSUM to device features")

test case: lkp-a06/micro/qperf/600s

72f8e06f3ea022d  b17c706987fa6f28bdc1771c8  
---------------  -------------------------  
     39.30 ~ 3%     +91.0%      75.06 ~11%  TOTAL qperf.sctp_bw.bw.MB_sec
       126 ~ 0%      -3.2%        122 ~ 0%  TOTAL qperf.sctp_lat.latency.us
    216270 ~ 2%     -46.5%     115740 ~ 4%  TOTAL cpuidle.C4.usage
  48722971 ~ 5%     +45.1%   70681678 ~ 7%  TOTAL cpuidle.C2.time
    370655 ~ 2%     +46.8%     543952 ~ 7%  TOTAL cpuidle.C2.usage
      1.00 ~13%     -22.8%       0.77 ~15%  TOTAL perf-profile.cpu-cycles.acpi_processor_ffh_cstate_enter.acpi_idle_enter_bm.cpuidle_enter_state.cpuidle_idle_call.arch_cpu_idle
  15233974 ~ 0%     +14.2%   17397187 ~ 3%  TOTAL proc-vmstat.pgalloc_normal
  24268359 ~ 0%     +14.2%   27716949 ~ 3%  TOTAL proc-vmstat.pgfree
   9034872 ~ 0%     +14.2%   10321019 ~ 3%  TOTAL proc-vmstat.pgalloc_dma32
     51262 ~ 2%     -10.0%      46151 ~ 3%  TOTAL time.involuntary_context_switches
     13874 ~ 1%      +4.8%      14540 ~ 0%  TOTAL vmstat.system.cs
       812 ~ 0%      -3.4%        784 ~ 1%  TOTAL time.system_time
   4125867 ~ 1%      +3.9%    4285302 ~ 0%  TOTAL time.voluntary_context_switches

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                              qperf.sctp_bw.bw.MB_sec

   90 ++------------------------------------------------------------O-------+
      |            O                             O                          |
   80 ++              O  O       O    O     O         O                     |
      O  O O  O                     O               O            O       O  |
      |          O          O            O    O                O            |
   70 ++                                                 O  O               O
      |                                                                O    |
   60 ++                      O                                             |
      |                                                                     |
   50 ++                                                                    |
      |                                                                     |
      |      .*..               .*..         .*..  .*.     .*..             |
   40 *+.*.*.    *.*..*..*..*.*.    *.*..*..*    *.   *..*.    *.*..*..*    |
      |                                                                     |
   30 ++--------------------------------------------------------------------+

	[O] bisect-bad  sample
	[*] bisect-good sample

Thanks,
Fengguang
