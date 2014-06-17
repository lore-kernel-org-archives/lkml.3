Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaFQTJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:09:00 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54532 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFQTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:08:59 -0400
Date: Tue, 17 Jun 2014 15:08:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        lkp@01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [idr] WARNING: at lib/idr.c:669 idr_find_slowpath()
Message-ID: <20140617190855.GN31819@htj.dyndns.org>
References: <539AB2F4.1040700@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AB2F4.1040700@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:14:44PM +0800, Jet Chen wrote:
> Hi Tejun,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 0ffc2a9c8072969253a20821c2c733a2cbb4c7c7
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Wed Feb 27 17:05:08 2013 -0800
> Commit:     Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Wed Feb 27 19:10:21 2013 -0800
> 
>     idr: implement lookup hint
...
> [   17.603698] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
> [   17.798944] ------------[ cut here ]------------
> [   17.798972] WARNING: at lib/idr.c:669 idr_find_slowpath+0x28/0xca()
> [   17.798973] Hardware name: Bochs
> [   17.798976] Pid: 655, comm: trinity-main Not tainted 3.8.0-06482-g0ffc2a9 #68
> [   17.798976] Call Trace:
> [   17.798989]  [<c022ace6>] warn_slowpath_common+0x72/0x89
> [   17.798992]  [<c051f001>] ? idr_find_slowpath+0x28/0xca
> [   17.798994]  [<c051f001>] ? idr_find_slowpath+0x28/0xca
> [   17.798997]  [<c022ad9b>] warn_slowpath_null+0x1d/0x1f
> [   17.798999]  [<c051f001>] idr_find_slowpath+0x28/0xca
> [   17.799007]  [<c027fab7>] perf_init_event+0x82/0x124
> [   17.799013]  [<c024321f>] ? __mutex_init+0x3f/0x44
> [   17.799015]  [<c027fda9>] perf_event_alloc+0x250/0x360
> [   17.799018]  [<c028040e>] sys_perf_event_open+0x336/0x664
> [   17.799036]  [<c0944280>] syscall_call+0x7/0xb
> [   17.799042]  [<c0940000>] ? SetAgcIf.isra.6+0x156/0x290
> [   17.799043] ---[ end trace 8e00e88be2b81021 ]---
> [   76.161086] Unregister pv shared memory for cpu 0

This is perf_init_event() invoking idr_find() with negative ID
triggering the warning.  The warning was removed quite some time ago.

Thanks.

-- 
tejun
