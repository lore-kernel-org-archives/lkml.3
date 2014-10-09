Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaJIUFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:05:20 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34187 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaJIUFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:05:17 -0400
MIME-Version: 1.0
Date: Thu, 9 Oct 2014 22:05:15 +0200
Message-ID: <CAFNv3oGYXpozAHnYHhm9GRPByKSAgYGH67whmcRamnnC=b+cvQ@mail.gmail.com>
Subject: RCU stalls -> lockup linux-3.17
From: Luca Tiburzio <luca.tiburzio@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On kernel 3.17
I see a random complete stall during emerge/compile code wich occupies all
8 cpu threads.

This is the log I can see after rebooting a complete locked machine:


Oct  9 20:45:19 localhost kernel: INFO: rcu_preempt detected stalls on
CPUs/tasks: { 7} (detected by 0, t=60002 jiffies, g=221162, c=221161, q=0)
Oct  9 20:45:19 localhost kernel: Task dump for CPU 7:
Oct  9 20:45:19 localhost kernel: cc1plus         R  running task        0
12992  12991 0x00080008
Oct  9 20:45:19 localhost kernel:  ffffffff8109947d ffffffff810984e4
ffff88022fbd1c80 00000000000000a9
Oct  9 20:45:19 localhost kernel:  0000000000000006 00007f927dcef000
ffff880226bee540 ffff8800c386ff58
Oct  9 20:45:19 localhost kernel:  ffff8802225317e0 ffffffff8106aac9
ffff880226bee5a0 0000000000000002
Oct  9 20:45:19 localhost kernel: Call Trace:
Oct  9 20:45:19 localhost kernel:  [<ffffffff8109947d>] ?
pick_next_entity+0x9d/0x180
Oct  9 20:45:19 localhost kernel:  [<ffffffff810984e4>] ?
update_curr+0x74/0xd0
Oct  9 20:45:19 localhost kernel:  [<ffffffff8106aac9>] ?
__do_page_fault+0x199/0x450
Oct  9 20:45:19 localhost kernel:  [<ffffffff8160d4af>] ?
__schedule+0x63f/0x820
Oct  9 20:45:19 localhost kernel:  [<ffffffff810a37a1>] ?
cpuacct_account_field+0x11/0x60
Oct  9 20:45:19 localhost kernel:  [<ffffffff81097923>] ?
vtime_user_enter+0x23/0x40
Oct  9 20:45:19 localhost kernel:  [<ffffffff810a37a1>] ?
cpuacct_account_field+0x11/0x60
Oct  9 20:45:19 localhost kernel:  [<ffffffff810a37a1>] ?
cpuacct_account_field+0x11/0x60
Oct  9 20:45:19 localhost kernel:  [<ffffffff81097923>] ?
vtime_user_enter+0x23/0x40
Oct  9 20:45:19 localhost kernel:  [<ffffffff816125d2>] ?
page_fault+0x22/0x30
