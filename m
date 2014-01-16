Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaAPDIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:08:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:17523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbaAPDHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:07:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="459588970"
Date: Thu, 16 Jan 2014 11:07:44 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: [slub shrink] 0f6934bf16: +191.9% vmstat.system.cs
Message-ID: <20140116030744.GA19349@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

We noticed increased context switches in the will-it-scale/read2
test case. Test box is a 4S IVB-EX server. The other change is
increased oltp.request_latency_max_ms in a NHM desktop.

commit 0f6934bf1695682e7ced973f67d57ab9e124c325
Author:     Dave Hansen <dave.hansen@intel.com>
AuthorDate: Mon Jan 13 07:40:46 2014 -0800

    for Fenguang to test

git tree branch is

        https://github.com/hansendc/linux.git  slub-reshrink-for-Fengguang-20140113

% compare -ab 0f6934bf1695682e7ced973f67d57ab9e124c325~ 0f6934bf1695682e7ced973f67d57ab9e124c325
9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
     15.26 ~ 3%     +19.7%      18.26 ~ 4%  nhm-white/sysbench/oltp/600s-100%-1000000
     15.26          +19.7%      18.26       TOTAL oltp.request_latency_max_ms

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
   8235933 ~ 2%     +80.6%   14872911 ~ 3%  lkp-sbx04/micro/will-it-scale/read2
   8235933          +80.6%   14872911       TOTAL interrupts.RES

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
    161531 ~ 7%    +191.9%     471544 ~ 9%  lkp-sbx04/micro/will-it-scale/read2
    161531         +191.9%     471544       TOTAL vmstat.system.cs

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
     32943 ~ 1%     +71.8%      56599 ~ 3%  lkp-sbx04/micro/will-it-scale/read2
     32943          +71.8%      56599       TOTAL vmstat.system.in

                                   vmstat.system.cs

   600000 ++---------O------------------------------------------------------+
   550000 ++            O                                                   |
          |        O       O  O             O  O           O  O             |
   500000 O+ O  O                                                           |
   450000 ++                     O  O  O          O  O                      |
   400000 ++                              O             O                   |
   350000 ++                                                                |
          |                                                                 |
   300000 ++                                                                |
   250000 ++                                                                |
   200000 ++      .*                          .*..                          |
   150000 *+.  .*.  :   *..*..*..*..*..*.. .*.      .*..  .*..*..*.*..  .*..*
          |  *.     : ..                  *       *.    *.            *.    |
   100000 ++         *                                                      |
    50000 ++----------------------------------------------------------------+

Thanks,
Fengguang
