Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210Ab3EBUyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:54:19 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62322 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620Ab3EBUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1305022152280.2891@ionos>
References: <20130430212007.GB18598@redhat.com>
	<20130430213719.GA14988@redhat.com>
	<alpine.LFD.2.02.1305021234510.3972@ionos>
	<20130502154621.GA23990@redhat.com>
	<alpine.LFD.2.02.1305022152280.2891@ionos>
Date: Thu, 2 May 2013 13:54:17 -0700
X-Google-Sender-Auth: FRlvCsFQ7-cMhML2sLxFWDVPiRw
Message-ID: <CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 12:58 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

>
> The check should be:
>
>     if (td->evtdev && tick_device_is_functional(td->evtdev))

still happens.

[    3.457866] checking TSC synchronization [CPU#0 -> CPU#10]: passed.
[    3.460806] SMP alternatives: lockdep: fixing up alternatives
[    3.464282] ------------[ cut here ]------------
[    3.464297] WARNING: at kernel/time/clockevents.c:209
clockevents_program_event+0x3b/0x100()
[    3.464300] Modules linked in:
[    3.464306] CPU: 10 PID: 0 Comm: swapper/10 Not tainted
3.9.0-yh-08066-g1252014-dirty #1537
[    3.464308] Hardware name: Oracle Corporation  unknown       /
, BIOS 11016600    05/17/2011
[    3.464327]  0000000000000009 ffff88203e203ed8 ffffffff82091022
ffff88203e203f18
[    3.464343]  ffffffff81088990 ffff88203e203f08 80000000003d08ff
80000000003d08ff
[    3.464359]  000000000000000a ffff881027557fd8 0000000000000000
ffff88203e203f28
[    3.464361] Call Trace:
[    3.464379]  <IRQ>  [<ffffffff82091022>] dump_stack+0x19/0x1b
[    3.464392]  [<ffffffff81088990>] warn_slowpath_common+0x70/0xa0
[    3.464395]  [<ffffffff810889da>] warn_slowpath_null+0x1a/0x20
[    3.464399]  [<ffffffff810e312b>] clockevents_program_event+0x3b/0x100
[    3.464403]  [<ffffffff810e35ec>] tick_handle_periodic+0x4c/0x80
[    3.464409]  [<ffffffff820ae8cd>] smp_apic_timer_interrupt+0x8d/0xa3
[    3.464418]  [<ffffffff820adbef>] apic_timer_interrupt+0x6f/0x80
[    3.464426]  <EOI>  [<ffffffff810527f7>] ? default_idle+0x57/0xd0
[    3.464430]  [<ffffffff810527f5>] ? default_idle+0x55/0xd0
[    3.464434]  [<ffffffff81053078>] arch_cpu_idle+0x18/0x20
[    3.464438]  [<ffffffff810dbec5>] cpu_startup_entry+0x165/0x210
[    3.464446]  [<ffffffff8207f3ad>] start_secondary+0x1df/0x1e6
[    3.464469] ---[ end trace 89673eac7a3370c6 ]---
[    3.717988] smpboot: Booting processor 11 APIC 0x26 ip 0x90000


>
>> a clue: If I disable CONFIG_SLUB_DEBUG, or even boot with slub_debug=- then it boots fine.
>
> Huch? That does not make any sense.

I don't have that CONFIG_SLUB_DEBUG in .config

Yinghai
