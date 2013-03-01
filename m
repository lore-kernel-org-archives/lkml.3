Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3CAVrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:47:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33577 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3CAVrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:47:13 -0500
Date: Fri, 01 Mar 2013 16:47:11 -0500 (EST)
Message-Id: <20130301.164711.326215889038834651.davem@davemloft.net>
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 01 Mar 2013 13:47:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm getting these non-stop right when the hypervisor console registers
on sparc64, and the machine won't boot up properly.  This is with
Linus's current tree.

[511865.556835] console [ttyHV0] enabled
[511865.564555] ------------[ cut here ]------------
[511865.612410] WARNING: at drivers/tty/tty_buffer.c:428 process_one_work+0x164/0x420()
[511865.627846] tty is NULL
[511865.687052] Modules linked in:
[511865.693305] Call Trace:
[511865.698343]  [0000000000464f2c] warn_slowpath_fmt+0x2c/0x40
[511865.709637]  [0000000000480f24] process_one_work+0x164/0x420
[511865.721097]  [0000000000481580] worker_thread+0x120/0x440
[511865.732036]  [00000000004867a8] kthread+0x88/0xa0
[511865.741585]  [0000000000406044] ret_from_syscall+0x1c/0x2c
[511865.752695]  [0000000000000000]           (null)
[511865.762080] ---[ end trace 40d7a6b076cabd64 ]---
[511865.771806] ------------[ cut here ]------------
[511865.780935] WARNING: at drivers/tty/tty_buffer.c:428 process_one_work+0x164/0x420()
[511865.796379] tty is NULL
[511865.801409] Modules linked in:
[511865.807649] Call Trace:
[511865.812689]  [0000000000464f2c] warn_slowpath_fmt+0x2c/0x40
[511865.823981]  [0000000000480f24] process_one_work+0x164/0x420
[511865.835447]  [0000000000481580] worker_thread+0x120/0x440
[511865.846385]  [00000000004867a8] kthread+0x88/0xa0
[511865.855930]  [0000000000406044] ret_from_syscall+0x1c/0x2c
[511865.867042]  [0000000000000000]           (null)
[511865.876414] ---[ end trace 40d7a6b076cabd65 ]---
[511865.886157] ------------[ cut here ]------------
[511865.895284] WARNING: at drivers/tty/tty_buffer.c:428 process_one_work+0x164/0x420()
[511865.910730] tty is NULL
[511865.915757] Modules linked in:
[511865.922000] Call Trace:
[511865.927035]  [0000000000464f2c] warn_slowpath_fmt+0x2c/0x40
[511865.938330]  [0000000000480f24] process_one_work+0x164/0x420
[511865.949796]  [0000000000481580] worker_thread+0x120/0x440
[511865.960733]  [00000000004867a8] kthread+0x88/0xa0
[511865.970288]  [0000000000406044] ret_from_syscall+0x1c/0x2c
[511865.981402]  [0000000000000000]           (null)
[511865.990773] ---[ end trace 40d7a6b076cabd66 ]---
[511866.000507] ------------[ cut here ]------------
[511866.009618] WARNING: at drivers/tty/tty_buffer.c:428 process_one_work+0x164/0x420()
[511866.025074] tty is NULL
[511866.030102] Modules linked in:
[511866.036361] Call Trace:
[511866.041400]  [0000000000464f2c] warn_slowpath_fmt+0x2c/0x40
[511866.052675]  [0000000000480f24] process_one_work+0x164/0x420
[511866.064147]  [0000000000481580] worker_thread+0x120/0x440
[511866.075077]  [00000000004867a8] kthread+0x88/0xa0
[511866.084639]  [0000000000406044] ret_from_syscall+0x1c/0x2c
[511866.095739]  [0000000000000000]           (null)
[511866.105123] ---[ end trace 40d7a6b076cabd67 ]---
