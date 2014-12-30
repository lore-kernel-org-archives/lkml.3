Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaL3KQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:16:24 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53238 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaL3KQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:16:22 -0500
MIME-Version: 1.0
Date: Tue, 30 Dec 2014 13:16:20 +0300
Message-ID: <CACVxJT8sJBR7bZQfLDedvQWTsEo1GaT2UrLCNavz=38Kxe=PTg@mail.gmail.com>
Subject: 3.17.7: list corruption(?) near epoll
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caught while browsing with chromium shortly after boot.
Haven't seen something like that before.

Several chromium tabs locked up, dmesg was full of
similar messages. Box was more or less operational,
then switched to text console with last panic message.

After reboot, that's all what was left:

 [<ffffffff8115155d>] ep_remove+0x1d/0xb0
 [<ffffffff81152740>] SyS_epoll_ctl+0x400/0xae0
 [<ffffffff8109780b>] ? local_clock+0x1b/0x30
 [<ffffffff8104803b>] ? syscall_trace_enter+0x16b/0x180
 [<ffffffff81485009>] tracesys+0xd0/0xd5
---[ end trace 3fc03b0916c7ab8d ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1384 at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
list_del corruption, ffff8800d99a7858->next is LIST_POISON1 (dead000000100100)
Modules linked in: usbhid uhci_hcd
CPU: 0 PID: 1384 Comm: Chrome_IOThread Tainted: G        W      3.17.7 #51
Hardware name: Hewlett-Packard HP Compaq dc7800 Convertible
Minitower/0AACh, BIOS 786F1 v01.28 02/26/2009
 0000000000000009 ffff8800c6387d70 ffffffff8147f3c3 ffff8800c6387db8
 ffff8800c6387da8 ffffffff810761f3 ffff8800d99a7858 ffff8800d99a7840
 0000000000000286 00000000000000fa fffffffffffffffe ffff8800c6387e08
Call Trace:
 [<ffffffff8147f3c3>] dump_stack+0x4d/0x6f
 [<ffffffff810761f3>] warn_slowpath_common+0x73/0x90
 [<ffffffff81076257>] warn_slowpath_fmt+0x47/0x50
 [<ffffffff81076257>] ? warn_slowpath_fmt+0x47/0x50
 [<ffffffff81205983>] __list_del_entry+0x63/0xd0
 [<ffffffff812059fd>] list_del+0xd/0x30
 [<ffffffff810a12e1>] remove_wait_queue+0x21/0x40
 [<ffffffff8115150f>] ep_unregister_pollwait.isra.17+0x3f/0x70
 [<ffffffff8115155d>] ep_remove+0x1d/0xb0
 [<ffffffff81152740>] SyS_epoll_ctl+0x400/0xae0
 [<ffffffff8109780b>] ? local_clock+0x1b/0x30
 [<ffffffff8104803b>] ? syscall_trace_enter+0x16b/0x180
 [<ffffffff81485009>] tracesys+0xd0/0xd5
---[ end trace 3fc03b0916c7ab8e ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1384 at lib/list_debug.c:56 __list_del_entry+0xc3/0xd0()
list_del corruption, ffff8800d99a7828->prev is LIST_POISON2 (dead000000200200)
Modules linked in: usbhid uhci_hcd
CPU: 0 PID: 1384 Comm: Chrome_IOThread Tainted: G        W      3.17.7 #51
Hardware name: Hewlett-Packard HP Compaq dc7800 Convertible
Minitower/0AACh, BIOS 786F1 v01.28 02/26/2009
 0000000000000009 ffff8800c6387d98 ffffffff8147f3c3 ffff8800c6387de0
 ffff8800c6387dd0 ffffffff810761f3 ffff8800d99a7828 ffff8800d8df8a00
 ffff8800d8df8a40 00000000000000fa fffffffffffffffe ffff8800c6387e30
Call Trace:
