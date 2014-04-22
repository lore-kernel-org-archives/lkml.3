Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaDVBGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:06:11 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35294 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaDVBGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:06:07 -0400
Message-ID: <5355C07B.4040502@kernel.dk>
Date: Mon, 21 Apr 2014 19:06:03 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>, Hong Zhiguo <zhiguohong@tencent.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [blk] WARNING: CPU: 0 PID: 300 at kernel/softirq.c:156 _local_bh_enable_ip()
References: <53542E54.2060202@intel.com>
In-Reply-To: <53542E54.2060202@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-20 14:30, Jet Chen wrote:
> Hi Zhiguo,
>
> I got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 2c575026fae6e63771bd2a4c1d407214a8096a89
> Author:     Hong Zhiguo <zhiguohong@tencent.com>
> AuthorDate: Wed Nov 20 10:35:05 2013 -0700
> Commit:     Jens Axboe <axboe@kernel.dk>
> CommitDate: Wed Nov 20 15:33:04 2013 -0700
>
>      Update of blkg_stat and blkg_rwstat may happen in bh context.
>      While u64_stats_fetch_retry is only preempt_disable on 32bit
>      UP system. This is not enough to avoid preemption by bh and
>      may read strange 64 bit value.
>          Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
>      Acked-by: Tejun Heo <tj@kernel.org>
>      Cc: stable@kernel.org
>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
>
>
> +-----------------------------------------------------------+------------+------------+
> |                                                           | 82023bb7f7 | 2c575026fa |
> +-----------------------------------------------------------+------------+------------+
> | boot_successes                                            | 47         | 0          |
> | boot_failures                                             | 13         | 20         |
> | BUG:kernel_boot_hang                                      | 13         | 5          |
> | inconsistent_IN-SOFTIRQ-W-SOFTIRQ-ON-W_usage              | 0          | 15         |
> | backtrace:smpboot_thread_fn                               | 0          | 15         |
> | backtrace:vfs_read                                        | 0          | 9          |
> | backtrace:SyS_read                                        | 0          | 9          |
> | WARNING:CPU:PID:at_kernel/softirq.c:_local_bh_enable_ip() | 0          | 7          |
> | BUG:spinlock_lockup_suspected_on_CPU                      | 0          | 1          |
> | backtrace:do_mount                                        | 0          | 6          |
> | backtrace:SyS_mount                                       | 0          | 6          |
> | backtrace:async_run_entry_fn                              | 0          | 0          |
> +-----------------------------------------------------------+------------+------------+
>
> [   12.318816] WARNING: CPU: 0 PID: 300 at kernel/softirq.c:156 _local_bh_enable_ip+0x34/0x97()

Does this still happen with 3.15-rc2?

-- 
Jens Axboe

