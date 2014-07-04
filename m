Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaGDDzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:55:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:4229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbaGDDzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,598,1400050800"; 
   d="scan'208";a="557304702"
Date: Fri, 4 Jul 2014 11:54:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Aaron Tomlin <atomlin@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kernel/watchdog.c] ed235875e2c: -14.2% will-it-scale.scalability
Message-ID: <20140704035455.GA5524@localhost>
References: <53B6235B.4050205@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B6235B.4050205@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sorry please ignore this report: it seems there are no obvious
relationship between the code change and the regression.

Thanks,
Fengguang

On Fri, Jul 04, 2014 at 11:45:31AM +0800, Jet Chen wrote:
> Hi Aaron,
> 
> FYI, we noticed the below changes on
> 
> commit ed235875e2ca983197831337a986f0517074e1a0 ("kernel/watchdog.c: print traces for all cpus on lockup detection")
> 
> test case: lkp-snb01/will-it-scale/signal1
> 
> f3aca3d09525f87  ed235875e2ca983197831337a
> ---------------  -------------------------
>       0.12 ~ 0%     -14.2%       0.10 ~ 0%  TOTAL will-it-scale.scalability
>     506146 ~ 0%      -4.4%     484004 ~ 0%  TOTAL will-it-scale.per_process_ops
>      12193 ~ 4%     +12.6%      13726 ~ 6%  TOTAL slabinfo.kmalloc-256.active_objs
>      12921 ~ 4%     +12.3%      14516 ~ 5%  TOTAL slabinfo.kmalloc-256.num_objs
>     123094 ~ 3%      -6.5%     115117 ~ 3%  TOTAL meminfo.Committed_AS
> 
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
> 
> 
>                             will-it-scale.per_process_ops
> 
>   515000 ++-----------------------------------------------------------------+
>          |  .*.*.*.*.     .*                                                |
>   510000 *+*         *.*.*  + .*.                               *.          |
>   505000 ++                  *   *.*.*.*. .* .*.*.*. .*.*.*.   +  *.*.*.*.*.*
>          |                               *  *       *       *.*             |
>   500000 ++                                                                 |
>          |                                                                  |
>   495000 ++                                                                 |
>          |                                                                  |
>   490000 ++                                                                 |
>   485000 ++            O O             O O  O O                             |
>          |         O O     O O O O O O     O    O                           |
>   480000 O+O O O O                                O                         |
>          |                                                                  |
>   475000 ++-----------------------------------------------------------------+
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
> Jet
> 

> echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
> echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
> ./runtest.py signal1 25 1 8 16 24 32
> 

