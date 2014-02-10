Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaBJCAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:00:37 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37597 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaBJCAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:00:36 -0500
Message-ID: <52F832C0.9070702@gmail.com>
Date: Mon, 10 Feb 2014 03:00:32 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Josh Boyer <jwboyer@redhat.com>, "Justin M. Forbes" <jforbes@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: WARNING: CPU: 0 PID: 2243 at mm/slub.c:1007 deactivate_slab+0x4e0/0x590()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ahoy!

"Tracking of fully allocated slabs for debugging purposes."
Are this warnings expected and therefore not a bug?
Thanks.

[   83.530421] WARNING: CPU: 0 PID: 2243 at mm/slub.c:1007
deactivate_slab+0x4e0/0x590()
[   83.530440] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
xt_CHECKSUM iptable_mangle fuse ip6table_filter ip6_tables ebtable_nat
ebtables kvm_amd kvm ppdev microcode serio_raw nouveau mxm_wmi video
i2c_algo_bit ttm edac_core edac_mce_amd drm_kms_helper k10temp drm
parport_serial parport_pc parport wmi shpchp i2c_nforce2 i2c_core
acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd sunrpc binfmt_misc
ata_generic pata_acpi pata_amd 8021q garp mrp tun bridge stp llc bonding
[   83.530441] CPU: 0 PID: 2243 Comm: systemd-sleep Tainted: G        W
   3.14.0-0.rc1.git5.1.fc21.1.x86_64 #1
[   83.530442] Hardware name: Gigabyte Technology Co., Ltd.
M720-US3/M720-US3, BIOS F7n 09/07/2010
[   83.530444]  0000000000000000 00000000c8ff680f ffff8800ae5ffb28
ffffffff817cf05d
[   83.530445]  0000000000000000 ffff8800ae5ffb60 ffffffff810966cd
0000000000000002
[   83.530447]  ffff88012a003700 ffff88012a000c00 0000000000000000
ffffea0003205b80
[   83.530447] Call Trace:
[   83.530448]  [<ffffffff817cf05d>] dump_stack+0x4d/0x66
[   83.530450]  [<ffffffff810966cd>] warn_slowpath_common+0x7d/0xa0
[   83.530451]  [<ffffffff810967fa>] warn_slowpath_null+0x1a/0x20
[   83.530452]  [<ffffffff8120d870>] deactivate_slab+0x4e0/0x590
[   83.530454]  [<ffffffff810f8739>] ? mark_held_locks+0xb9/0x140
[   83.530455]  [<ffffffff8120da4c>] slab_cpuup_callback+0xcc/0x130
[   83.530457]  [<ffffffff817dd586>] notifier_call_chain+0x66/0x150
[   83.530459]  [<ffffffff810ca41e>] __raw_notifier_call_chain+0xe/0x10
[   83.530460]  [<ffffffff81096933>] cpu_notify+0x23/0x50
[   83.530461]  [<ffffffff8109696e>] cpu_notify_nofail+0xe/0x20
[   83.530462]  [<ffffffff817bf8c5>] _cpu_down+0x1d5/0x350
[   83.530464]  [<ffffffff81096fe5>] disable_nonboot_cpus+0xa5/0x150
[   83.530465]  [<ffffffff81101bad>] suspend_devices_and_enter+0x21d/0x670
[   83.530466]  [<ffffffff81102178>] pm_suspend+0x178/0x260
[   83.530468]  [<ffffffff81100b49>] state_store+0x79/0xf0
[   83.530469]  [<ffffffff813c8f6f>] kobj_attr_store+0xf/0x20
[   83.530471]  [<ffffffff812bc844>] sysfs_kf_write+0x44/0x60
[   83.530472]  [<ffffffff812c0de5>] kernfs_fop_write+0xd5/0x150
[   83.530473]  [<ffffffff81232f2d>] vfs_write+0xbd/0x1f0
[   83.530475]  [<ffffffff81255c45>] ? __fget_light+0x145/0x160
[   83.530476]  [<ffffffff812339bb>] SyS_write+0x5b/0xb0
[   83.530477]  [<ffffffff817e2ea9>] system_call_fastpath+0x16/0x1b
[   83.530478] ---[ end trace d6d150ba17d5207a ]---
[   83.534749] kvm: disabling virtualization on CPU2
[   83.534787] smpboot: CPU 2 is now offline
[   83.537960] kvm: disabling virtualization on CPU3
[   83.538003] smpboot: CPU 3 is now offline
[   83.538181] ------------[ cut here ]------------

https://bugzilla.redhat.com/attachment.cgi?id=861203
https://bugzilla.redhat.com/show_bug.cgi?id=1063096


poma

