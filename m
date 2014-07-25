Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbaGYGo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:44:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:36079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbaGYGo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="567040763"
Message-ID: <53D1FCE7.4000606@intel.com>
Date: Fri, 25 Jul 2014 14:44:55 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Tom Herbert <therbert@google.com>
CC: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [net] 11ef7a8996d: +27.3% netperf.Throughput_Mbps
References: <53d1f50b.CEZoGFBjN5Kgc+zm%fengguang.wu@intel.com>	<53D1F9B5.8050500@intel.com> <CA+mtBx-26J=r_aH0Y72ghRhDpUCbEzRxkrA1Xmtame_msHKnUQ@mail.gmail.com>
In-Reply-To: <CA+mtBx-26J=r_aH0Y72ghRhDpUCbEzRxkrA1Xmtame_msHKnUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 02:37 PM, Tom Herbert wrote:
> Are you pointing out a regressions in this?

No, the report is an indication your commit makes the Throughput_Mbps of
the netperf benchamrk increased 27.3%, a good thing I think.

Thanks,
Aaron

> 
> On Thu, Jul 24, 2014 at 11:31 PM, Aaron Lu <aaron.lu@intel.com> wrote:
>> FYI, we noticed the below changes on
>>
>> commit 11ef7a8996d5d433c9cd75d80651297eccbf6d42 ("net: Performance fix for process_backlog")
>>
>> test case: lkp-t410/netperf/300s-200%-10K-SCTP_STREAM_MANY
>>
>> 68b7107b62983f2  11ef7a8996d5d433c9cd75d80
>> ---------------  -------------------------
>>       1023 ~ 3%     +27.3%       1302 ~ 0%  TOTAL netperf.Throughput_Mbps
>>       0.72 ~10%     -91.4%       0.06 ~23%  TOTAL turbostat.%c3
>>      13385 ~12%     -92.6%        987 ~12%  TOTAL cpuidle.C6-NHM.usage
>>      22745 ~10%     -95.5%       1016 ~40%  TOTAL cpuidle.C3-NHM.usage
>>   42675736 ~12%     -84.6%    6571705 ~19%  TOTAL cpuidle.C6-NHM.time
>>      88342 ~11%     -82.1%      15811 ~ 9%  TOTAL softirqs.SCHED
>>   19148006 ~12%     -95.7%     821873 ~27%  TOTAL cpuidle.C3-NHM.time
>>     439.94 ~10%     -77.5%      99.05 ~ 5%  TOTAL uptime.idle
>>       1.35 ~ 6%     -65.8%       0.46 ~24%  TOTAL turbostat.%c6
>>          4 ~23%    +114.3%          9 ~ 0%  TOTAL vmstat.procs.r
>>       1680 ~ 3%     +40.4%       2359 ~ 3%  TOTAL proc-vmstat.nr_alloc_batch
>>     447921 ~ 4%     +36.2%     610047 ~ 0%  TOTAL softirqs.TIMER
>>       9.09 ~ 9%     +27.6%      11.60 ~ 8%  TOTAL perf-profile.cpu-cycles.memcpy.sctp_outq_flush.sctp_outq_uncork.sctp_cmd_interpreter.sctp_do_sm
>>    2350916 ~ 4%     +35.4%    3184088 ~ 0%  TOTAL proc-vmstat.pgalloc_dma
>>       7.82 ~ 9%     +24.1%       9.71 ~ 4%  TOTAL perf-profile.cpu-cycles.copy_user_generic_string.sctp_user_addto_chunk.sctp_datamsg_from_user.sctp_sendmsg.inet_sendmsg
>>   38837537 ~ 3%     +27.1%   49358639 ~ 0%  TOTAL proc-vmstat.numa_local
>>   38837537 ~ 3%     +27.1%   49358639 ~ 0%  TOTAL proc-vmstat.numa_hit
>>      50216 ~ 1%     +17.0%      58745 ~ 6%  TOTAL softirqs.RCU
>>       1.41 ~ 4%     +11.6%       1.58 ~ 1%  TOTAL perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_kmem_pages_node.kmalloc_large_node.__kmalloc_node_track_caller
>>      48539 ~ 1%     -25.5%      36171 ~ 1%  TOTAL vmstat.system.cs
>>      75.64 ~ 4%     +30.6%      98.82 ~ 0%  TOTAL turbostat.%c0
>>       3949 ~ 2%     +13.4%       4478 ~ 0%  TOTAL vmstat.system.in
>>
>> Legend:
>>         ~XX%    - stddev percent
>>         [+-]XX% - change percent
>>
>>
>>                                   vmstat.system.cs
>>
>>   52000 ++------------------------------------------------------------------+
>>   50000 ++  *      .*   *.                   **        *. *  *.             |
>>         | .* + *.**  *. : **.* .* .**.**. * +  +    *.*  * + : * .**. *.  .**
>>   48000 **    *        *      *  *       * *    * .*        *   *    *  **  |
>>   46000 ++                                       *                          |
>>         |                                                                   |
>>   44000 ++                                                                  |
>>   42000 ++                                                                  |
>>   40000 ++                                                                  |
>>         |                                                                   |
>>   38000 +O  O                      O                                        |
>>   36000 O+    O  O   O  O OO OO OO  O  O   O  O  O OO  O OO O               |
>>         |  O   O  O O  O                  O           O                     |
>>   34000 ++                            O  O   O  O                           |
>>   32000 ++------------------------------------------------------------------+
>>
>>
>>         [*] bisect-good sample
>>         [O] bisect-bad  sample
>>
>>
>> Disclaimer:
>> Results have been estimated based on internal Intel analysis and are provided
>> for informational purposes only. Any difference in system hardware or software
>> design or configuration may affect actual performance.
>>
>> Thanks,
>> Aaron

