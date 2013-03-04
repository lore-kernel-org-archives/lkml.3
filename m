Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3CDLLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:11:44 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:35299 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3CDLLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:11:42 -0500
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 13:11:41 +0200
Message-ID: <CA+ydwtpcOqA+qp6OCS9c_vpKwXDAuf75st+o1v+CKLF30zF+kQ@mail.gmail.com>
Subject: hpet ioctl() divide error: 0000
From: Tommi Rantala <tt.rantala@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm seeing this bug while fuzzing 3.9.0-rc1 with trinity (in a qemu
virtual machine as the root user).

[   95.509983] divide error: 0000 [#1] SMP
[   95.510072] CPU 0
[   95.510072] Pid: 2421, comm: trinity-child8 Not tainted 3.9.0-rc1+
#95 Bochs Bochs
[   95.510072] RIP: 0010:[<ffffffff81440865>]  [<ffffffff81440865>]
hpet_ioctl_common+0x465/0x500
[   95.510072] RSP: 0018:ffff8800780afde8  EFLAGS: 00010206
[   95.510072] RAX: 0000000105f5e100 RBX: ffff88007c792c00 RCX: 0000000000000000
[   95.510072] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000246
[   95.510072] RBP: ffff8800780afe38 R08: 0000000000000000 R09: 0000000000000000
[   95.510072] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000200000000
[   95.510072] R13: 0000000040086806 R14: ffff88007c792d78 R15: 0000000000000007
[   95.510072] FS:  00007f2867124700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[   95.510072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.510072] CR2: 00000000062608c8 CR3: 0000000078238000 CR4: 00000000000006f0
[   95.510072] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   95.510072] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   95.510072] Process trinity-child8 (pid: 2421, threadinfo
ffff8800780ae000, task ffff88007afd8000)
[   95.510072] Stack:
[   95.510072]  2222222222222222 0000000200000000 2222222222222222
2222222222222222
[   95.510072]  ffffffff813056a8 ffff8800775aca80 0000000200000000
0000000040086806
[   95.510072]  0000000200000000 0000000000000007 ffff8800780afe88
ffffffff81440a31
[   95.510072] Call Trace:
[   95.510072]  [<ffffffff813056a8>] ? avc_has_perm_flags+0x28/0x370
[   95.510072]  [<ffffffff81440a31>] hpet_ioctl+0x41/0xa0
[   95.510072]  [<ffffffff811b9502>] do_vfs_ioctl+0x522/0x570
[   95.510072]  [<ffffffff81306ab3>] ? file_has_perm+0x83/0xa0
[   95.510072]  [<ffffffff811b95ad>] sys_ioctl+0x5d/0xa0
[   95.510072]  [<ffffffff81362a2e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   95.510072]  [<ffffffff81ced2a9>] system_call_fastpath+0x16/0x1b
[   95.510072] Code: 00 48 89 55 b8 e8 9c 48 c6 ff 89 c1 48 8b 55 b8
b8 f3 ff ff ff 84 c9 0f 84 89 00 00 00 48 89 d0 89 d1 31 d2 48 d1 e8
48 03 43 20 <48> f7 f1 49 89 46 18 31 c0 eb 70 48 85 d2 75 e2 0f 1f 00
b8 ea
[   95.510072] RIP  [<ffffffff81440865>] hpet_ioctl_common+0x465/0x500
[   95.510072]  RSP <ffff8800780afde8>
[   95.660390] ---[ end trace 0802d990ba159991 ]---

Tommi
