Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaAQJeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:34:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAQJeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:34:20 -0500
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] Panic when booting
Date: Fri, 17 Jan 2014 17:34:16 +0800
Message-ID: <87r4877y07.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy all,
I meet following panic when I booting my HP Compad Elite 8300 Elite SFF
desktop.

[call trace here:]
[    0.569993] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    0.578269] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-rc8 #1
[    0.585496] Hardware name: Hewlett-Packard HP Compaq Elite 8300 SFF/3397, BIOS K01 v02.05 05/07/2012
[    0.594639]  ffffffffffffffff ffff880213125d70 ffffffff815dd70e ffffffff817e8598
[    0.602100]  ffff880213125de8 ffffffff815d72bb ffffffff00000010 ffff880213125df8
[    0.609570]  ffff880213125d98 ffff880213125da0 ffff880213125e08 0000000000000012
[    0.617050] Call Trace:
[    0.619511]  [<ffffffff815dd70e>] dump_stack+0x45/0x56
[    0.624664]  [<ffffffff815d72bb>] panic+0xc8/0x1d7
[    0.629470]  [<ffffffff81a36502>] mount_block_root+0x2a1/0x2b0
[    0.635309]  [<ffffffff81a36564>] mount_root+0x53/0x56
[    0.640467]  [<ffffffff81a366a3>] prepare_namespace+0x13c/0x174
[    0.646392]  [<ffffffff81a36184>] kernel_init_freeable+0x218/0x22b
[    0.652578]  [<ffffffff81a358d0>] ? do_early_param+0x88/0x88
[    0.658245]  [<ffffffff815cc450>] ? rest_init+0x80/0x80
[    0.663493]  [<ffffffff815cc45e>] kernel_init+0xe/0x120
[    0.668724]  [<ffffffff815ed43c>] ret_from_fork+0x7c/0xb0
[    0.674125]  [<ffffffff815cc450>] ? rest_init+0x80/0x80
[    0.792437] Rebooting in 3 seconds..[    0.553264] tpm_tis 00:0d: A TPM error (7) occurred attempting to read a pcr value
[    0.561676] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    0.569940] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-rc8 #1
[    0.577162] Hardware name: Hewlett-Packard HP Compaq Elite 8300 SFF/3397, BIOS K01 v02.05 05/07/2012
[    0.586288]  ffffffffffffffff ffff880213125d70 ffffffff815dd70e ffffffff817e8598
[    0.593752]  ffff880213125de8 ffffffff815d72bb ffffffff00000010 ffff880213125df8
[    0.601212]  ffff880213125d98 ffff880213125da0 ffff880213125e08 0000000000000012
[    0.608669] Call Trace:
[    0.611119]  [<ffffffff815dd70e>] dump_stack+0x45/0x56
[    0.616268]  [<ffffffff815d72bb>] panic+0xc8/0x1d7
[    0.621062]  [<ffffffff81a36502>] mount_block_root+0x2a1/0x2b0
[    0.626904]  [<ffffffff81a36564>] mount_root+0x53/0x56
[    0.632046]  [<ffffffff81a366a3>] prepare_namespace+0x13c/0x174
[    0.637963]  [<ffffffff81a36184>] kernel_init_freeable+0x218/0x22b
[    0.644145]  [<ffffffff81a358d0>] ? do_early_param+0x88/0x88
[    0.649808]  [<ffffffff815cc450>] ? rest_init+0x80/0x80
[    0.655028]  [<ffffffff815cc45e>] kernel_init+0xe/0x120
[    0.660253]  [<ffffffff815ed43c>] ret_from_fork+0x7c/0xb0
[    0.665653]  [<ffffffff815cc450>] ? rest_init+0x80/0x80
[    0.783882] Rebooting in 3 seconds..

I can reproduce it 100%.
Will do a bisect next monday if no one has clue.

-- 
Sent with my mu4e

