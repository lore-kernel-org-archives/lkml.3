Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974AbaCWKn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 06:43:58 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34036 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaCWKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 06:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140323070553.GB14679@localhost>
References: <20140316131757.GA8972@localhost>
	<20140323070553.GB14679@localhost>
Date: Sun, 23 Mar 2014 16:13:54 +0530
Message-ID: <CALJbWepwszbxHBqWS1-T6g1a2o1kEVv94zzYg9ug9akGPx0P=w@mail.gmail.com>
Subject: Re: [logfs] BUG: unable to handle kernel NULL pointer dereference at (null)
From: Prasad Joshi <prasadjoshi.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joern Engel <joern@logfs.org>, Yinghai Lu <yinghai@kernel.org>,
        logfs@logfs.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 12:35 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Joshi,
>
> FYI, this commit seems to trigger the logfs bug earlier.
>
> commit 98e7a989979b185f49e86ddaed2ad6890299d9f0
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Wed Mar 6 20:18:21 2013 -0800
> Commit:     H. Peter Anvin <hpa@zytor.com>
> CommitDate: Wed Mar 6 20:18:32 2013 -0800
>
>     x86, mm: Make sure to find a 2M free block for the first mapped area
>     [snip]
>     Reported-by: Henrik Rydberg <rydberg@euromail.se>
>     Bisected-by: Henrik Rydberg <rydberg@euromail.se>
>     Tested-by: Henrik Rydberg <rydberg@euromail.se>
>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>     Link: http://lkml.kernel.org/r/CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
>
> +-----------------------------------------------------------------------------+------------+------------+---------------+
> |                                                                             | 015221fefb | 98e7a98997 | next-20140321 |
> +-----------------------------------------------------------------------------+------------+------------+---------------+
> | boot_successes                                                              | 35         | 6          | 7             |
> | boot_failures                                                               | 73         | 21         | 12            |
> | BUG:unable_to_handle_kernel_paging_request                                  | 73         |            |               |
> | Oops                                                                        | 73         | 21         | 12            |
> | RIP:perf_swevent_init                                                       | 9          |            |               |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/rwsem.c         | 9          | 21         |               |
> | backtrace:perf_swevent_init                                                 | 9          |            |               |
> | backtrace:perf_init_event                                                   | 9          |            |               |
> | backtrace:async_page_fault                                                  | 9          |            |               |
> | RIP:__alloc_memory_core_early                                               | 64         |            |               |
> | Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task                    | 64         |            |               |
> | backtrace:__alloc_bootmem                                                   | 64         |            |               |
> | backtrace:sparse_init                                                       | 64         |            |               |
> | backtrace:paging_init                                                       | 64         |            |               |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference                        | 0          | 21         | 12            |
> | RIP:__mutex_lock_slowpath                                                   | 0          | 21         | 12            |
> | BUG:scheduling_while_atomic                                                 | 0          | 21         |               |
> | BUG:sleeping_function_called_from_invalid_context_at_mm/memory.c            | 0          | 6          |               |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c | 0          | 0          | 12            |
> | backtrace:do_mount                                                          | 0          | 0          | 12            |
> | backtrace:SyS_mount                                                         | 0          | 0          | 12            |
> +-----------------------------------------------------------------------------+------------+------------+---------------+
>

Thanks a lot for BUG report and your analysis and sorry for delayed response.

> [    0.931658] LogFS: Start unmounting
> [    0.932279] LogFS: Start mount 1

Does this happen first time you try to mount LogFS?
If yes can you please recreate the file system (mklogfs). To recreate
the file system please clone the latest logfsprogs from
https://github.com/prasad-joshi/logfsprogs.git

If this does not help, can you please email me steps for reproducing
the problem on my setup?

Thanks and Regards,
Prasad

