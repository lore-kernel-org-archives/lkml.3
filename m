Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaLVRHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:07:45 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:53859 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbaLVRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:07:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoGAIRPmFR5LXwz/2dsb2JhbABbgwaELsZogk0CgRgXAQEBAQF9hA0BBSMVHh4EARAIAw4MAgUUAgsCAgkDAgECASceBg0BBwKIJ7oOlgYBAQEHAQEBAQEdgSGOUQeCaIFBAQSgZyOHRCKCMoFPK4J0AQEB
Message-ID: <54984FCC.1070008@internode.on.net>
Date: Tue, 23 Dec 2014 03:37:24 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: general protection fault on 3.19.0-rc1 / amd64 SMP anon_vma_interval_tree_remove
 (?)
References: <6624c5997d630f90ef4243b18d3504910c3e653d@webmail.internode.on.net> <54978AFC.7080104@internode.on.net> <20141222090545.GA21163@pd.tnic>
In-Reply-To: <20141222090545.GA21163@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Borislav Petkov wrote on 22/12/14 19:35:
...
>> I haven't hit one of these errors for a while and this has only
>> happened the once with this kernel. If anyone wants more details I'm
>> happy to supply them.
>
> Does that mean that you've hit similar corruptions in the past too? If
> so, do they all look the same or are wildly different, i.e. stack trace
> and RIP points at different functions and they happen during different
> moments of the system lifetime?
>
> Thanks.
>

This was similar (around file system check time):

[    0.000000] Linux version 3.16.0-rc6+ (root@am64) (gcc version 4.9.1 
(Debian
4.9.1-1) ) #1097 SMP Thu Jul 24 12:33:01 CST 2014

