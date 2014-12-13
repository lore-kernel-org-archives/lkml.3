Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012AbaLMEEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 23:04:11 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:56027 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbaLMEEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 23:04:08 -0500
Message-ID: <548BBAB2.7010003@mvista.com>
Date: Fri, 12 Dec 2014 22:04:02 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [ipmi] BUG: key ffff880fcfc51ed0 not in .data!
References: <1418354422.5745.101.camel@intel.com>
In-Reply-To: <1418354422.5745.101.camel@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 09:20 PM, Huang Ying wrote:
> FYI, we noticed the below changes on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 2ed09fc090fc0488e2ab27604a141679fe2ef610 ("ipmi: clean up the device handling for the bmc device")

Thanks.  The surprising thing is that this didn't give an error before.

But this should be fixed in linux-next the next time.

Thanks again,

-corey

>
>
> +------------------------------------------------------------+------------+------------+
> |                                                            | 8425c1276b | 2ed09fc090 |
> +------------------------------------------------------------+------------+------------+
> | boot_successes                                             | 9          | 6          |
> | boot_failures                                              | 1          | 23         |
> | Out_of_memory:Kill_process                                 | 1          | 3          |
> | BUG:key#not_in.data                                        | 0          | 19         |
> | WARNING:at_kernel/locking/lockdep.c:#lockdep_init_map()    | 0          | 10         |
> | BUG:unable_to_handle_kernel                                | 0          | 19         |
> | Oops                                                       | 0          | 19         |
> | RIP:kernfs_name_hash                                       | 0          | 19         |
> | Kernel_panic-not_syncing:Fatal_exception                   | 0          | 19         |
> | backtrace:lockdep_init_map                                 | 0          | 10         |
> | backtrace:warn_slowpath_fmt                                | 0          | 10         |
> | backtrace:ipmi_register_smi                                | 0          | 19         |
> | backtrace:try_smi_init                                     | 0          | 19         |
> | backtrace:init_ipmi_si                                     | 0          | 19         |
> | backtrace:kernel_init_freeable                             | 0          | 19         |
> | WARNING:at_kernel/locking/lockdep.c:#lockdep_trace_alloc() | 0          | 9          |
> | backtrace:__get_free_pages                                 | 0          | 9          |
> | backtrace:init_espfix_ap                                   | 0          | 9          |
> | BUG:kernel_boot_hang                                       | 0          | 1          |
> +------------------------------------------------------------+------------+------------+
>
>
> [   33.605171] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
> [   33.605172] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
> [   33.605176] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [   33.775374] BUG: key ffff880fcfc51ed0 not in .data!
> [   33.780822] ------------[ cut here ]------------
> [   33.785982] WARNING: CPU: 18 PID: 1 at kernel/locking/lockdep.c:2991 lockdep_init_map+0x116/0x141()
> [   33.798116] DEBUG_LOCKS_WARN_ON(1)
> [   33.801719] Modules linked in:
> [   33.805346] CPU: 18 PID: 1 Comm: swapper/0 Not tainted 3.18.0-next-20141208 #4
> [   33.813408] Hardware name: Intel Corporation S2600WP/S2600WP, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
> [   33.824862]  0000000000000009 ffff88080f6dbbb8 ffffffff82d71b35 00000000001d03f0
> [   33.833161]  ffff88080f6dbc08 ffff88080f6dbbf8 ffffffff810c8f39 ffff880fcfc51ed0
> [   33.841445]  ffffffff810ff31d ffff880fcfc64f50 ffff880fcfc51ed0 0000000000000000
> [   33.849739] Call Trace:
> [   33.852467]  [<ffffffff82d71b35>] dump_stack+0x4c/0x65
> [   33.858204]  [<ffffffff810c8f39>] warn_slowpath_common+0xa1/0xbb
> [   33.864910]  [<ffffffff810ff31d>] ? lockdep_init_map+0x116/0x141
> [   33.871615]  [<ffffffff810c8f99>] warn_slowpath_fmt+0x46/0x48
> [   33.878030]  [<ffffffff810ff31d>] lockdep_init_map+0x116/0x141
> [   33.884544]  [<ffffffff81242e4a>] __kernfs_create_file+0x8c/0xdb
> [   33.891249]  [<ffffffff81243641>] sysfs_add_file_mode_ns+0xd6/0x17f
> [   33.898245]  [<ffffffff81243716>] sysfs_create_file_ns+0x2c/0x2e
> [   33.904953]  [<ffffffff81b291eb>] device_create_file+0x44/0x89
> [   33.911466]  [<ffffffff8182041d>] ipmi_register_smi+0x705/0x92d
> [   33.918079]  [<ffffffff810f8df0>] ? signal_pending_state+0x31/0x31
> [   33.924981]  [<ffffffff818227b7>] try_smi_init+0x58b/0x723
> [   33.931105]  [<ffffffff81824b86>] init_ipmi_si+0x7d7/0x983
> [   33.937229]  [<ffffffff818243af>] ? cleanup_ipmi_si+0xab/0xab
> [   33.943647]  [<ffffffff8100216c>] do_one_initcall+0xed/0x17b
> [   33.949967]  [<ffffffff843fb11c>] kernel_init_freeable+0x1ec/0x279
> [   33.956869]  [<ffffffff82d60b4a>] ? rest_init+0xca/0xca
> [   33.962703]  [<ffffffff82d60b58>] kernel_init+0xe/0xdf
> [   33.968440]  [<ffffffff82d9607c>] ret_from_fork+0x7c/0xb0
> [   33.974467]  [<ffffffff82d60b4a>] ? rest_init+0xca/0xca
> [   33.980303] ---[ end trace 831fe511de8a7740 ]---
> [   33.985468] BUG: key ffff880fcfc51ea0 not in .data!
>
>
>
> Thanks,
> Huang, Ying
>
>
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>

