Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3GLJHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:07:47 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63954 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3GLJHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:07:44 -0400
MIME-Version: 1.0
X-Originating-IP: [121.6.68.144]
Date: Fri, 12 Jul 2013 17:07:43 +0800
Message-ID: <CAMVG2svtmmVTwiUTZ_Crw9maSLYAYZ0qwABb+gp4PA0_6=po9Q@mail.gmail.com>
Subject: BCM57765 card reader: irq nobody cared
From: Daniel J Blueman <daniel@quora.org>
To: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the Broadcom BCM57765 card reader [1] in my Macbook Pro 10,1 (Mid
2012), we see the sdhci-pci interrupt handler not claim the interrupt
generated when the module initialises [2].

Beyond the MMC subsystem output, what other data may be useful in
diagnosing this?

Many thanks,
  Daniel

--- [1]

$ sudo lspci -s 03:00.1 -v
03:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765
Memory Card Reader (rev 10) (prog-if 01)
    Subsystem: Broadcom Corporation Device 96bc
    Flags: bus master, fast devsel, latency 0, IRQ 17
    Memory at c1820000 (64-bit, prefetchable) [size=64K]
    Capabilities: [48] Power Management version 3
    Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
    Capabilities: [ac] Express Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [150] Power Budgeting <?>
    Capabilities: [160] Virtual Channel
    Kernel driver in use: sdhci-pci

--- [2]

sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:03:00.1: SDHCI controller found [14e4:16bc] (rev 10)
mmc0: no vqmmc regulator found
mmc0: no vmmc regulator found
mmc0: SDHCI controller on PCI [0000:03:00.1] using ADMA
[...]
irq 17: nobody cared (try booting with the "irqpoll" option)
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    W  3.10.0-031000-generic
#201306301935
Hardware name: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
MBP101.88Z.00EE.B02.1208081132 08/08/2012
 ffff8802635cd89c ffff88026f203e48 ffffffff81703460 ffff88026f203e78
 ffffffff810f0d6d 000000029d3daf00 ffff8802635cd800 0000000000000011
 0000000000000000 ffff88026f203ea8 ffffffff810f1195 0000000000000011
Call Trace:
 <IRQ> [<ffffffff81703460>] dump_stack+0x19/0x1b
 [<ffffffff810f0d6d>] __report_bad_irq+0x3d/0xe0
 [<ffffffff810f1195>] note_interrupt+0x135/0x190
 [<ffffffff810ee9d9>] handle_irq_event_percpu+0xa9/0x210
 [<ffffffff8101b459>] ? sched_clock+0x9/0x10
 [<ffffffff810eeb8e>] handle_irq_event+0x4e/0x80
 [<ffffffff810f1db4>] handle_fasteoi_irq+0x64/0x120
 [<ffffffff81015a02>] handle_irq+0x22/0x40
 [<ffffffff817199da>] do_IRQ+0x5a/0xe0
 [<ffffffff8170ef6d>] common_interrupt+0x6d/0x6d
 <EOI> [<ffffffff810f6f03>] ? rcu_eqs_enter_common.isra.48+0x43/0x100
 [<ffffffff81598b01>] ? cpuidle_enter_state+0x61/0xe0
 [<ffffffff81598af7>] ? cpuidle_enter_state+0x57/0xe0
 [<ffffffff81598c40>] cpuidle_idle_call+0xc0/0x220
 [<ffffffff8101c77e>] arch_cpu_idle+0xe/0x30
 [<ffffffff810acd0e>] cpu_idle_loop+0x7e/0x250
 [<ffffffff810acf4b>] cpu_startup_entry+0x6b/0x70
 [<ffffffff816df8c7>] rest_init+0x77/0x80
 [<ffffffff81d13f11>] start_kernel+0x40c/0x419
 [<ffffffff81d13997>] ? do_early_param+0x87/0x87
 [<ffffffff81d13120>] ? early_idt_handlers+0x120/0x120
 [<ffffffff81d135e6>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81d136db>] x86_64_start_kernel+0xf3/0x102
handlers:
[<ffffffffa000fb40>] sdhci_irq [sdhci]
Disabling IRQ #17
--
Daniel J Blueman