[   17.495002] general protection fault: 0000 [#1] SMP
[   17.497316] Modules linked in: ir_mce_kbd_decoder ir_sharp_decoder 
ir_lirc_co
dec ir_sanyo_decoder lirc_dev ir_jvc_decoder ir_sony_decoder 
ir_rc5_decoder ir_r
c6_decoder ir_nec_decoder fc0012 dvb_usb_rtl28xxu rtl2830 rtl2832 
i2c_mux dvb_us
b_v2 radeon dvb_core rc_core snd_hda_codec_realtek snd_hda_codec_generic 
snd_hda
_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep 
snd_pcm kvm
_amd ttm evdev snd_timer snd drm_kms_helper kvm drm psmouse soundcore 
serio_raw
i2c_algo_bit edac_mce_amd edac_core pcspkr acpi_cpufreq k10temp 
sp5100_tco shpch
p processor asus_atk0110 i2c_piix4 button wmi i2c_core thermal_sys ext4 
mbcache
crc16 jbd2 sd_mod crc_t10dif crct10dif_generic sg sr_mod cdrom 
crct10dif_common
ata_generic uas usb_storage ohci_pci ahci pata_atiixp libahci ohci_hcd 
ehci_pci
ehci_hcd libata r8169 usbcore mii scsi_mod usb_common
[   17.508155] CPU: 0 PID: 905 Comm: mount Not tainted 3.16.0-rc6+ #1097
[   17.510948] Hardware name: System manufacturer System Product 
Name/M3A78 PRO,
  BIOS 1701    01/27/2011
[   17.513802] task: ffff88022e9aa190 ti: ffff8800ca798000 task.ti: 
ffff8800ca79
8000
[   17.516656] RIP: 0010:[<ffffffff811bb473>]  [<ffffffff811bb473>] 
__destroy_in
ode+0x53/0xd0
[   17.519529] RSP: 0018:ffff8800ca79bdd0  EFLAGS: 00010202
[   17.522390] RAX: 0d9f618e0000000a RBX: ffff880222c60488 RCX: 
0000000000000009
[   17.525286] RDX: 0000000000000009 RSI: ffff8800ca79bd98 RDI: 
0d9f618e0000000b
[   17.528188] RBP: ffff880222c60488 R08: 0000000000000000 R09: 
fdbf3a8389754a03
[   17.531112] R10: ffffffffffffffff R11: ffff88022db777d0 R12: 
ffff88022d9cf8b0
[   17.534063] R13: ffff88022d9cf858 R14: ffff88022d9cf8b0 R15: 
0000000000000040
[   17.537012] FS:  00007f0b73736840(0000) GS:ffff88022fc00000(0000) 
knlGS:00000
00000000000
[   17.539956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.542870] CR2: 0000000001bdb068 CR3: 00000000cb961000 CR4: 
00000000000007f0
[   17.545792] Stack:
[   17.548716]  ffff880222c60488 ffffffff811bb509 ffff88022d9cf858 
ffffffff811b7
3d0
[   17.551687]  ffff88022da28498 ffff88022d9cf8d8 ffff8800ca79be50 
ffffffff811b7
781
[   17.554632]  0000000000000685 0000000000000685 ffff8800ca79be50 
ffff880221fcc
3c8
[   17.557569] Call Trace:
[   17.560486]  [<ffffffff811bb509>] ? destroy_inode+0x19/0x50
[   17.563414]  [<ffffffff811b73d0>] ? __dentry_kill+0x180/0x1e0
[   17.566318]  [<ffffffff811b7781>] ? shrink_dentry_list+0xf1/0x2b0
[   17.569207]  [<ffffffff811b7a15>] ? shrink_dcache_sb+0xd5/0x110
[   17.572053]  [<ffffffff811a3ee5>] ? do_remount_sb+0x55/0x1b0
[   17.574861]  [<ffffffff811c1dc3>] ? do_mount+0x843/0xa40
[   17.577628]  [<ffffffff8114ff06>] ? memdup_user+0x46/0x80
[   17.580369]  [<ffffffff811c22e3>] ? SyS_mount+0xb3/0x120
[   17.583078]  [<ffffffff815089e9>] ? system_call_fastpath+0x16/0x1b
[   17.585777] Code: 48 8b 7b 10 48 8d 47 ff 48 83 f8 fd 77 0a 48 85 ff 
74 05 f0
  ff 0f 74 58 48 8b 7b 18 48 8d 47 ff 48 83 f8 fd 77 0a 48 85 ff 74 05 
<f0> ff 0f
  74 30 65 48 ff 0c 25 60 09 01 00 5b c3 0f 1f 44 00 00
[   17.588830] RIP  [<ffffffff811bb473>] __destroy_inode+0x53/0xd0
[   17.591717]  RSP <ffff8800ca79bdd0>
[   17.594636] ---[ end trace 2be4e73086360058 ]---

This double fault occurred at a later stage:

[    0.000000] Linux version 3.18.0-rc4 (root@am64) (gcc version 4.9.2 
(Debian 4
.9.2-1) ) #1335 SMP PREEMPT Mon Nov 10 12:59:11 ACDT 2014

[13296.384076] general protection fault: 0000 [#1] PREEMPT SMP
[13296.384123] Modules linked in: rfcomm arc4 ecb md4 hmac nls_utf8 cifs 
dns_res
olver fscache bnep bluetooth nfc cpufreq_userspace rfkill 
cpufreq_conservative c
pufreq_powersave cpufreq_stats binfmt_misc uinput max6650 fuse 
parport_pc ppdev
lp parport snd_hda_codec_hdmi ir_sharp_decoder ir_mce_kbd_decoder 
ir_lirc_codec
ir_nec_decoder ir_jvc_decoder ir_sanyo_decoder ir_xmp_decoder lirc_dev 
ir_rc6_de
coder ir_rc5_decoder ir_sony_decoder fc0012 dvb_usb_rtl28xxu rtl2830 
rtl2832 i2c
_mux dvb_usb_v2 dvb_core snd_hda_codec_realtek snd_hda_codec_generic 
snd_hda_int
el snd_hda_controller rc_core snd_hda_codec radeon snd_hwdep snd_pcm_oss 
kvm_amd
  snd_mixer_oss kvm snd_pcm ttm snd_timer snd drm_kms_helper sp5100_tco 
psmouse d
rm i2c_piix4 pcspkr k10temp soundcore wmi evdev i2c_algo_bit serio_raw 
acpi_cpuf
req processor
[13296.384536]  asus_atk0110 button thermal_sys ext4 mbcache crc16 jbd2 
sg sr_mo
d sd_mod cdrom ata_generic uas usb_storage ohci_pci pata_atiixp ahci 
libahci ohc
i_hcd libata ehci_pci ehci_hcd scsi_mod r8169 mii usbcore usb_common
[13296.384658] CPU: 1 PID: 4122 Comm: iceweasel Not tainted 3.18.0-rc4 #1335
[13296.384690] Hardware name: System manufacturer System Product 
Name/M3A78 PRO,
  BIOS 1701    01/27/2011
[13296.384733] task: ffff8800c3fd6990 ti: ffff8800c3fd8000 task.ti: 
ffff8800c3fd
8000
[13296.384767] RIP: 0010:[<ffffffff8108f1f0>]  [<ffffffff8108f1f0>] 
__lock_acqui
re+0x140/0x1d20
[13296.384813] RSP: 0018:ffff8800c3fdba08  EFLAGS: 00010002
[13296.384838] RAX: 0000000000000001 RBX: ffff8800c3fd6990 RCX: 
0000000000000000
[13296.384871] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
0a7aaf6900000110
[13296.384903] RBP: ffff8800c3fdbad8 R08: 0000000000000001 R09: 
0000000000000001
[13296.384936] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[13296.384969] R13: 0000000000000000 R14: 0000000000000000 R15: 
0a7aaf6900000110
[13296.385002] FS:  00007f63c5931740(0000) GS:ffff88022d440000(0000) 
knlGS:00000
00000000000
[13296.385039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13296.385065] CR2: 0000000001c109e0 CR3: 000000022f00e000 CR4: 
00000000000007e0
[13296.385098] Stack:
[13296.385108]  0000000000000000 ffffffff81a9e4d8 ffff8800c3fdbaf8 
0000000000000
046
[13296.385147]  000000000000000c 0000000000016b90 ffff8800c3fdba48 
0000000000000
096
[13296.385185]  ffff8800c3fdba98 ffff8800c3fd6990 000000000000000c 
0000000000000
00e
[13296.385224] Call Trace:
[13296.385241]  [<ffffffff81135944>] ? free_pcppages_bulk+0x34/0x490
[13296.385270]  [<ffffffff8109161b>] lock_acquire+0xbb/0x160
[13296.385298]  [<ffffffff810e2313>] ? res_counter_uncharge_until+0x73/0xe0
[13296.385332]  [<ffffffff8151e6c6>] _raw_spin_lock+0x36/0x50
[13296.385359]  [<ffffffff810e2313>] ? res_counter_uncharge_until+0x73/0xe0
[13296.385391]  [<ffffffff810e2313>] res_counter_uncharge_until+0x73/0xe0
[13296.385422]  [<ffffffff810e238e>] res_counter_uncharge+0xe/0x10
[13296.385452]  [<ffffffff8118c2ef>] uncharge_batch+0x17f/0x1a0
[13296.385479]  [<ffffffff8118c4a0>] uncharge_list+0x190/0x1b0
[13296.385506]  [<ffffffff81190a7e>] mem_cgroup_uncharge_list+0x1e/0x30
[13296.385537]  [<ffffffff8113d9d8>] release_pages+0x1d8/0x260
[13296.385564]  [<ffffffff8117039d>] free_pages_and_swap_cache+0x8d/0xa0
[13296.385596]  [<ffffffff811592cc>] tlb_flush_mmu_free+0x2c/0x50
[13296.385624]  [<ffffffff81159e2d>] tlb_finish_mmu+0x4d/0x50
[13296.385651]  [<ffffffff81165193>] exit_mmap+0xc3/0x170
[13296.385677]  [<ffffffff8104787d>] mmput+0x4d/0x110
[13296.385700]  [<ffffffff8104d4d3>] do_exit+0x333/0xb40
[13296.385725]  [<ffffffff8104dd6f>] do_group_exit+0x4f/0xe0
[13296.385751]  [<ffffffff8104de0f>] SyS_exit_group+0xf/0x10
[13296.385778]  [<ffffffff8151f6a9>] system_call_fastpath+0x12/0x17
[13296.385806] Code: 00 00 4d 85 d2 75 4f 0f 1f 40 00 45 31 e4 44 89 e0 
48 8b 5d
  d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 40 00 
<49> 81 3f
  00 88 be 81 b8 00 00 00 00 44 0f 44 c0 41 83 fe 01 44
[13296.385973] RIP  [<ffffffff8108f1f0>] __lock_acquire+0x140/0x1d20
[13296.386003]  RSP <ffff8800c3fdba08>
[13296.397480] ---[ end trace ebc114df3d04c024 ]---
[13296.397482] Fixing recursive fault but reboot is needed!
[13296.397485] BUG: scheduling while atomic: iceweasel/4122/0x00000002
[13296.397486] INFO: lockdep is turned off.
[13296.397487] Modules linked in: rfcomm arc4 ecb md4 hmac nls_utf8 cifs 
dns_res
olver fscache bnep bluetooth nfc cpufreq_userspace rfkill 
cpufreq_conservative c
pufreq_powersave cpufreq_stats binfmt_misc uinput max6650 fuse 
parport_pc ppdev
lp parport snd_hda_codec_hdmi ir_sharp_decoder ir_mce_kbd_decoder 
ir_lirc_codec
ir_nec_decoder ir_jvc_decoder ir_sanyo_decoder ir_xmp_decoder lirc_dev 
ir_rc6_de
coder ir_rc5_decoder ir_sony_decoder fc0012 dvb_usb_rtl28xxu rtl2830 
rtl2832 i2c
_mux dvb_usb_v2 dvb_core snd_hda_codec_realtek snd_hda_codec_generic 
snd_hda_int
el snd_hda_controller rc_core snd_hda_codec radeon snd_hwdep snd_pcm_oss 
kvm_amd
  snd_mixer_oss kvm snd_pcm ttm snd_timer snd drm_kms_helper sp5100_tco 
psmouse d
rm i2c_piix4 pcspkr k10temp soundcore wmi evdev i2c_algo_bit serio_raw 
acpi_cpuf
req processor
[13296.397526]  asus_atk0110 button thermal_sys ext4 mbcache crc16 jbd2 
sg sr_mo
d sd_mod cdrom ata_generic uas usb_storage ohci_pci pata_atiixp ahci 
libahci ohc
i_hcd libata ehci_pci ehci_hcd scsi_mod r8169 mii usbcore usb_common
[13296.397540] irq event stamp: 296885540
[13296.397542] hardirqs last  enabled at (296885539): 
[<ffffffff81136039>] free_
hot_cold_page+0x159/0x210
[13296.397544] hardirqs last disabled at (296885540): 
[<ffffffff810e22d5>] res_c
ounter_uncharge_until+0x35/0xe0
[13296.397547] softirqs last  enabled at (296870676): 
[<ffffffff8104f81e>] __do_
softirq+0x22e/0x3b0
[13296.397549] softirqs last disabled at (296870671): 
[<ffffffff8104fb45>] irq_e
xit+0xb5/0xc0
[13296.397552] Preemption disabled at:[<ffffffff810e2313>] 
res_counter_uncharge_
until+0x73/0xe0

[13296.397556] CPU: 1 PID: 4122 Comm: iceweasel Tainted: G      D 
  3.18.0-
rc4 #1335
[13296.397558] Hardware name: System manufacturer System Product 
Name/M3A78 PRO,
  BIOS 1701    01/27/2011
[13296.397559]  0000000000000001 ffff8800c3fdb788 ffffffff815173cc 
0000000000000
000
[13296.397562]  ffff8800c3fd6990 ffff8800c3fdb7a8 ffffffff8106e0bd 
0000000000000
001
[13296.397564]  ffff88022d453cc0 ffff8800c3fdb818 ffffffff81518ac6 
ffff8800c3fd6
990
[13296.397567] Call Trace:
[13296.397570]  [<ffffffff815173cc>] dump_stack+0x4f/0x7c
[13296.397573]  [<ffffffff8106e0bd>] __schedule_bug+0x6d/0xd0
[13296.397575]  [<ffffffff81518ac6>] __schedule+0x6a6/0x970
[13296.397578]  [<ffffffff81518db4>] schedule+0x24/0x60
[13296.397580]  [<ffffffff8104dabd>] do_exit+0x91d/0xb40
[13296.397582]  [<ffffffff815166e7>] ? printk+0x48/0x4a
[13296.397586]  [<ffffffff810a277d>] ? kmsg_dump+0xfd/0x110
[13296.397588]  [<ffffffff810a269d>] ? kmsg_dump+0x1d/0x110
[13296.397591]  [<ffffffff81006691>] oops_end+0xa1/0xf0
[13296.397593]  [<ffffffff81006ad3>] die+0x53/0x80
[13296.397596]  [<ffffffff81003277>] do_general_protection+0xe7/0x170
[13296.397598]  [<ffffffff81520347>] ? native_iret+0x7/0x7
[13296.397601]  [<ffffffff815214e8>] general_protection+0x28/0x30
[13296.397603]  [<ffffffff8108f1f0>] ? __lock_acquire+0x140/0x1d20
[13296.397606]  [<ffffffff81135944>] ? free_pcppages_bulk+0x34/0x490
[13296.397609]  [<ffffffff8109161b>] lock_acquire+0xbb/0x160
[13296.397611]  [<ffffffff810e2313>] ? res_counter_uncharge_until+0x73/0xe0
[13296.397614]  [<ffffffff8151e6c6>] _raw_spin_lock+0x36/0x50
[13296.397616]  [<ffffffff810e2313>] ? res_counter_uncharge_until+0x73/0xe0
[13296.397618]  [<ffffffff810e2313>] res_counter_uncharge_until+0x73/0xe0
[13296.397621]  [<ffffffff810e238e>] res_counter_uncharge+0xe/0x10
[13296.397623]  [<ffffffff8118c2ef>] uncharge_batch+0x17f/0x1a0
[13296.397625]  [<ffffffff8118c4a0>] uncharge_list+0x190/0x1b0
[13296.397628]  [<ffffffff81190a7e>] mem_cgroup_uncharge_list+0x1e/0x30
[13296.397630]  [<ffffffff8113d9d8>] release_pages+0x1d8/0x260
[13296.397633]  [<ffffffff8117039d>] free_pages_and_swap_cache+0x8d/0xa0
[13296.397635]  [<ffffffff811592cc>] tlb_flush_mmu_free+0x2c/0x50
[13296.397638]  [<ffffffff81159e2d>] tlb_finish_mmu+0x4d/0x50
[13296.397640]  [<ffffffff81165193>] exit_mmap+0xc3/0x170
[13296.397642]  [<ffffffff8104787d>] mmput+0x4d/0x110
[13296.397644]  [<ffffffff8104d4d3>] do_exit+0x333/0xb40
[13296.397647]  [<ffffffff8104dd6f>] do_group_exit+0x4f/0xe0
[13296.397649]  [<ffffffff8104de0f>] SyS_exit_group+0xf/0x10
[13296.397651]  [<ffffffff8151f6a9>] system_call_fastpath+0x12/0x17
[13365.120265] SendRcvNoRsp flags 64 rc 0

Arthur.
