Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3LSICY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:02:24 -0500
Received: from mail-ph.de-nserver.de ([85.158.179.214]:50311 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3LSICX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:02:23 -0500
X-Fcrdns: No
Message-ID: <52B2A81F.9010401@profihost.ag>
Date: Thu, 19 Dec 2013 09:02:39 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: p.herz@profihost.ag, dhecht@vmware.com, fweisbec@gmail.com,
        hpa@linux.intel.com, mingo@kernel.org
Subject: Vanilla 3.10.22 kvm_arch_vcpu_uninit => WARNING: at kernel/jump_label.c:80
 __static_key_slow_dec
References: <52B1BA8D.1010901@profihost.ag> <52B1CCA8.7010100@profihost.ag>
In-Reply-To: <52B1CCA8.7010100@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

while running Qemu 1.7.0 on vanilla kernel 3.10.22 i've seen several 
times this error:
[99964.659578] WARNING: at kernel/jump_label.c:80 
__static_key_slow_dec+0xb6/0xc0()
[99964.659579] jump label: negative count!
[99964.659579] Modules linked in: sch_htb act_police cls_u32 sch_ingress 
vhost_net tun macvtap macvlan netconsole ipt_REJECT dlm sctp 
iptable_filter ip_tables x_tables iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi fuse nfsd auth_rpcgss oid_registry bonding ext2 
8021q garp acpi_cpufreq mperf coretemp kvm_intel kvm crc32_pclmul 
ghash_clmulni_intel microcode i2c_i801 button dm_mod raid1 md_mod usbhid 
usb_storage ohci_hcd sg sd_mod ehci_pci ehci_hcd igb ahci i2c_algo_bit 
libahci isci usbcore i2c_core usb_common ptp libsas ixgbe(O) 
scsi_transport_sas pps_core
[99964.659595] CPU: 32 PID: 6616 Comm: kvm Tainted: G        W  O 
3.10.22+63-ph #1
[99964.659596] Hardware name: Supermicro 
X9DRW-3LN4F+/X9DRW-3TF+/X9DRW-3LN4F+/X9DRW-3TF+, BIOS 3.00 07/05/2013
[99964.659596]  0000000000000009 ffff882ff83359f8 ffffffff8151ba2d 
ffff882ff8335a38
[99964.659599]  ffffffff8104828b 00000000f8335a18 ffffffffa04d7c40 
00000000000000fa
[99964.659602]  ffffffffa04d7c60 ffff8817eca74160 ffff8817f92c51a0 
ffff882ff8335a98
[99964.659605] Call Trace:
[99964.659606]  [<ffffffff8151ba2d>] dump_stack+0x19/0x1b
[99964.659608]  [<ffffffff8104828b>] warn_slowpath_common+0x6b/0xa0
[99964.659611]  [<ffffffff81048361>] warn_slowpath_fmt+0x41/0x50
[99964.659613]  [<ffffffff810e0036>] __static_key_slow_dec+0xb6/0xc0
[99964.659614]  [<ffffffff810e0071>] static_key_slow_dec_deferred+0x11/0x20
[99964.659621]  [<ffffffffa04bb010>] kvm_free_lapic+0x90/0xa0 [kvm]
[99964.659627]  [<ffffffffa04a4fb3>] kvm_arch_vcpu_uninit+0x23/0x90 [kvm]
[99964.659632]  [<ffffffffa048ba20>] kvm_vcpu_uninit+0x20/0x40 [kvm]
[99964.659636]  [<ffffffffa01cec12>] vmx_free_vcpu+0x52/0x70 [kvm_intel]
[99964.659642]  [<ffffffffa04a46af>] kvm_arch_vcpu_free+0x4f/0x60 [kvm]
[99964.659648]  [<ffffffffa04a51d2>] kvm_arch_destroy_vm+0xf2/0x1f0 [kvm]
[99964.659650]  [<ffffffff81070be8>] ? synchronize_srcu+0x18/0x20
[99964.659652]  [<ffffffff81125b9a>] ? mmu_notifier_unregister+0xaa/0xe0
[99964.659658]  [<ffffffffa048e80e>] kvm_put_kvm+0x10e/0x1b0 [kvm]
[99964.659663]  [<ffffffffa048ea33>] kvm_vcpu_release+0x13/0x20 [kvm]
[99964.659665]  [<ffffffff81142fb1>] __fput+0xe1/0x230
[99964.659667]  [<ffffffff81143109>] ____fput+0x9/0x10
[99964.659669]  [<ffffffff81068985>] task_work_run+0xb5/0xd0
[99964.659671]  [<ffffffff8104d76c>] do_exit+0x2ac/0xa30
[99964.659673]  [<ffffffff810925fc>] ? __unqueue_futex+0x2c/0x60
[99964.659675]  [<ffffffff810937b2>] ? futex_wait+0x122/0x280
[99964.659677]  [<ffffffff8104df6a>] do_group_exit+0x3a/0xa0
[99964.659679]  [<ffffffff8105bf14>] get_signal_to_deliver+0x1a4/0x590
[99964.659681]  [<ffffffff81002292>] do_signal+0x52/0x5f0
[99964.659683]  [<ffffffff8109526d>] ? do_futex+0x12d/0x590
[99964.659685]  [<ffffffff8105c8c2>] ? copy_siginfo_to_user+0x122/0x2c0
[99964.659687]  [<ffffffff8105ccac>] ? SYSC_rt_sigtimedwait+0xac/0xd0
[99964.659689]  [<ffffffff8107d020>] ? __enqueue_entity+0x70/0x80
[99964.659691]  [<ffffffff81002895>] do_notify_resume+0x65/0x80
[99964.659693]  [<ffffffff81521598>] int_signal+0x12/0x17
[99964.659694] ---[ end trace d92047d5c4d5d3d1 ]---


Stefan
