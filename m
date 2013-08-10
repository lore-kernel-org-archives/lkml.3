Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031836Ab3HJCvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 22:51:00 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:37688 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031621Ab3HJCu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 22:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWizduY9w=nOiUOcgo1Got5k8J_ouvgEnygtNXTDe5V9Q@mail.gmail.com>
References: <CAE9FiQWizduY9w=nOiUOcgo1Got5k8J_ouvgEnygtNXTDe5V9Q@mail.gmail.com>
Date: Sat, 10 Aug 2013 08:20:58 +0530
Message-ID: <CAKohpomyvT=5HK=EaO3aY7hVj3yHAyS_WTFTHPQZiVGv1anWrQ@mail.gmail.com>
Subject: Re: cpufreq crash in pm/linux-next 08-07-2013
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 August 2013 05:56, Yinghai Lu <yinghai@kernel.org> wrote:
> from your pm/linux-next
>
>
> [    7.918603] calling  acpi_cpufreq_init+0x0/0x1df @ 1
> [    7.923917] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [    7.926780] IP: [<ffffffff8151b277>] __list_del_entry+0xb7/0xe0
> [    7.927799] PGD 0
> [    7.927799] Oops: 0000 [#1] SMP
> [    7.927799] Modules linked in:
> [    7.927799] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.11.0-rc4-yh-00839-g7a8b387-dirty #1840
> [    7.927799] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    7.927799] task: ffff88007ab60000 ti: ffff88007ab5c000 task.ti:
> ffff88007ab5c000
> [    7.927799] RIP: 0010:[<ffffffff8151b277>]  [<ffffffff8151b277>]
> __list_del_entry+0xb7/0xe0
> [    7.927799] RSP: 0018:ffff88007ab5dc98  EFLAGS: 00010007
> [    7.927799] RAX: 0000000000000000 RBX: ffff880115c85ab8 RCX: dead000000200200
> [    7.927799] RDX: 0000000000000000 RSI: ffffffff82b96718 RDI: ffff880115c85ab8
> [    7.927799] RBP: ffff88007ab5dc98 R08: 0000000000000001 R09: 0000000000000001
> [    7.927799] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000286
> [    7.927799] R13: 00000000fffffffb R14: ffff88007b80b548 R15: ffff880115c85a00
> [    7.927799] FS:  0000000000000000(0000) GS:ffff88007b800000(0000)
> knlGS:0000000000000000
> [    7.927799] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    7.927799] CR2: 0000000000000000 CR3: 0000000002a14000 CR4: 00000000000006f0
> [    7.927799] Stack:
> [    7.927799]  ffff88007ab5dcb8 ffffffff8151b2b1 0000000000000000
> ffff880115c85a00
> [    7.927799]  ffff88007ab5dcd8 ffffffff81e1ef03 0000000000000000
> 0000000000000000
> [    7.927799]  ffff88007ab5dd48 ffffffff81e21829 ffff88007ab5dd70
> ffff88007ab5dd70
> [    7.927799] Call Trace:
> [    7.927799]  [<ffffffff8151b2b1>] list_del+0x11/0x40
> [    7.927799]  [<ffffffff81e1ef03>] cpufreq_policy_free+0x33/0x70
> [    7.927799]  [<ffffffff81e21829>] __cpufreq_add_dev.isra.3+0x6b9/0x760
> [    7.927799]  [<ffffffff81e218e0>] cpufreq_add_dev+0x10/0x20
> [    7.927799]  [<ffffffff81762e49>] subsys_interface_register+0x99/0xf0
> [    7.927799]  [<ffffffff81e1fc52>] cpufreq_register_driver+0xb2/0x1a0
> [    7.927799]  [<ffffffff82e18ff3>] acpi_cpufreq_init+0xbd/0x1df
> [    7.927799]  [<ffffffff810ee56a>] ? ktime_get+0x6a/0xe0
> [    7.927799]  [<ffffffff82e18f36>] ? cpufreq_gov_dbs_init+0x12/0x12
> [    7.927799]  [<ffffffff81000272>] do_one_initcall+0x72/0x170
> [    7.927799]  [<ffffffff810bac00>] ? parse_args+0x150/0x350
> [    7.927799]  [<ffffffff820b9830>] ? printk+0x4d/0x4f
> [    7.927799]  [<ffffffff82dc2370>] kernel_init_freeable+0x1bf/0x251
> [    7.927799]  [<ffffffff82dc1a9c>] ? loglevel+0x31/0x31
> [    7.927799]  [<ffffffff820aef50>] ? rest_init+0xd0/0xd0
> [    7.927799]  [<ffffffff820aef5e>] kernel_init+0xe/0xf0
> [    7.927799]  [<ffffffff820dd25c>] ret_from_fork+0x7c/0xb0
> [    7.927799]  [<ffffffff820aef50>] ? rest_init+0xd0/0xd0

I am surprised that I didn't see it while testing.. And I did removed
all CPUs from one of my policies.
