Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaDUG31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:29:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:64907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaDUG3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:29:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,895,1389772800"; 
   d="scan'208";a="516532670"
Message-ID: <5354BA85.6010003@intel.com>
Date: Mon, 21 Apr 2014 14:28:21 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [sched,rcu] 9234566d3a3: +1.6% will-it-scale.scalability, +1302.6%
 time.involuntary_context_switches
Content-Type: multipart/mixed;
 boundary="------------090305030900000304030409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090305030900000304030409
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Paul,

we noticed the below changes on
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git torture.2014.04.18a
commit 9234566d3a36c0aead8852e3c2ca94cd8ebfe219 ("sched,rcu: Make cond_resched() report RCU quiescent states")

Comparison 1 - parent commit of 9234566d3a36c0aead8852e3c2ca94cd8ebfe219 vs 9234566d3a36c0aead8852e3c2ca94cd8ebfe219

e119454e74a852f  9234566d3a36c0aead8852e3c
---------------  -------------------------
     1035948 ~ 0%      +1.6%    1052990 ~ 0%  TOTAL will-it-scale.per_thread_ops
     1271322 ~ 0%      +1.8%    1294004 ~ 0%  TOTAL will-it-scale.per_process_ops
        0.63 ~ 0%      -5.2%       0.60 ~ 0%  TOTAL will-it-scale.scalability
       22470 ~ 2%   +1302.6%     315168 ~ 2%  TOTAL time.involuntary_context_switches
       84265 ~ 5%   +1047.1%     966581 ~ 1%  TOTAL interrupts.IWI
        1828 ~44%    +189.6%       5295 ~13%  TOTAL time.voluntary_context_switches
        5337 ~ 1%     +82.1%       9720 ~ 1%  TOTAL vmstat.system.cs
      118599 ~ 0%     -30.4%      82545 ~ 0%  TOTAL interrupts.0:IO-APIC-edge.timer
      224021 ~ 4%     +34.7%     301858 ~ 2%  TOTAL interrupts.RES
       25148 ~ 0%      +7.0%      26917 ~ 0%  TOTAL vmstat.system.in
     7063439 ~ 0%      -5.2%    6694536 ~ 0%  TOTAL interrupts.LOC
      188866 ~ 0%      -3.1%     183008 ~ 0%  TOTAL interrupts.NMI
      188866 ~ 0%      -3.1%     183008 ~ 0%  TOTAL interrupts.PMI
        3720 ~ 0%      -1.5%       3665 ~ 0%  TOTAL time.system_time
        1215 ~ 0%      -1.4%       1198 ~ 0%  TOTAL time.percent_of_cpu_this_job_got


Comparison 2 - b84c4e08143c98dad4b4d139f08db0b98b0d3ec4 vs 9234566d3a36c0aead8852e3c2ca94cd8ebfe219

Fengguang has reported stats changes about b84c4e08143c98dad4b4d139f08db0b98b0d3ec4 to you days ago.
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git dev.2014.04.14a
commit b84c4e08143c98dad4b4d139f08db0b98b0d3ec4 ("sched,rcu: Make cond_resched() report RCU quiescent states")

Let's have a compare here.

b84c4e08143c98d  9234566d3a36c0aead8852e3c
---------------  -------------------------
      809309 ~ 0%      -2.6%     788400 ~ 0%  TOTAL will-it-scale.per_process_ops
        0.61 ~ 0%      -1.9%       0.60 ~ 0%  TOTAL will-it-scale.scalability
      434080 ~ 0%      -1.5%     427643 ~ 0%  TOTAL will-it-scale.per_thread_ops
           4 ~11%  +1.2e+05%       5249 ~ 2%  TOTAL interrupts.IWI
         607 ~ 7%     +28.0%        778 ~14%  TOTAL interrupts.47:PCI-MSI-edge.eth0
       12349 ~ 2%     -14.6%      10548 ~ 1%  TOTAL interrupts.0:IO-APIC-edge.timer
        3078 ~ 3%     +20.9%       3722 ~ 6%  TOTAL interrupts.RES


Comparison 3 - parent commit of b84c4e08143c98dad4b4d139f08db0b98b0d3ec4 vs b84c4e08143c98dad4b4d139f08db0b98b0d3ec4

Duplicated with Fengguang's report. Help you to see these info in a page :)

ad86a04266f9b49  b84c4e08143c98dad4b4d139f
---------------  -------------------------
      676264 ~ 0%      +3.3%     698461 ~ 0%  TOTAL will-it-scale.per_thread_ops
     1174547 ~ 0%      +3.0%    1209307 ~ 0%  TOTAL will-it-scale.per_process_ops
        1.67 ~ 0%      -2.3%       1.63 ~ 0%  TOTAL will-it-scale.scalability
       10522 ~ 2%    +921.2%     107463 ~ 1%  TOTAL time.involuntary_context_switches
       77671 ~ 3%     +67.0%     129688 ~ 3%  TOTAL interrupts.RES
       99502 ~ 0%     -27.8%      71813 ~ 0%  TOTAL interrupts.0:IO-APIC-edge.timer
        2554 ~ 0%     +49.1%       3809 ~ 1%  TOTAL vmstat.system.cs
       11524 ~ 0%      -2.3%      11259 ~ 0%  TOTAL vmstat.system.in
         213 ~ 0%      -4.3%        204 ~ 0%  TOTAL time.system_time
          74 ~ 0%      -4.1%         71 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
     3495099 ~ 0%      -3.1%    3387173 ~ 0%  TOTAL interrupts.LOC




Thanks,
Jet




--------------090305030900000304030409
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="reproduce"

Li9ydW50ZXN0LnB5IG9wZW4yIDMyIDEgNCA2IDgKCgo=
--------------090305030900000304030409--
