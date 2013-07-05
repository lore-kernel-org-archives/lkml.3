Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3GER2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:28:53 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44112 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GER2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:28:52 -0400
MIME-Version: 1.0
Date: Fri, 5 Jul 2013 13:28:51 -0400
Message-ID: <CADCFf2jh20Q6TNL4ykPOGGkSxnNWWDLRcMmjbP5g5zDgPwqWLg@mail.gmail.com>
Subject: WARNING: at kernel/softirq.c:159 _local_bh_enable_ip.isra.10+0x34/0x8a()
 - Hyper-V environment, when host is restarted
From: Fernando Soto <fernando.soto@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kys@microsoft.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this kernel warning in 3.4.52 when running a VM in Hyper-V
environment (W2K8 R2 P1), every time the host is restarted.
Kernels 3.2.48 and 3.10 don't seem to be affected.

Please CC me as I'm not subscribing to the list.

Jul  5 17:07:22 new kernel: [ 2811.916239] ------------[ cut here ]------------
Jul  5 17:07:22 new kernel: [ 2811.917805] WARNING: at
kernel/softirq.c:159 _local_bh_enable_ip.isra.10+0x34/0x8a()
Jul  5 17:07:22 new kernel: [ 2811.918198] Hardware name: Virtual Machine
Jul  5 17:07:22 new kernel: [ 2811.918523] Modules linked in: drbd
lru_cache hv_utils cn processor crc32c_intel psmouse microcode
i2c_piix4 i2c_core thermal_sys button evdev hv_netvsc hv_storvsc
sr_mod cdrom hv_vmbus floppy [last unloaded: scsi_wait_scan]
Jul  5 17:07:22 new kernel: [ 2811.923175] Pid: 0, comm: swapper/0 Not
tainted 3.4.52-amd64 #1
Jul  5 17:07:22 new kernel: [ 2811.923175] Call Trace:
Jul  5 17:07:22 new kernel: [ 2811.923175]  <IRQ>
[<ffffffff8102784b>] ? warn_slowpath_common+0x76/0x8a
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff8102cbcb>] ?
_local_bh_enable_ip.isra.10+0x34/0x8a
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffffa00499eb>] ?
rndis_filter_receive+0x228/0x252 [hv_netvsc]
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffffa0048e64>] ?
netvsc_channel_cb+0x39e/0x462 [hv_netvsc]
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffffa0015012>] ?
vmbus_on_event+0xa3/0xdd [hv_vmbus]
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff8102d240>] ?
tasklet_action+0x6b/0xb2
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff8102cdf6>] ?
__do_softirq+0xb0/0x18d
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff814fee8c>] ?
call_softirq+0x1c/0x30
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff810037e5>] ?
do_softirq+0x2c/0x5f
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff8102d084>] ?
irq_exit+0x3a/0x92
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff81018741>] ?
smp_apic_timer_interrupt+0x73/0x80
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff814fe547>] ?
apic_timer_interrupt+0x67/0x70
Jul  5 17:07:22 new kernel: [ 2811.923175]  <EOI>
[<ffffffff8105b9f1>] ? timekeeping_get_ns+0xd/0x2a
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff810083f9>] ?
default_idle+0x44/0x76
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff810083f3>] ?
default_idle+0x3e/0x76
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff81008b4a>] ?
cpu_idle+0xa2/0xe2
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff818ccabd>] ?
start_kernel+0x392/0x39d
Jul  5 17:07:22 new kernel: [ 2811.923175]  [<ffffffff818cc541>] ?
repair_env_string+0x57/0x57
Jul  5 17:07:22 new kernel: [ 2811.923175] ---[ end trace 887ca61b7ed94f1e ]---

Appreciate any help!

Thanks,
Fernando Soto
