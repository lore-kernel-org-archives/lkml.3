Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaD2QdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:33:20 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:34386 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102AbaD2QdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:33:18 -0400
MIME-Version: 1.0
Date: Tue, 29 Apr 2014 13:33:17 -0300
Message-ID: <CAOMZO5Bb3P20S15Hi8fKO1r8-JOQa3j8GekNBiABVb9XXN0hZw@mail.gmail.com>
Subject: Warning from kernel/printk/printk.c in linux-next
From: Fabio Estevam <festevam@gmail.com>
To: jack@suse.cz
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

I am running linux-next 20140429 on a mx6 board (ARM 32-bit) and after commit
5dc90cb49691755faa ("printk: enable interrupts before calling
console_trylock_for_printk()") I get the following warning:


[ INFO: possible recursive locking detected ]
3.15.0-rc3-next-20140429-00001-gac246a5 #1074 Not tainted
---------------------------------------------
swapper/0/0 is trying to acquire lock:
 (console_lock){+.+...}, at: [<808c1358>] con_init+0x14/0x29c

but task is already holding lock:
 (console_lock){+.+...}, at: [<8006deac>] vprintk_emit+0x194/0x514

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(console_lock);
  lock(console_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by swapper/0/0:
 #0:  (console_lock){+.+...}, at: [<8006deac>] vprintk_emit+0x194/0x514

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc3-next-20140429-00001-gac2464
Backtrace:
[<80011cbc>] (dump_backtrace) from [<80011e58>] (show_stack+0x18/0x1c)
 r6:8114b4fc r5:00000000 r4:00000000 r3:00000000
[<80011e40>] (show_stack) from [<8065e65c>] (dump_stack+0x88/0xa4)
[<8065e5d4>] (dump_stack) from [<80065518>] (__lock_acquire+0x1494/0x1c10)
 r5:808f3f70 r4:80a7d6c0
[<80064084>] (__lock_acquire) from [<80066178>] (lock_acquire+0x68/0x7c)
 r10:00000000 r9:412fc09a r8:8000406a r7:00000001 r6:60000153 r5:808e8000
 r4:00000000
[<80066110>] (lock_acquire) from [<8006c91c>] (console_lock+0x54/0x68)
 r7:befffbc0 r6:808d6db0 r5:808c1358 r4:00000001
[<8006c8c8>] (console_lock) from [<808c1358>] (con_init+0x14/0x29c)
 r5:808e37a4 r4:808e37a4
[<808c1344>] (con_init) from [<808c0ae4>] (console_init+0x24/0x38)
 r6:808d6db0 r5:808e37a4 r4:808e37a4
[<808c0ac0>] (console_init) from [<80894bb4>] (start_kernel+0x26c/0x3a4)
 r5:8094d5c0 r4:ffffffff
[<80894948>] (start_kernel) from [<80008074>] (0x80008074)
 r7:808f5644 r6:808d6dac r5:808f0928 r4:10c5387d

Reverting this commit causes the warning to go away.

Any suggestions?

Regards,

Fabio Estevam
