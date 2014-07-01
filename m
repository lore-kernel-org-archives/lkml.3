Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbaGADCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 23:02:10 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59969 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaGADCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 23:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406271249510.5170@nanos>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
 <alpine.DEB.2.10.1406270027300.5170@nanos> <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
 <alpine.DEB.2.10.1406271249510.5170@nanos>
From: Austin Schuh <austin@peloton-tech.com>
Date: Mon, 30 Jun 2014 20:01:46 -0700
Message-ID: <CANGgnMZ8qemTgzoiq96=YvTnz-h945b8zSw1VtmDMSrbY3kcUg@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 7:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Completely untested patch below.

By chance, I found this in my boot logs.  I'll do some more startup
testing tomorrow.

Jun 30 19:54:40 vpc5 kernel: [    0.670955] ------------[ cut here ]------------
Jun 30 19:54:40 vpc5 kernel: [    0.670962] WARNING: CPU: 0 PID: 4 at
kernel/workqueue.c:1604 worker_enter_idle+0x65/0x16b()
Jun 30 19:54:40 vpc5 kernel: [    0.670970] Modules linked in:
Jun 30 19:54:40 vpc5 kernel: [    0.670973] CPU: 0 PID: 4 Comm:
kworker/0:0 Not tainted 3.14.3-rt4abs+ #8
Jun 30 19:54:40 vpc5 kernel: [    0.670974] Hardware name: CompuLab
Intense-PC/Intense-PC, BIOS CR_2.2.0.377 X64 04/10/2013
Jun 30 19:54:40 vpc5 kernel: [    0.670983]  0000000000000009
ffff88040ce75de8 ffffffff81510faf 0000000000000002
Jun 30 19:54:40 vpc5 kernel: [    0.670985]  0000000000000000
ffff88040ce75e28 ffffffff81042085 0000000000000001
Jun 30 19:54:40 vpc5 kernel: [    0.670987]  ffffffff81057a60
ffff88042d406900 ffff88042da63fc0 ffff88042da64030
Jun 30 19:54:40 vpc5 kernel: [    0.670988] Call Trace:
Jun 30 19:54:40 vpc5 kernel: [    0.670995]  [<ffffffff81510faf>]
dump_stack+0x4f/0x7c
Jun 30 19:54:40 vpc5 kernel: [    0.670999]  [<ffffffff81042085>]
warn_slowpath_common+0x81/0x9c
Jun 30 19:54:40 vpc5 kernel: [    0.671002]  [<ffffffff81057a60>] ?
worker_enter_idle+0x65/0x16b
Jun 30 19:54:40 vpc5 kernel: [    0.671005]  [<ffffffff810420ba>]
warn_slowpath_null+0x1a/0x1c
Jun 30 19:54:40 vpc5 kernel: [    0.671007]  [<ffffffff81057a60>]
worker_enter_idle+0x65/0x16b
Jun 30 19:54:40 vpc5 kernel: [    0.671010]  [<ffffffff8105a0a9>]
worker_thread+0x1b3/0x22b
Jun 30 19:54:40 vpc5 kernel: [    0.671013]  [<ffffffff81059ef6>] ?
rescuer_thread+0x293/0x293
Jun 30 19:54:40 vpc5 kernel: [    0.671015]  [<ffffffff81059ef6>] ?
rescuer_thread+0x293/0x293
Jun 30 19:54:40 vpc5 kernel: [    0.671018]  [<ffffffff8105f7ab>]
kthread+0xdc/0xe4
Jun 30 19:54:40 vpc5 kernel: [    0.671022]  [<ffffffff8105f6cf>] ?
flush_kthread_worker+0xe1/0xe1
Jun 30 19:54:40 vpc5 kernel: [    0.671025]  [<ffffffff8151586c>]
ret_from_fork+0x7c/0xb0
Jun 30 19:54:40 vpc5 kernel: [    0.671027]  [<ffffffff8105f6cf>] ?
flush_kthread_worker+0xe1/0xe1
Jun 30 19:54:40 vpc5 kernel: [    0.671029] ---[ end trace 0000000000000001 ]---
