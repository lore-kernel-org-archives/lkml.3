Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161226Ab3DEMN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:13:58 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33359 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765499Ab3DEMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:13:56 -0400
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Fri, 5 Apr 2013 16:13:40 +0400
X-Google-Sender-Auth: Sit_8T-ZLtKSJe8_2dRzqQs1_K8
Message-ID: <CACaajQsTwWU+YVhp550365Bhyh3C-R=t1DFqmY=1T_2WEqfR+Q@mail.gmail.com>
Subject: hang while add block device to raid1
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. I'm use kernel 3.6.11 from stable tree.
When i do some workload inside my xen vps (dd from /dev/zero), remove
disk via echo 1 > /sys/class/block/xxx/device/delete and reattach it
to raid1 i have hand md device.
On physical device i'm use lvm on top of it raid1.

I'm try to add on top of 3.6.11 patch from linus git tree, but nothing happenes:
commit ee0b0244030434cdda26777bfb98962447e080cd
Author: NeilBrown <neilb@suse.de>
Date:   Mon Feb 25 12:38:29 2013 +1100
    md/raid1,raid10: fix deadlock with freeze_array()

What can i do to fix this?


echo w > /proc/sysrq-trigger

[ 5162.809144] SysRq : Show Blocked State
[ 5162.809158]   task                        PC stack   pid father
[ 5162.809204] md127_raid1     D 0000000000000000     0  7354      2 0x00000000
[ 5162.809209]  ffff88011b489cc0 0000000000000246 ffff8801345e62d0
ffffffff80289dea
[ 5162.809213]  ffff88011b489fd8 ffff88012998e240 ffff88011b489fd8
ffff88012998e240
[ 5162.809216]  ffff8800d572e3c0 ffff88012998e240 ffff88011b489d00
ffff88011b489ce0
[ 5162.809220] Call Trace:
[ 5162.809238]  [<ffffffffa041d55b>] raise_barrier+0xab/0x220 [raid1]
[ 5162.809260]  [<ffffffffa041d9f7>] raid1_add_disk+0x147/0x1c0 [raid1]
[ 5162.809274]  [<ffffffff80408b9b>] remove_and_add_spares+0xfb/0x200
[ 5162.809281]  [<ffffffff8040f37a>] md_check_recovery.part.53+0x41a/0x550
[ 5162.809288]  [<ffffffffa041ee46>] raid1d+0x16/0x170 [raid1]
[ 5162.809298]  [<ffffffff80406de6>] md_thread+0x106/0x140
[ 5162.809305]  [<ffffffff80051cd5>] kthread+0x85/0x90
[ 5162.809315]  [<ffffffff8053da14>] kernel_thread_helper+0x4/0x10


--
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
