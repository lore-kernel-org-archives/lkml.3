Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3HTF0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:26:09 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47882 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3HTF0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:26:07 -0400
MIME-Version: 1.0
Date: Mon, 19 Aug 2013 22:26:06 -0700
Message-ID: <CAHFgRy9p2vMjTm+1KTZKei5i66dvD6FP1xW2XrRxkrHvCHPAvw@mail.gmail.com>
Subject: 3.11.0-rc6+: INFO: possible circular locking dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   24.990076] [ INFO: possible circular locking dependency detected ]
[   24.990086] 3.11.0-rc6+ #154 Not tainted
[   24.990094] -------------------------------------------------------
[   24.990103] crda/1159 is trying to acquire lock:
[   24.990111]  (genl_mutex){+.+.+.}, at: [<ffffffff812ff7e6>]
genl_lock+0x12/0x14
[   24.990134]
[   24.990134] but task is already holding lock:
[   24.990144]  (nlk->cb_mutex){+.+.+.}, at: [<ffffffff812fdab8>]
netlink_dump+0x1c/0x1da
[   24.990163]
[   24.990163] which lock already depends on the new lock.
[   24.990163]
[   24.990177]
[   24.990177] the existing dependency chain (in reverse order) is:
[   24.990188]
[   24.990188] -> #1 (nlk->cb_mutex){+.+.+.}:
[   24.990202]        [<ffffffff8107d863>] lock_acquire+0x8f/0xa7
[   24.990214]        [<ffffffff813777ab>] mutex_lock_nested+0x72/0x42a
[   24.990228]        [<ffffffff812fdd26>] __netlink_dump_start+0xb0/0x13b
[   24.990240]        [<ffffffff81300b44>] genl_family_rcv_msg+0x106/0x24f
[   24.990253]        [<ffffffff81300cc8>] genl_rcv_msg+0x3b/0x5b
[   24.990264]        [<ffffffff812ff528>] netlink_rcv_skb+0x44/0x86
[   24.990276]        [<ffffffff812ff98b>] genl_rcv+0x23/0x32
[   24.990287]        [<ffffffff812ff033>] netlink_unicast+0xe2/0x166
[   24.990299]        [<ffffffff812ff3bb>] netlink_sendmsg+0x304/0x34e
[   24.990311]        [<ffffffff812cb91a>] __sock_sendmsg_nosec+0x25/0x27
[   24.990324]        [<ffffffff812cdf23>] sock_sendmsg+0x54/0x70
[   24.990336]        [<ffffffff812ce17b>] ___sys_sendmsg+0x1fe/0x28e
[   24.990348]        [<ffffffff812cf410>] __sys_sendmsg+0x3d/0x5b
[   24.990359]        [<ffffffff812cf43b>] SyS_sendmsg+0xd/0x17
[   24.990370]        [<ffffffff8137fc24>] tracesys+0xdd/0xe2
[   24.990382]
[   24.990382] -> #0 (genl_mutex){+.+.+.}:
[   24.990394]        [<ffffffff8107d4ea>] __lock_acquire+0xb5f/0xe49
[   24.990406]        [<ffffffff8107d863>] lock_acquire+0x8f/0xa7
[   24.990417]        [<ffffffff813777ab>] mutex_lock_nested+0x72/0x42a
[   24.990429]        [<ffffffff812ff7e6>] genl_lock+0x12/0x14
[   24.990440]        [<ffffffff81300969>] ctrl_dumpfamily+0x42/0x117
[   24.990452]        [<ffffffff812fdb24>] netlink_dump+0x88/0x1da
[   24.990463]        [<ffffffff812fe03c>] netlink_recvmsg+0x16f/0x2f4
[   24.990475]        [<ffffffff812cb945>] __sock_recvmsg_nosec+0x29/0x2b
[   24.990487]        [<ffffffff812ce26a>] sock_recvmsg+0x5f/0x7d
[   24.990499]        [<ffffffff812ceae1>] ___sys_recvmsg+0x155/0x21f
[   24.990510]        [<ffffffff812cf5f4>] __sys_recvmsg+0x3d/0x5b
[   24.990522]        [<ffffffff812cf61f>] SyS_recvmsg+0xd/0x17
[   24.990532]        [<ffffffff8137fc24>] tracesys+0xdd/0xe2
[   24.990544]
[   24.990544] other info that might help us debug this:
[   24.990544]
[   24.990557]  Possible unsafe locking scenario:
[   24.990557]
[   24.990567]        CPU0                    CPU1
[   24.990575]        ----                    ----
[   24.990582]   lock(nlk->cb_mutex);
[   24.990591]                                lock(genl_mutex);
[   24.990602]                                lock(nlk->cb_mutex);
[   24.990612]   lock(genl_mutex);
[   24.990620]
[   24.990620]  *** DEADLOCK ***
[   24.990620]
[   24.990633] 1 lock held by crda/1159:
[   24.990640]  #0:  (nlk->cb_mutex){+.+.+.}, at: [<ffffffff812fdab8>]
netlink_dump+0x1c/0x1da
[   24.990660]
[   24.990660] stack backtrace:
[   24.990671] CPU: 1 PID: 1159 Comm: crda Not tainted 3.11.0-rc6+ #154
[   24.990681] Hardware name: ASUSTeK Computer Inc.         UL50VT
         /UL50VT    , BIOS 217     03/01/2010
