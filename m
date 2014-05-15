Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaEOGO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:14:27 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37827 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaEOGO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:14:26 -0400
Date: Thu, 15 May 2014 02:14:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [cgroup] a0f9ec1f181: -4.3% will-it-scale.per_thread_ops
Message-ID: <20140515061422.GC5539@mtj.dyndns.org>
References: <5374479F.3050507@intel.com>
 <20140515045517.GC3825@htj.dyndns.org>
 <20140515060026.GA12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515060026.GA12710@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Fengguang.

On Thu, May 15, 2014 at 02:00:26PM +0800, Fengguang Wu wrote:
> > > 2074b6e38668e62  a0f9ec1f181534694cb5bf40b
> > > ---------------  -------------------------
> 
> 2074b6e38668e62 is the base of comparison. So "-4.3% will-it-scale.per_thread_ops"
> in the below line means a0f9ec1f18 has lower will-it-scale throughput.
> 
> > >    1027273 ~ 0%      -4.3%     982732 ~ 0%  TOTAL will-it-scale.per_thread_ops
> > >        136 ~ 3%     -43.1%         77 ~43%  TOTAL proc-vmstat.nr_dirtied
> > >       0.51 ~ 3%     +98.0%       1.01 ~ 4%  TOTAL perf-profile.cpu-cycles.shmem_write_end.generic_perform_write.__generic_file_aio_write.generic_file_aio_write.do_sync_write
> > >       1078 ~ 9%     -16.3%        903 ~11%  TOTAL numa-meminfo.node0.Unevictable
> > >        269 ~ 9%     -16.2%        225 ~11%  TOTAL numa-vmstat.node0.nr_unevictable
> > >       1.64 ~ 1%     -14.3%       1.41 ~ 4%  TOTAL perf-profile.cpu-cycles.find_lock_entry.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_aio_write
> > >       1.62 ~ 2%     +14.1%       1.84 ~ 1%  TOTAL perf-profile.cpu-cycles.lseek64
> 
> The perf-profile.cpu-cycles.* lines are from "perf record/report".
> 
> The last line shows that lseek64() takes 1.62% CPU cycles for
> commit 2074b6e38668e62 and that percent increased by +14.1% on
> a0f9ec1f181. One of the raw perf record output is
> 
>      1.84%  writeseek_proce  libc-2.17.so         [.] lseek64                               
>             |
>             --- lseek64
> 
> There are 5 runs and 1.62% is the average value.
> 
> > I have no idea how to read the above.  Which direction is plus and
> > which is minus? Are they counting cpu cycles?  Which files is the
> > test seeking?
> 
> It's tmpfs files. Because the will-it-scale test case is mean to
> measure scalability of syscalls. We do not use HDD/SSD etc. storage
> devices when running it.

Hmmm... I'm completely stumped.  The commit in question has nothing to
do with tmpfs.  It only affects three cgroup files - "tasks",
"cgroup.procs" and "release_agent".  It can't possibly have any effect
on tmpfs operation.  Maybe random effect through code alignment?  Even
that is highly unlikely.  I'll look into it tomorrow but can you
please try to repeat the test?  It really doesn't make any sense to
me.

Thanks.

-- 
tejun