> [    0.932857] LogFS: Start unmounting
> [    0.933482] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.934337] IP: [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
> [    0.934337] PGD 11e41067 PUD 1183f067 PMD 0
> [    0.934337] Oops: 0002 [#1]
> [    0.934337] Modules linked in:
> [    0.934337] CPU: 0 PID: 498 Comm: mount Not tainted 3.14.0-rc7-next-20140321 #10
> [    0.934337] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.934337] task: ffff8800007c3a80 ti: ffff880011fc8000 task.ti: ffff880011fc8000
> [    0.934337] RIP: 0010:[<ffffffff8149797f>]  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
> [    0.934337] RSP: 0018:ffff880011fc9d10  EFLAGS: 00010286
> [    0.934337] RAX: 0000000000000000 RBX: ffff880011fbbcc0 RCX: 0000000000000002
> [    0.934337] RDX: 0000000000000000 RSI: 0000000000000067 RDI: ffff880011fbbcc0
> [    0.934337] RBP: ffff880011fc9d50 R08: ffff880011fc8000 R09: 0000000000000100
> [    0.934337] R10: 0000000000000001 R11: ffffffff81072933 R12: ffff880011fbbcc8
> [    0.934337] R13: ffff8800007c3a80 R14: 00000000ffffffff R15: ffff880011fbb000
> [    0.934337] FS:  00007f08f76f8700(0000) GS:ffffffff8181c000(0000) knlGS:0000000000000000
> [    0.934337] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.934337] CR2: 0000000000000000 CR3: 0000000011847000 CR4: 00000000000006b0
> [    0.934337] Stack:
> [    0.934337]  ffff880011fbbcc8 0000000000000000 ffff880011fc9d18 0000000000000850
> [    0.934337]  ffff880011fbbcc0 ffff880011e8e000 ffff880011fbb000 ffff880013365e00
> [    0.934337]  ffff880011fc9d68 ffffffff81497a1d ffff880011e8e000 ffff880011fc9d80
> [    0.934337] Call Trace:
> [    0.934337]  [<ffffffff81497a1d>] mutex_lock+0x27/0x2a
> [    0.934337]  [<ffffffff8118ba48>] logfs_get_wblocks+0x55/0x60
> [    0.934337]  [<ffffffff81189078>] logfs_sync_fs+0x14/0x30
> [    0.934337]  [<ffffffff811012b4>] sync_filesystem+0x49/0x8e
> [    0.934337]  [<ffffffff8118f1ec>] logfs_kill_sb+0x27/0xdc
> [    0.934337]  [<ffffffff810e23cb>] deactivate_locked_super+0x2e/0x4f
> [    0.934337]  [<ffffffff8118ff5d>] logfs_mount+0x6bd/0x6d5
> [    0.934337]  [<ffffffff810e35c7>] mount_fs+0x10/0xa9
> [    0.934337]  [<ffffffff810f7003>] vfs_kern_mount+0x5f/0xe3
> [    0.934337]  [<ffffffff810f938f>] do_mount+0x72f/0x826
> [    0.934337]  [<ffffffff810bb997>] ? strndup_user+0x35/0xcb
> [    0.934337]  [<ffffffff810f96a8>] SyS_mount+0x80/0xb9
> [    0.934337]  [<ffffffff81499137>] system_call_fastpath+0x16/0x1b
> [    0.934337] Code: 25 50 b0 81 81 ff 04 25 50 b0 81 81 8b 07 85 c0 79 23 48 8b 43 10 4c 8d 63 08 48 89 63 10 41 83 ce ff 4c 89 24 24 48 89 44 24 08 <48> 89 20 4c 89 6c 24 10 eb 2e 31 c0 87 07 ff c8 75 d5 eb 48 44
> [    0.934337] RIP  [<ffffffff8149797f>] __mutex_lock_slowpath+0x4b/0xc2
> [    0.934337]  RSP <ffff880011fc9d10>
> [    0.934337] CR2: 0000000000000000
> [    0.934337] ---[ end trace 5506712fb917b42d ]---
> [    0.934337] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
>
> git bisect start v3.9 v3.8 --
> git bisect  bad 20f22ab42e9c832bde6e9a7ed04cdc73ec737e5b  # 09:52      2-      3  signals: fix new kernel-doc warnings
> git bisect good bbbd27e694ce2c5fde9c8fcedbea618dd9153fe7  # 10:07     27+     27  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> git bisect good bc2e4a90d9f75f1664c1587eb09ecd10bb71b022  # 10:19     27+     19  Merge tag 'usb-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
> git bisect  bad d381f45c890a3fb136afb0dc1cbe025e066cb981  # 10:37      3-     19  Merge branch 'for-3.9/upstream-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
> git bisect good e3b59518c10e08eeb06215abf06f50e8f83b51dc  # 10:46     27+     18  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good d345243629db38a6340bcb69f372329d35b8f650  # 11:01     27+     19  Merge tag 'regulator-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
> git bisect good af2841cdd4cb35248e41f7427d996c8f6b563051  # 11:12     27+     17  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
> git bisect  bad 7b54c165a0c012edbaeaa73c5c87cb73721eb580  # 11:31      1-     19  vfs: don't BUG_ON() if following a /proc fd pseudo-symlink results in a symlink
> git bisect  bad 47b3bc907328db968bc9b43c41f48f8d1e140750  # 11:47      0-      6  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 3c4aff6b9a183b4f24eb7b8dd6c8a92cdba3bc75  # 12:05      0-      3  x86, doc: Be explicit about what the x86 struct boot_params requires
> git bisect good 015221fefbc93689dd47508a66326556adf2abcd  # 12:54     27+     15  x86: Fix 32-bit *_cpu_data initializers
> git bisect  bad 2e604c0f19dcdd433b3863ffc3da9bc0787ca765  # 13:21      2-      6  x86: Don't clear efi_info even if the sentinel hits
> git bisect  bad 98e7a989979b185f49e86ddaed2ad6890299d9f0  # 13:29      0-      4  x86, mm: Make sure to find a 2M free block for the first mapped area
> # first bad commit: [98e7a989979b185f49e86ddaed2ad6890299d9f0] x86, mm: Make sure to find a 2M free block for the first mapped area
> git bisect good 015221fefbc93689dd47508a66326556adf2abcd  # 13:38     81+     73  x86: Fix 32-bit *_cpu_data initializers
> git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 13:39      0-     12  Add linux-next specific files for 20140321
> git bisect  bad 774868c7094d35b4518be3d0e654de000a5d11fc  # 13:55      0-      3  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 13:56      0-     12  Add linux-next specific files for 20140321
>
> Thanks,
> Fengguang
