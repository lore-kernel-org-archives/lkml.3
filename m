Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbaFRFJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:09:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:32910 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbaFRFI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,499,1400050800"; 
   d="scan'208";a="549618803"
Message-ID: <53A11E58.3030003@intel.com>
Date: Wed, 18 Jun 2014 13:06:32 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Fengguang Wu <fengguang.wu@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [x86_64,vsyscall] 21d4ab4881a: -11.1% will-it-scale.per_process_ops
Content-Type: multipart/mixed;
 boundary="------------070509040904070600070609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070509040904070600070609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andy,

we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vsyscall
commit 21d4ab4881ad9b257bec75d04480105dad4336e1 ("x86_64,vsyscall: Move all of the gate_area code to vsyscall_64.c")

test case: lkp-wsx01/will-it-scale/signal1

a7781f1035319a7  21d4ab4881ad9b257bec75d04
---------------  -------------------------
     259032 ~ 1%     -11.1%     230288 ~ 0%  TOTAL will-it-scale.per_process_ops
       0.04 ~ 9%   +4276.2%       1.84 ~ 1%  TOTAL perf-profile.cpu-cycles.map_id_up.do_tkill.sys_tgkill.system_call_fastpath.raise
       2.36 ~ 0%     -63.8%       0.85 ~ 2%  TOTAL perf-profile.cpu-cycles._atomic_dec_and_lock.free_uid.__sigqueue_free.__dequeue_signal.dequeue_signal
       2.25 ~14%     -55.2%       1.01 ~ 1%  TOTAL perf-profile.cpu-cycles.raise
      42.41 ~ 0%     +34.5%      57.04 ~ 0%  TOTAL perf-profile.cpu-cycles.__sigqueue_alloc.__send_signal.send_signal.do_send_sig_info.do_send_specific
      40.70 ~ 0%     -23.9%      30.96 ~ 0%  TOTAL perf-profile.cpu-cycles.__sigqueue_free.part.11.__dequeue_signal.dequeue_signal.get_signal_to_deliver.do_signal
        252 ~11%     -18.8%        204 ~ 9%  TOTAL numa-vmstat.node1.nr_page_table_pages
       1012 ~11%     -18.3%        827 ~ 9%  TOTAL numa-meminfo.node1.PageTables
        520 ~ 7%     -17.1%        431 ~ 5%  TOTAL cpuidle.C1-NHM.usage

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                             will-it-scale.per_process_ops

   270000 ++-----------------------------------------------------------------+
          |                                                                  |
   260000 *+.*..*..     .*..  .*..  .*..*...  .*..   *..  .*..   *..     .*..*
          |        *..*.    *.    *.        *.     ..   *.     ..   *..*.    |
   250000 ++                                      *           *              |
          |                                                                  |
   240000 ++                                                                 |
          |                                                                  |
   230000 ++ O  O  O     O  O                           O     O  O  O  O  O  |
          O                       O     O                                    |
   220000 ++                   O            O     O                          |
          |                          O         O     O     O                 |
   210000 ++          O                                                      |
          |                                                                  |
   200000 ++-----------------------------------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Jet


--------------070509040904070600070609
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce"

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu56/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu57/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu58/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu59/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu60/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu61/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu62/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu63/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu64/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu65/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu66/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu67/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu68/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu69/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu70/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu71/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu72/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu73/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu74/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu75/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu76/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu77/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu78/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu79/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
./runtest.py signal1 16 1 10 20 30 40 60 80


--------------070509040904070600070609--
