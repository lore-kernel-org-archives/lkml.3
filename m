Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaI3IOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:14:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:9877 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaI3IOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:14:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="607427747"
Date: Tue, 30 Sep 2014 16:14:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [compiler/gcc4] a9f180345f5: -100.0% last_state.is_incomplete_run
Message-ID: <20140930081412.GF9561@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

FYI, we noticed that your commit a9f180345f5378ac87d80ed0bea55ba421d83859
("compiler/gcc4: Make quirk for asm_volatile_goto() unconditional") fixed
a number of machine boot failures in our LKP test farm. This is really helpful!
Our gcc version is 4.9.1 (Debian 4.9.1-11).

569d6557ab957d6  a9f180345f5378ac87d80ed0b
---------------  -------------------------
     %stddev        %change               %stddev
            \          |                 /
         1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
         1 ± 0%    -100.0%          0 ± 0%  TOTAL dmesg.kernel_BUG_at_fs/nfs/pagelist.c

569d6557ab957d6  a9f180345f5378ac87d80ed0b
---------------  -------------------------
         1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
         1 ± 0%    -100.0%          0 ± 0%  TOTAL dmesg.Kernel_panic-not_syncing:Fatal_exception

569d6557ab957d6  a9f180345f5378ac87d80ed0b
---------------  -------------------------
         1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
         1 ± 0%    -100.0%          0 ± 0%  TOTAL dmesg.invalid_opcode

569d6557ab957d6  a9f180345f5378ac87d80ed0b
---------------  -------------------------
         1 ± 0%    -100.0%          0 ± 0%  ivb42/will-it-scale/futex4
         1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-1t-1HDD-xfs-4M-60G-NoSync
         1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-64t-1BRD_48G-btrfs-4M-40G-fsyncBeforeClose
         1 ± 0%    -100.0%          0 ± 0%  lkp-bdw01/blogbench/1SSD-btrfs
         1 ± 0%    -100.0%          0 ± 0%  lkp-hsw01/vm-scalability/300s-anon-rx-rand-mt
         1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/futex3
         1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/page_fault3
         1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
         8 ± 0%    -100.0%          0 ± 0%  TOTAL last_state.is_incomplete_run

569d6557ab957d6  a9f180345f5378ac87d80ed0b
---------------  -------------------------
         1 ± 0%    -100.0%          0 ± 0%  ivb42/will-it-scale/futex4
         1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-1t-1HDD-xfs-4M-60G-NoSync
         1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-64t-1BRD_48G-btrfs-4M-40G-fsyncBeforeClose
         1 ± 0%    -100.0%          0 ± 0%  lkp-bdw01/blogbench/1SSD-btrfs
         1 ± 0%    -100.0%          0 ± 0%  lkp-hsw01/vm-scalability/300s-anon-rx-rand-mt
         1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/futex3
         1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/page_fault3
         1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
         8 ± 0%    -100.0%          0 ± 0%  TOTAL last_state.booting

Thanks,
Fengguang