[   24.990695]  0000000000000000 ffff8801338bb920 ffffffff81374ba4
ffffffff81b842b0
[   24.990711]  ffff8801338bb960 ffffffff81370581 ffff8801339b4180
ffff8801339b4180
[   24.990728]  ffff8801339b47a0 ffff8801339b4778 0000000000000001
00000000006520ee
[   24.990744] Call Trace:
[   24.990754]  [<ffffffff81374ba4>] dump_stack+0x4e/0x82
[   24.990766]  [<ffffffff81370581>] print_circular_bug+0x1f6/0x204
[   24.990778]  [<ffffffff8107d4ea>] __lock_acquire+0xb5f/0xe49
[   24.990791]  [<ffffffff8107b7ea>] ? trace_hardirqs_on+0xd/0xf
[   24.990803]  [<ffffffff812ff7e6>] ? genl_lock+0x12/0x14
[   24.990814]  [<ffffffff8107d863>] lock_acquire+0x8f/0xa7
[   24.990825]  [<ffffffff812ff7e6>] ? genl_lock+0x12/0x14
[   24.990837]  [<ffffffff813777ab>] mutex_lock_nested+0x72/0x42a
[   24.990849]  [<ffffffff812ff7e6>] ? genl_lock+0x12/0x14
[   24.990860]  [<ffffffff812ff7e6>] ? genl_lock+0x12/0x14
[   24.990873]  [<ffffffff812d594f>] ? __alloc_skb+0x76/0x19c
[   24.990884]  [<ffffffff812ff7e6>] genl_lock+0x12/0x14
[   24.990896]  [<ffffffff81300969>] ctrl_dumpfamily+0x42/0x117
[   24.990907]  [<ffffffff812d597b>] ? __alloc_skb+0xa2/0x19c
[   24.990919]  [<ffffffff812fdb24>] netlink_dump+0x88/0x1da
[   24.990931]  [<ffffffff812fe03c>] netlink_recvmsg+0x16f/0x2f4
[   24.990943]  [<ffffffff812cb945>] __sock_recvmsg_nosec+0x29/0x2b
[   24.990955]  [<ffffffff812ce26a>] sock_recvmsg+0x5f/0x7d
[   24.990967]  [<ffffffff8107dc4b>] ? lock_release_non_nested+0x123/0x21d
[   24.990979]  [<ffffffff8107dc4b>] ? lock_release_non_nested+0x123/0x21d
[   24.990993]  [<ffffffff812d8c10>] ? verify_iovec+0x58/0xa6
[   24.991005]  [<ffffffff812ceae1>] ___sys_recvmsg+0x155/0x21f
[   24.991018]  [<ffffffff81052850>] ? up_read+0x22/0x25
[   24.991030]  [<ffffffff8137d980>] ? __do_page_fault+0x321/0x3a5
[   24.991043]  [<ffffffff81110b36>] ? fcheck_files+0x9f/0xe0
[   24.991055]  [<ffffffff811110e8>] ? fget_light+0x30/0x90
[   24.991066]  [<ffffffff812cf5f4>] __sys_recvmsg+0x3d/0x5b
[   24.991077]  [<ffffffff812cf61f>] SyS_recvmsg+0xd/0x17
[   24.991089]  [<ffffffff8137fc24>] tracesys+0xdd/0xe2
