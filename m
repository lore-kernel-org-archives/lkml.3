Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaCDNGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:06:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:52664 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942AbaCDNGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:06:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,584,1389772800"; 
   d="scan'208";a="485769104"
Date: Tue, 4 Mar 2014 21:05:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched/balance] 18e6296b85e: -96.9% interrupts.RES
Message-ID: <20140304130559.GA28781@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

FYI, we noticed the below changes on

https://github.com/alexshi/power-scheduling.git single-balance
commit 18e6296b85ea72c81aa485653d442ad88296d475 ("sched/balance: central balance prototype")

test case: snb-drag/crypto/tcrypt/2s-301-319

598143917dc5ecf  18e6296b85ea72c81aa485653  
---------------  -------------------------  
    206307 ~ 0%     -96.9%       6337 ~ 4%  TOTAL interrupts.RES
    506552 ~ 1%     -24.3%     383290 ~ 3%  TOTAL cpuidle.C6-SNB.usage
     18.27 ~ 9%   +1063.5%     212.53 ~25%  TOTAL time.system_time
         1 ~30%   +1262.5%         21 ~31%  TOTAL time.percent_of_cpu_this_job_got
       821 ~12%     -22.3%        638 ~19%  TOTAL vmstat.system.in



                                 time.system_time

   400 ++-------------------------------------------------------------------+
       |                                                                    |
   350 ++        O         O    O                                           |
   300 ++O  O                     O                                         |
       O      O         O    O       O O                                    |
   250 ++          O                          O                             |
       |              O                          O                          |
   200 ++                                                                   |
       |                                  O                                 |
   150 ++                                   O                               |
   100 ++                                                                   |
       |                                                                    |
    50 ++                                                                   |
       *.*..*.*..*.*..*.*..*.*..*.*..*.*..*.*.*..*.*..*.*..*.*..*.*..*.*..*.*
     0 ++-------------------------------------------------------------------+


Thanks,
Fengguang
