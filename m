Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3JTSGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 14:06:04 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:51486 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3JTSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 14:06:02 -0400
Date: Sun, 20 Oct 2013 20:05:55 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <13810431525.20131020200555@eikelenboom.it>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: kernel BUG at mm/slub.c:3338!  RIP  [<ffffffff8117912c>] kfree+0x20c/0x210
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With i 3.12.0-rc6 kernel i encounterd this splat:

[19424.151472] ------------[ cut here ]------------
[19424.151496] kernel BUG at mm/slub.c:3338!
[19424.151506] invalid opcode: 0000 [#1] PREEMPT SMP
[19424.151520] Modules linked in:
[19424.151532] CPU: 1 PID: 2824 Comm: glusterfs Not tainted 3.12.0-rc6-20131020 #1
[19424.151549] task: ffff88001d140000 ti: ffff88001df4c000 task.ti: ffff88001df4c000
[19424.151561] RIP: e030:[<ffffffff8117912c>]  [<ffffffff8117912c>] kfree+0x20c/0x210
[19424.151580] RSP: e02b:ffff88001df4dde8  EFLAGS: 00010246
[19424.151589] RAX: 0040000000000000 RBX: ffff88001df4de68 RCX: 0000000000000000
[19424.151600] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88001df4de68
[19424.151611] RBP: ffff88001df4de28 R08: ffff88001e0f7930 R09: 0000000000000058
[19424.151622] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001cf4de68
[19424.151633] R13: ffffea000077d340 R14: ffff88001e317a00 R15: 0000000000000058
[19424.151649] FS:  00007f549af8c700(0000) GS:ffff88001fd00000(0000) knlGS:0000000000000000
[19424.151661] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[19424.151671] CR2: 00007f549f026000 CR3: 000000001c891000 CR4: 0000000000000660
[19424.151683] Stack:
[19424.151689]  0000000000020050 0000000000000000 0000000000000000 0000000000000000
[19424.151708]  ffff88001cf4de68 0000000000000002 ffff88001e317a00 0000000000000058
[19424.151726]  ffff88001df4df18 ffffffff81186b01 ffff88001df4ded8 ffffffff810f0edf
[19424.151744] Call Trace:
[19424.151756]  [<ffffffff81186b01>] do_readv_writev+0x111/0x250
[19424.151771]  [<ffffffff810f0edf>] ? lock_release_non_nested+0xaf/0x320
[19424.151784]  [<ffffffff810f127f>] ? lock_release+0x12f/0x250
[19424.151796]  [<ffffffff81186ccd>] vfs_readv+0x2d/0x50
[19424.151807]  [<ffffffff81186d44>] SyS_readv+0x54/0xd0
[19424.151820]  [<ffffffff81a560b9>] system_call_fastpath+0x16/0x1b
[19424.151830] Code: 89 4d 8b 6d 30 e9 7e fe ff ff 48 8b 4d c0 48 89 da 4c 89 ee 4c 89 e7 e8 54 e4 8c 00 e9 69 ff ff ff e8 19 a2 8d 00 e9 2f ff ff ff <0f> 0b 66 90 55 48 89 e5 48 83 ec 30 48 89 5d d8 4c 89 75 f0 48
[19424.151954] RIP  [<ffffffff8117912c>] kfree+0x20c/0x210
[19424.151970]  RSP <ffff88001df4dde8>
[19424.151983] ---[ end trace 225a70bf87bd3a82 ]---


--
Sander

