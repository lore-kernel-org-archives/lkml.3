Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaEOEzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:55:22 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:38680 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaEOEzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:55:21 -0400
Date: Thu, 15 May 2014 00:55:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [cgroup] a0f9ec1f181: -4.3% will-it-scale.per_thread_ops
Message-ID: <20140515045517.GC3825@htj.dyndns.org>
References: <5374479F.3050507@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374479F.3050507@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 15, 2014 at 12:50:39PM +0800, Jet Chen wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kill-tree_mutex
> commit a0f9ec1f181534694cb5bf40b7b56515b8cabef9 ("cgroup: use cgroup_kn_lock_live() in other cgroup kernfs methods")
> 
> Test case : lkp-nex05/will-it-scale/writeseek
> 
> 2074b6e38668e62  a0f9ec1f181534694cb5bf40b
> ---------------  -------------------------
>    1027273 ~ 0%      -4.3%     982732 ~ 0%  TOTAL will-it-scale.per_thread_ops
>        136 ~ 3%     -43.1%         77 ~43%  TOTAL proc-vmstat.nr_dirtied
>       0.51 ~ 3%     +98.0%       1.01 ~ 4%  TOTAL perf-profile.cpu-cycles.shmem_write_end.generic_perform_write.__generic_file_aio_write.generic_file_aio_write.do_sync_write
>       1078 ~ 9%     -16.3%        903 ~11%  TOTAL numa-meminfo.node0.Unevictable
>        269 ~ 9%     -16.2%        225 ~11%  TOTAL numa-vmstat.node0.nr_unevictable
>       1.64 ~ 1%     -14.3%       1.41 ~ 4%  TOTAL perf-profile.cpu-cycles.find_lock_entry.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_aio_write
>       1.62 ~ 2%     +14.1%       1.84 ~ 1%  TOTAL perf-profile.cpu-cycles.lseek64

I have no idea how to read the above.  Which direction is plus and
which is minus?  Are they counting cpu cycles?  Which files is the
test seeking?

Thanks.

-- 
tejun
