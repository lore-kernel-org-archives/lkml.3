Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031593Ab3HJBjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 21:39:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34860 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030763Ab3HJBjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 21:39:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: cpufreq crash in pm/linux-next 08-07-2013
Date: Sat, 10 Aug 2013 03:49:43 +0200
Message-ID: <2315722.rgGZ4KdPSM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQW-UTvB-NEx9fVv1EmGZg28TE-GeJvfmb+H_GgYjrmB=Q@mail.gmail.com>
References: <CAE9FiQWizduY9w=nOiUOcgo1Got5k8J_ouvgEnygtNXTDe5V9Q@mail.gmail.com> <CAE9FiQW-UTvB-NEx9fVv1EmGZg28TE-GeJvfmb+H_GgYjrmB=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 09, 2013 05:50:45 PM Yinghai Lu wrote:
> On Fri, Aug 9, 2013 at 5:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > from your pm/linux-next
> >
> >
> > [    7.918603] calling  acpi_cpufreq_init+0x0/0x1df @ 1
> > [    7.923917] BUG: unable to handle kernel NULL pointer dereference
> > at           (null)
> > [    7.926780] IP: [<ffffffff8151b277>] __list_del_entry+0xb7/0xe0
> > [    7.927799] PGD 0
> > [    7.927799] Oops: 0000 [#1] SMP
> > [    7.927799] Modules linked in:
> > [    7.927799] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> > 3.11.0-rc4-yh-00839-g7a8b387-dirty #1840
> > [    7.927799] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > [    7.927799] task: ffff88007ab60000 ti: ffff88007ab5c000 task.ti:
> > ffff88007ab5c000
> > [    7.927799] RIP: 0010:[<ffffffff8151b277>]  [<ffffffff8151b277>]
> > __list_del_entry+0xb7/0xe0
> > [    7.927799] RSP: 0018:ffff88007ab5dc98  EFLAGS: 00010007
> > [    7.927799] RAX: 0000000000000000 RBX: ffff880115c85ab8 RCX: dead000000200200
> > [    7.927799] RDX: 0000000000000000 RSI: ffffffff82b96718 RDI: ffff880115c85ab8
> > [    7.927799] RBP: ffff88007ab5dc98 R08: 0000000000000001 R09: 0000000000000001
> > [    7.927799] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000286
> > [    7.927799] R13: 00000000fffffffb R14: ffff88007b80b548 R15: ffff880115c85a00
> > [    7.927799] FS:  0000000000000000(0000) GS:ffff88007b800000(0000)
> > knlGS:0000000000000000
> > [    7.927799] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [    7.927799] CR2: 0000000000000000 CR3: 0000000002a14000 CR4: 00000000000006f0
> > [    7.927799] Stack:
> > [    7.927799]  ffff88007ab5dcb8 ffffffff8151b2b1 0000000000000000
> > ffff880115c85a00
> > [    7.927799]  ffff88007ab5dcd8 ffffffff81e1ef03 0000000000000000
> > 0000000000000000
> > [    7.927799]  ffff88007ab5dd48 ffffffff81e21829 ffff88007ab5dd70
> > ffff88007ab5dd70
> > [    7.927799] Call Trace:
> > [    7.927799]  [<ffffffff8151b2b1>] list_del+0x11/0x40
> > [    7.927799]  [<ffffffff81e1ef03>] cpufreq_policy_free+0x33/0x70
> > [    7.927799]  [<ffffffff81e21829>] __cpufreq_add_dev.isra.3+0x6b9/0x760
> > [    7.927799]  [<ffffffff81e218e0>] cpufreq_add_dev+0x10/0x20
> > [    7.927799]  [<ffffffff81762e49>] subsys_interface_register+0x99/0xf0
> > [    7.927799]  [<ffffffff81e1fc52>] cpufreq_register_driver+0xb2/0x1a0
> > [    7.927799]  [<ffffffff82e18ff3>] acpi_cpufreq_init+0xbd/0x1df
> > [    7.927799]  [<ffffffff810ee56a>] ? ktime_get+0x6a/0xe0
> > [    7.927799]  [<ffffffff82e18f36>] ? cpufreq_gov_dbs_init+0x12/0x12
> > [    7.927799]  [<ffffffff81000272>] do_one_initcall+0x72/0x170
> > [    7.927799]  [<ffffffff810bac00>] ? parse_args+0x150/0x350
> > [    7.927799]  [<ffffffff820b9830>] ? printk+0x4d/0x4f
> > [    7.927799]  [<ffffffff82dc2370>] kernel_init_freeable+0x1bf/0x251
> > [    7.927799]  [<ffffffff82dc1a9c>] ? loglevel+0x31/0x31
> > [    7.927799]  [<ffffffff820aef50>] ? rest_init+0xd0/0xd0
> > [    7.927799]  [<ffffffff820aef5e>] kernel_init+0xe/0xf0
> > [    7.927799]  [<ffffffff820dd25c>] ret_from_fork+0x7c/0xb0
> > [    7.927799]  [<ffffffff820aef50>] ? rest_init+0xd0/0xd0
> > [    7.927799] Code: 84 82 be 3e 00 00 00 48 c7 c7 16 ca 84 82 31 c0
> > e8 7f c8 b7 ff eb 2c 0f 1f 44 00 00 48 b9 00 02 20 00 00 00 ad de 48
> > 39 c8 74 8c <4c> 8b 00 4c 39 c7 75 a6 4c 8b 42 08 4c 39 c7 75 bc 48 89
> > 42 08
> > [    7.927799] RIP  [<ffffffff8151b277>] __list_del_entry+0xb7/0xe0
> > [    7.927799]  RSP <ffff88007ab5dc98>
> > [    7.927799] CR2: 0000000000000000
> > [    7.927799] ---[ end trace 3db50d3cbca4646d ]---
> > [    8.003780] Kernel panic - not syncing: Attempted to kill init!
> > exitcode=0x00000009
> > [    8.003780]
> >
> >
> > looks like it caused by patches from Viresh Kumar around Aug 6.
> 
> attached patch fix the problem.
> 
> Please fold it into offending commit.

Done, thanks a lot Yinghai!

> commit 91e776cc60fb0a7e58c392189dd9cced54cb1fa0
> Author: Lukasz Majewski <l.majewski@samsung.com>
> Date:   Tue Aug 6 22:53:08 2013 +0530
> 
>     cpufreq: Store cpufreq policies in a list
> 
>     Policies available in the cpufreq framework are now linked together.
>     They are accessible via cpufreq_policy_list defined in the cpufreq
>     core.
> 
>     Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
>     Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
