Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3GWBKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:10:34 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:59317 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3GWBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:10:33 -0400
Message-ID: <51EDD806.70507@gmail.com>
Date: Tue, 23 Jul 2013 03:10:30 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 3.10.2: WARNING: at kernel/time/tick-broadcast.c:585
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Resume from S3 generates WARNING:
…
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
PCI-DMA: Resuming GART IOMMU
PCI-DMA: Restoring GART aperture settings
Enabling non-boot CPUs ...
smpboot: Booting Node 0 Processor 1 APIC 0x1
[Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #1
process: Switch to broadcast mode on CPU1
CPU1 is up
smpboot: Booting Node 0 Processor 2 APIC 0x2
------------[ cut here ]------------
3.10.2: WARNING: at kernel/time/tick-broadcast.c:585
tick_broadcast_oneshot_control+0x170/0x180()
Modules linked in: raid1 nouveau video mxm_wmi i2c_algo_bit
drm_kms_helper ttm drm i2c_core wmi
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.2-301.fc19.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. M720-US3/M720-US3, BIOS F7n
09/07/2010
 0000000000000009 ffff880129b2fd68 ffffffff81642886 ffff880129b2fda0
 ffffffff8105c211 0000000000000001 0000000000000004 ffff88012fc4dbc0
 0000000000000002 ffffffff81c21c40 ffff880129b2fdb0 ffffffff8105c2ea
Call Trace:
 [<ffffffff81642886>] dump_stack+0x19/0x1b
 [<ffffffff8105c211>] warn_slowpath_common+0x61/0x80
 [<ffffffff8105c2ea>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810b34e0>] tick_broadcast_oneshot_control+0x170/0x180
 [<ffffffff810b29dd>] tick_notify+0x2fd/0x440
 [<ffffffff8164c84c>] notifier_call_chain+0x4c/0x70
 [<ffffffff81086246>] raw_notifier_call_chain+0x16/0x20
 [<ffffffff810b1f29>] clockevents_notify+0x39/0x140
 [<ffffffff81019675>] amd_e400_idle+0x75/0x100
 [<ffffffff81019e36>] arch_cpu_idle+0x26/0x30
 [<ffffffff810aa3be>] cpu_startup_entry+0xce/0x280
 [<ffffffff810b20e5>] ? clockevents_register_device+0xb5/0x120
 [<ffffffff8163794e>] start_secondary+0x24e/0x250
---[ end trace b32aec91b6f72d81 ]---
[Firmware Bug]: cpu 2, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #2
process: Switch to broadcast mode on CPU2
CPU2 is up
smpboot: Booting Node 0 Processor 3 APIC 0x3
[Firmware Bug]: cpu 3, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #3
process: Switch to broadcast mode on CPU3
CPU3 is up
ACPI: Waking up from system sleep state S3
…

With an additional four patches[1] WARNING persists.

CONF.
http://kojipkgs.fedoraproject.org//packages/kernel/3.10.2/301.fc19/data/logs/x86_64/build.log


poma


[1]
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/kernel/time/tick-broadcast.c
- tick: Make oneshot broadcast robust vs. CPU offlining
- tick: Prevent uncontrolled switch to oneshot mode
- tick: Sanitize broadcast control logic
- tick: broadcast: Check broadcast mode on CPU hotplug

