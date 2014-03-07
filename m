Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaCGLc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:32:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:9683 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaCGLcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:32:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,607,1389772800"; 
   d="scan'208";a="495781567"
Message-ID: <5319AE49.2000606@intel.com>
Date: Fri, 07 Mar 2014 19:32:25 +0800
From: Jet Chen <jet.chen@intel.com>
Reply-To: 20140305110238.GS9987@twins.programming.kicks-ass.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Kirill Tkhai <ktkhai@parallels.com>, Juri Lelli <juri.lelli@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [sched/idle] c365c292d05: ltp.sched_rr_get_interval02.1.TFAIL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> Does: http://lkml.kernel.org/r/20140301191838.d15d03112b2598a671dac22c@gmail.com
>
> Fix it?

Both patches can fix the LTP regression.

We applied each of Juri's and Kirill's patches on top of Thomas' commit,
and here are the comparisons:

test case: ltp/syscalls

Thomas'          Juri's
c365c292d05908c  ffc78ca31d51f90c516bb50cf
---------------  -------------------------
         1 ~ 0%    -100.0%          0 ~ 0%  TOTAL ltp.sched_rr_get_interval02.1.TFAIL
     73790 ~ 5%     -14.1%      63363 ~ 6%  TOTAL interrupts.IWI
      3040 ~ 4%      -6.7%       2836 ~ 5%  TOTAL slabinfo.kmalloc-128.num_objs

Thomas'          Kirill's
c365c292d05908c  f4262311faf6f326bf27fb1f4
---------------  -------------------------
         1 ~ 0%    -100.0%          0 ~ 0%  TOTAL ltp.sched_rr_get_interval02.1.TFAIL
      3618 ~ 6%     -13.2%       3141 ~ 6%  TOTAL slabinfo.anon_vma.active_objs
      3671 ~ 5%     -11.3%       3258 ~ 4%  TOTAL slabinfo.anon_vma.num_objs
      8.41 ~ 2%      -5.1%       7.98 ~ 3%  TOTAL boottime.dhcp
     15.90 ~ 2%      -3.2%      15.40 ~ 2%  TOTAL boottime.boot
     55.18 ~ 1%      -2.6%      53.73 ~ 1%  TOTAL boottime.idle

Thanks,
-Jet

