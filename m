Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3IBGau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:30:50 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:45983 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab3IBGas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:30:48 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689ET-2q_7WY+4HZjMqQEmLpOQyWOrOzRnP3ADc8TAzoEXw@mail.gmail.com>
References: <1377269106-26468-1-git-send-email-zwu.kernel@gmail.com>
	<CANN689ET-2q_7WY+4HZjMqQEmLpOQyWOrOzRnP3ADc8TAzoEXw@mail.gmail.com>
Date: Mon, 2 Sep 2013 14:30:47 +0800
Message-ID: <CAEH94Li5KuN4V7KVAYJ9YY72HWVS2_gf-_L4zscV1K5fMw58XQ@mail.gmail.com>
Subject: Re: [PATCH] rbtree: Add some necessary condition checks
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Tue, Aug 27, 2013 at 6:01 AM, Michel Lespinasse <walken@google.com> wrote:
> On Fri, Aug 23, 2013 at 7:45 AM,  <zwu.kernel@gmail.com> wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  include/linux/rbtree_augmented.h | 3 ++-
>>  lib/rbtree.c                     | 5 +++--
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> So, you are saying that the checks are necessary, but you are not saying why.
>
> The way I see it, the checks are *not* necessary, because the rbtree
> invariants guarantee them to be true. The only way for the checks to
> fail would be if people directly manipulate the rbtrees without going
> through the proper APIs, and if they do that then I think they're on
> their own. So to me, I think it's the same situation as dereferencing
> a pointer without checking if it's NULL, because you know it should
> never be NULL - which in my eyes is perfectly acceptable.
In my patchset, some rbtree APIs to be invoked, and I think that those
rbtree APIs are used corrently, Below is the pointer of its code:
https://github.com/wuzhy/kernel/compare/torvalds:master...hot_tracking
But I hit some issues when using compilebench to do perf benchmark.
compile dir kernel-7 691MB in 8.92 seconds (77.53 MB/s)
[  411.597890] general protection fault: 0000 [#1] SMP
[  411.598011] Modules linked in:
[  411.598011] CPU: 0 PID: 24 Comm: kswapd0 Not tainted 3.11.0-rc7+ #1235
[  411.598011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  411.598011] task: ffff88029366df70 ti: ffff88029211e000 task.ti:
ffff88029211e000
[  411.598011] RIP: 0010:[<ffffffff8149952d>]  [<ffffffff8149952d>]
rb_erase+0x1bd/0x390
[  411.598011] RSP: 0018:ffff88029211fb38  EFLAGS: 00010206
[  411.598011] RAX: ffff8801484805f8 RBX: ffff8801484804e0 RCX: 00ffff880155f00a
[  411.598011] RDX: ffff880155f00ae1 RSI: ffff880288630000 RDI: ffff880155f00ad8
[  411.598011] RBP: ffff88029211fb38 R08: ffff880155f00ae1 R09: 0000000000000000
[  411.598011] R10: ffff8801484805f8 R11: 0000000000000000 R12: ffff880288630000
[  411.598011] R13: ffff880148480520 R14: 0000000000003af0 R15: ffff8801484805b0
[  411.598011] FS:  0000000000000000(0000) GS:ffff88029fc00000(0000)
knlGS:0000000000000000
[  411.598011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  411.598011] CR2: 00000000f7798000 CR3: 000000028a69d000 CR4: 00000000000006f0
[  411.598011] Stack:
[  411.598011]  ffff88029211fb68 ffffffff811dd6f9 ffff8801484804e0
ffff880288630000
[  411.598011]  ffffffff811dd1d0 0000000000003af0 ffff88029211fb78
ffffffff811dd79c
[  411.598011]  ffff88029211fbe8 ffffffff811dd8f9 ffff88029211fba8
ffff880288632008
[  411.598011] Call Trace:
[  411.598011]  [<ffffffff811dd6f9>] hot_inode_item_free+0x29/0xa0
[  411.598011]  [<ffffffff811dd1d0>] ? hot_mem_limit_sum+0x10/0x10
[  411.598011]  [<ffffffff811dd79c>] hot_inode_item_put+0x2c/0x30
[  411.598011]  [<ffffffff811dd8f9>] hot_item_evict.part.5+0xa9/0x120
[  411.598011]  [<ffffffff811dd9aa>] hot_track_prune+0x3a/0x70
[  411.598011]  [<ffffffff81159f33>] shrink_slab+0x153/0x2f0
[  411.598011]  [<ffffffff81080cd3>] ? up_read+0x23/0x40
[  411.598011]  [<ffffffff8115d4d1>] balance_pgdat+0x491/0x5d0
[  411.598011]  [<ffffffff8115d7a0>] kswapd+0x190/0x470
[  411.598011]  [<ffffffff8107ca10>] ? wake_up_bit+0x40/0x40
[  411.598011]  [<ffffffff8115d610>] ? balance_pgdat+0x5d0/0x5d0
[  411.598011]  [<ffffffff8107c4fa>] kthread+0xea/0xf0
[  411.598011]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[  411.598011]  [<ffffffff818b9a1c>] ret_from_fork+0x7c/0xb0
[  411.598011]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[  411.598011] Code: 49 89 d0 49 83 c8 01 4c 89 07 48 89 d7 48 89 ca
48 8b 4a 08 49 89 d0 49 83 c8 01 48 85 c9 48 89 48 10 48 89 42 08 4c
89 07 74 0c <48> 8b 39 83 e7 01 48 09 c7 48 89 39 48 8b 08 48 89 0a 48
83 e1
[  411.598011] RIP  [<ffffffff8149952d>] rb_erase+0x1bd/0x390
[  411.598011]  RSP <ffff88029211fb38>
[  411.669881] ---[ end trace 89d346eca258dcf8 ]---

(gdb) l *rb_erase+0x1bd
0xffffffff8149952d is in rb_erase (include/linux/rbtree_augmented.h:101).
96    #define rb_is_red(rb)      __rb_is_red((rb)->__rb_parent_color)
97    #define rb_is_black(rb)    __rb_is_black((rb)->__rb_parent_color)
98
99    static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
100    {
101        rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
102    }
103
104    static inline void rb_set_parent_color(struct rb_node *rb,
105                           struct rb_node *p, int color)
(gdb)

compile dir kernel-27 691MB in 14.26 seconds (48.50 MB/s)
create dir kernel-64334 222MB in 12.78 seconds (17.40 MB/s)
[ 1630.646485] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 1630.647010] IP: [<ffffffff814993d2>] rb_erase+0x62/0x390
[ 1630.647010] PGD 289f78067 PUD 291de4067 PMD 0
[ 1630.647010] Oops: 0000 [#1] SMP
[ 1630.647010] Modules linked in:
[ 1630.647010] CPU: 0 PID: 24 Comm: kswapd0 Not tainted 3.11.0-rc7+ #1235
[ 1630.647010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1630.647010] task: ffff88029366df70 ti: ffff88029211e000 task.ti:
ffff88029211e000
[ 1630.647010] RIP: 0010:[<ffffffff814993d2>]  [<ffffffff814993d2>]
rb_erase+0x62/0x390
[ 1630.647010] RSP: 0018:ffff88029211fb38  EFLAGS: 00010282
[ 1630.647010] RAX: ffff8800a57b3a08 RBX: ffff8800a57b39c0 RCX: 0000000000000000
[ 1630.647010] RDX: ffff8800a57b3ad8 RSI: ffff88013011c000 RDI: ffff8800a57b3a08
[ 1630.647010] RBP: ffff88029211fb38 R08: ffff8801cd31b118 R09: 0000000000000000
[ 1630.647010] R10: ffff8800a57b3ad8 R11: 0000000000000000 R12: ffff88013011c000
[ 1630.647010] R13: ffff8800a57b3a00 R14: 0000000000003f58 R15: ffff8800a57b3a90
[ 1630.647010] FS:  0000000000000000(0000) GS:ffff88029fc00000(0000)
knlGS:0000000000000000
[ 1630.647010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1630.647010] CR2: 0000000000000000 CR3: 0000000256e71000 CR4: 00000000000006f0
[ 1630.647010] Stack:
[ 1630.647010]  ffff88029211fb68 ffffffff811dd6f9 ffff8800a57b39c0
ffff88013011c000
[ 1630.647010]  ffffffff811dd1d0 0000000000003f58 ffff88029211fb78
ffffffff811dd79c
[ 1630.647010]  ffff88029211fbe8 ffffffff811dd8f9 ffff88029211fba8
ffff88013011e008
[ 1630.647010] Call Trace:
[ 1630.647010]  [<ffffffff811dd6f9>] hot_inode_item_free+0x29/0xa0
[ 1630.647010]  [<ffffffff811dd1d0>] ? hot_mem_limit_sum+0x10/0x10
[ 1630.647010]  [<ffffffff811dd79c>] hot_inode_item_put+0x2c/0x30
[ 1630.647010]  [<ffffffff811dd8f9>] hot_item_evict.part.5+0xa9/0x120
[ 1630.647010]  [<ffffffff811dd9aa>] hot_track_prune+0x3a/0x70
[ 1630.647010]  [<ffffffff81159f33>] shrink_slab+0x153/0x2f0
[ 1630.647010]  [<ffffffff81080cd3>] ? up_read+0x23/0x40
[ 1630.647010]  [<ffffffff8115d4d1>] balance_pgdat+0x491/0x5d0
[ 1630.647010]  [<ffffffff8115d7a0>] kswapd+0x190/0x470
[ 1630.647010]  [<ffffffff8107ca10>] ? wake_up_bit+0x40/0x40
[ 1630.647010]  [<ffffffff8115d610>] ? balance_pgdat+0x5d0/0x5d0
[ 1630.647010]  [<ffffffff8107c4fa>] kthread+0xea/0xf0
[ 1630.647010]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[ 1630.647010]  [<ffffffff818b9a1c>] ret_from_fork+0x7c/0xb0
[ 1630.647010]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[ 1630.647010] Code: 8b 4a 10 48 85 c9 75 f1 4c 8b 4a 08 49 89 d2 4c
89 48 10 4c 89 42 08 49 8b 08 83 e1 01 48 09 d1 49 89 08 48 8b 4f 10
48 89 4a 10 <4c> 8b 01 41 83 e0 01 4d 09 d0 4c 89 01 48 8b 0f 49 89 c8
49 83
[ 1630.647010] RIP  [<ffffffff814993d2>] rb_erase+0x62/0x390
[ 1630.647010]  RSP <ffff88029211fb38>
[ 1630.647010] CR2: 0000000000000000
[ 1630.724782] ---[ end trace aec3e0601deedd6a ]---

60            inc.head = ACCESS_ONCE(lock->tickets.head);
(gdb) l *rb_erase+0x62
0xffffffff814993d2 is in rb_erase (include/linux/rbtree_augmented.h:101).
96    #define rb_is_red(rb)      __rb_is_red((rb)->__rb_parent_color)
97    #define rb_is_black(rb)    __rb_is_black((rb)->__rb_parent_color)
98
99    static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
100    {
101        rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
102    }
103
104    static inline void rb_set_parent_color(struct rb_node *rb,
105                           struct rb_node *p, int color)
(gdb)


clean kernel-7 691MB in 0.42 seconds (1646.66 MB/s)
delete kernel-27 in 3.63 seconds
[  623.474634] BUG: unable to handle kernel paging request at fffffffffffffffc
[  623.475009] IP: [<ffffffff81499a10>] rb_insert_color+0xa0/0x170
[  623.475009] PGD 1e0c067 PUD 1e0e067 PMD 0
[  623.475009] Oops: 0000 [#1] SMP
[  623.475009] Modules linked in:
[  623.475009] CPU: 0 PID: 1696 Comm: btrfs-transacti Not tainted
3.11.0-rc7+ #1235
[  623.475009] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  623.475009] task: ffff88028c691fd0 ti: ffff880291ef2000 task.ti:
ffff880291ef2000
[  623.475009] RIP: 0010:[<ffffffff81499a10>]  [<ffffffff81499a10>]
rb_insert_color+0xa0/0x170
[  623.475009] RSP: 0018:ffff880291ef3958  EFLAGS: 00010286
[  623.475009] RAX: fffffffffffffffc RBX: ffff880289ed0000 RCX: ffffffff820ea8c0
[  623.475009] RDX: ffff8801f83bd1e8 RSI: ffff880289ed0000 RDI: ffff8801f83bd1e9
[  623.475009] RBP: ffff880291ef3958 R08: ffff8801f83bd1e8 R09: 0000000000000001
[  623.475009] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880289ed2008
[  623.475009] R13: ffff8802365b4ea0 R14: 0000000000000101 R15: ffff8802365b4e18
[  623.475009] FS:  0000000000000000(0000) GS:ffff88029fc00000(0000)
knlGS:0000000000000000
[  623.475009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  623.475009] CR2: fffffffffffffffc CR3: 0000000289ee2000 CR4: 00000000000006f0
[  623.475009] Stack:
[  623.475009]  ffff880291ef39a8 ffffffff811ddfc6 ffff880291ef3988
00000001813a5e52
[  623.475009]  ffff880291ef39c0 0000000000040000 0000000000040000
0000000000040000
[  623.475009]  7fffffffffffffff 0000000000000000 ffff880291ef3a08
ffffffff811de338
[  623.475009] Call Trace:
[  623.475009]  [<ffffffff811ddfc6>] hot_inode_item_lookup+0x166/0x1b0
[  623.475009]  [<ffffffff811de338>] hot_freqs_update+0x78/0x160
[  623.475009]  [<ffffffff81390c30>] ?
insert_reserved_file_extent.constprop.62+0x2c0/0x2c0
[  623.475009]  [<ffffffff811542fa>] do_writepages+0x6a/0xa0
[  623.475009]  [<ffffffff81148f19>] __filemap_fdatawrite_range+0x59/0x60
[  623.475009]  [<ffffffff81149d83>] filemap_fdatawrite_range+0x13/0x20
[  623.475009]  [<ffffffff813a571d>] btrfs_wait_ordered_range+0x4d/0x120
[  623.475009]  [<ffffffff813cca94>] __btrfs_write_out_cache+0x764/0x970
[  623.475009]  [<ffffffff813ccfe8>] btrfs_write_out_cache+0x98/0xf0
[  623.475009]  [<ffffffff8137bf50>] btrfs_write_dirty_block_groups+0x580/0x660
[  623.475009]  [<ffffffff813ac4e9>] ? free_extent_buffer+0x49/0xc0
[  623.475009]  [<ffffffff818a5f50>] commit_cowonly_roots+0x154/0x226
[  623.475009]  [<ffffffff8138c5b5>] btrfs_commit_transaction+0x445/0x950
[  623.475009]  [<ffffffff81383efd>] transaction_kthread+0x1bd/0x240
[  623.475009]  [<ffffffff81383d40>] ? cleaner_kthread+0x1a0/0x1a0
[  623.475009]  [<ffffffff8107c4fa>] kthread+0xea/0xf0
[  623.475009]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[  623.475009]  [<ffffffff818b9a1c>] ret_from_fork+0x7c/0xb0
[  623.475009]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[  623.475009] Code: 00 48 89 41 08 5d c3 0f 1f 40 00 48 89 d7 48 83
cf 01 48 89 39 48 89 38 48 8b 02 48 83 e0 fc 48 85 c0 48 89 02 0f 84
8e 00 00 00 <48> 8b 10 4c 89 c7 f6 c2 01 75 cf 48 8b 4a 08 49 89 d0 48
39 c8
[  623.475009] RIP  [<ffffffff81499a10>] rb_insert_color+0xa0/0x170
[  623.475009]  RSP <ffff880291ef3958>
[  623.475009] CR2: fffffffffffffffc
[  623.475009] ---[ end trace 0e8e9ac8daa97bd0 ]---

(gdb) l *rb_insert_color+0xa0
0xffffffff81499a10 is in rb_insert_color (lib/rbtree.c:89).
84             * want a red root or two consecutive red nodes.
85             */
86            if (!parent) {
87                rb_set_parent_color(node, NULL, RB_BLACK);
88                break;
89            } else if (rb_is_black(parent))
90                break;
91
92            gparent = rb_red_parent(parent);
93
(gdb)

create dir kernel-23 222MB in 6.01 seconds (37.00 MB/s)
[ 6622.862142] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 6622.863012] IP: [<ffffffff81499488>] rb_erase+0x118/0x390
[ 6622.863012] PGD 231f4f067 PUD 238297067 PMD 0
[ 6622.863012] Oops: 0002 [#1] SMP
[ 6622.863012] Modules linked in:
[ 6622.863012] CPU: 0 PID: 24 Comm: kswapd0 Not tainted 3.11.0-rc7+ #1235
[ 6622.863012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 6622.863012] task: ffff88029366df70 ti: ffff88029211e000 task.ti:
ffff88029211e000
[ 6622.863012] RIP: 0010:[<ffffffff81499488>]  [<ffffffff81499488>]
rb_erase+0x118/0x390
[ 6622.863012] RSP: 0018:ffff88029211fb38  EFLAGS: 00010282
[ 6622.863012] RAX: ffff88019c1f1ee8 RBX: ffff88019c1f1d00 RCX: 0000000000000000
[ 6622.863012] RDX: ffff88017f964a08 RSI: ffff880233798000 RDI: ffff88019c1f1ee9
[ 6622.863012] RBP: ffff88029211fb38 R08: ffff88019c1f1ee8 R09: 0000000000000000
[ 6622.863012] R10: ffff88019c1f1e18 R11: 0000000000000000 R12: ffff880233798000
[ 6622.863012] R13: ffff88019c1f1d40 R14: 0000000000003d0c R15: ffff88019c1f1dd0
[ 6622.863012] FS:  0000000000000000(0000) GS:ffff88029fc00000(0000)
knlGS:0000000000000000
[ 6622.863012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6622.863012] CR2: 0000000000000000 CR3: 00000002336fc000 CR4: 00000000000006f0
[ 6622.863012] Stack:
[ 6622.863012]  ffff88029211fb68 ffffffff811dd6f9 ffff88019c1f1d00
ffff880233798000
[ 6622.863012]  ffffffff811dd1d0 0000000000003d0c ffff88029211fb78
ffffffff811dd79c
[ 6622.863012]  ffff88029211fbe8 ffffffff811dd8f9 ffff88029211fba8
ffff88023379a008
[ 6622.863012] Call Trace:
[ 6622.863012]  [<ffffffff811dd6f9>] hot_inode_item_free+0x29/0xa0
[ 6622.863012]  [<ffffffff811dd1d0>] ? hot_mem_limit_sum+0x10/0x10
[ 6622.863012]  [<ffffffff811dd79c>] hot_inode_item_put+0x2c/0x30
[ 6622.863012]  [<ffffffff811dd8f9>] hot_item_evict.part.5+0xa9/0x120
[ 6622.863012]  [<ffffffff811dd9aa>] hot_track_prune+0x3a/0x70
[ 6622.863012]  [<ffffffff81159f33>] shrink_slab+0x153/0x2f0
[ 6622.863012]  [<ffffffff81080cd3>] ? up_read+0x23/0x40
[ 6622.863012]  [<ffffffff8115d4d1>] balance_pgdat+0x491/0x5d0
[ 6622.863012]  [<ffffffff8115d7a0>] kswapd+0x190/0x470
[ 6622.863012]  [<ffffffff8107ca10>] ? wake_up_bit+0x40/0x40
[ 6622.863012]  [<ffffffff8115d610>] ? balance_pgdat+0x5d0/0x5d0
[ 6622.863012]  [<ffffffff8107c4fa>] kthread+0xea/0xf0
[ 6622.863012]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[ 6622.863012]  [<ffffffff818b9a1c>] ret_from_fork+0x7c/0xb0
[ 6622.863012]  [<ffffffff8107c410>] ? flush_kthread_work+0x1b0/0x1b0
[ 6622.863012] Code: e2 fc 74 ab 48 89 c1 48 89 d0 48 8b 50 08 48 39
ca 74 48 f6 02 01 75 b3 48 8b 4a 10 48 89 c7 48 83 cf 01 48 89 48 08
48 89 42 10 <48> 89 39 48 8b 38 48 89 3a 48 83 e7 fc 48 89 10 0f 84 02
01 00
[ 6622.863012] RIP  [<ffffffff81499488>] rb_erase+0x118/0x390
[ 6622.863012]  RSP <ffff88029211fb38>
[ 6622.863012] CR2: 0000000000000000
[ 6622.938771] ---[ end trace 75fedfe9cb5f4943 ]---

(gdb) l *rb_erase+0x118
0xffffffff81499488 is in rb_erase (include/linux/rbtree_augmented.h:107).
102    }
103
104    static inline void rb_set_parent_color(struct rb_node *rb,
105                           struct rb_node *p, int color)
106    {
107        rb->__rb_parent_color = (unsigned long)p | color;
108    }
109
110    static inline void
111    __rb_change_child(struct rb_node *old, struct rb_node *new,
(gdb)


>
> If you really feel this is a problem, you should explain why. I would
> also prefer if any checks you add could be limited to debug builds.
>
> --
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.



-- 
Regards,

Zhi Yong Wu
