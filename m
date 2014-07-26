Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbaGZEuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 00:50:25 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:43005 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaGZEuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 00:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140726044225.GA7629@croesus.uplinklabs.net>
References: <CAKbGBLjYWrooGZjZS_MaDe9kxacoaL9dHJM1oDe7_a-vQuhsJw@mail.gmail.com>
	<20140721132937.GF12921@htj.dyndns.org>
	<CAKbGBLj4c_bbN-GV-DTJWT7+iKLBauxvvu0uDvtQQOLMmx4N5A@mail.gmail.com>
	<20140723175021.GA14128@amazon.com>
	<53D0B07B.5040600@ahsoftware.de>
	<20140726044225.GA7629@croesus.uplinklabs.net>
Date: Fri, 25 Jul 2014 21:50:20 -0700
Message-ID: <CAKbGBLjFigJPevPbvYoAfq5RQZdFA5iOqxu_6b0rEEwwpukzsg@mail.gmail.com>
Subject: Re: general protection fault on 3.15.6
From: Steven Noonan <steven@uplinklabs.net>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 9:42 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Thu, Jul 24, 2014 at 12:06 AM, Alexander Holler <holler@ahsoftware.de> wrote:
>> Am 23.07.2014 19:50, schrieb Steven Noonan:
>>
>>> (Oops, LKML doesn't like rich text, resending. Was trying to avoid
>>> GMail's bad line wrapping. Going to use Mutt instead.)
>>>
>>> I'm starting to wonder if it's bad RAM or something. Just got a couple of
>>> worrying warnings on boot from the same system (after it spontaneously
>>> rebooted, with nothing revealing in the previous boot's logs).
>
> So the spontaneous reboot was apparently caused by a power outage. All
> my boxes had identical uptimes of less than a couple days when I checked
> them.
>
>>
>>
>> I once had such too and since then I'm using memtest=3 in my kernel command
>> line on x86* machines. Depending on the amount of RAM it will slow down boot
>> by a few seconds, but if you don't care if your machine comes up in 5 or 10
>> seconds, it is a no-brainer.
>>
>
> However, I got another general protection fault. This time it happened
> when doing 'find' on an NFS mount point. Tried booting with 'memtest=16'
> to see if that would catch anything, but it passed without finding any
> bad regions. I'm running memtest86 right now to be a bit more thorough
> and ensure it's not just bad hardware, but so far it's not found
> anything (1 full pass done so far).
>
> Here's the latest backtraces. I only managed to copy/paste this before
> the system hung and I had to reboot it, but there should be a more
> complete kernel log in the systemd journal that I can grab once it's
> done with memtest86.
>
> [212326.408380] general protection fault: 0000 [#1] SMP
> [212326.409183] Modules linked in: rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs lockd fscache sunrpc macvlan xt_nat sit tunnel4 ip_tunnel sch_sfq ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT xt_limit 8021q nf_conntrack_ipv4 nf_defrag_ipv4 xt_LOG xt_tcpudp bridge ip6t_rt nf_conntrack_ipv6 stp llc nf_defrag_ipv6 xt_conntrack nf_conntrack iptable_filter ip6table_filter ip6_tables ip_tables x_tables it87 hwmon_vid nls_cp437 vfat fat x86_pkg_temp_thermal iTCO_wdt intel_powerclamp raid1 iTCO_vendor_support raid0 coretemp crct10dif_pclmul md_mod snd_hda_codec_hdmi crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul snd_hda_codec_realtek glue_helper ablk_helper cryptd snd_hda_codec_generic snd_hda_intel snd_hda_controller microcode i2c_i801 r8169 snd_hda_codec
> [212326.411879]  snd_hwdep mii snd_pcm snd_timer thermal fan snd acpi_cpufreq battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
> [212326.414577] CPU: 5 PID: 30360 Comm: find Tainted: P        WC O  3.15.6-1-ec2 #1
> [212326.415457] Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
> [212326.416352] task: ffff8801275bbb00 ti: ffff88030f80c000 task.ti: ffff88030f80c000
> [212326.417261] RIP: 0010:[<ffffffff811ad226>]  [<ffffffff811ad226>] __kmalloc_track_caller+0x86/0x260
> [212326.418194] RSP: 0018:ffff88030f80fb78  EFLAGS: 00010282
> [212326.419130] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000000035ee
> [212326.420081] RDX: 00000000000035ed RSI: 0000000000000000 RDI: 0000000000000000
> [212326.421021] RBP: ffff88030f80fbb0 R08: 00000000000173c0 R09: ffff8801eb6ae160
> [212326.421958] R10: ffff88040e803e00 R11: 0000000000000004 R12: ff0074726f707262
> [212326.422887] R13: 00000000000000d0 R14: 0000000000000004 R15: ffff88040e803e00
> [212326.423808] FS:  00007f3b98919700(0000) GS:ffff88041f340000(0000) knlGS:0000000000000000
> [212326.424752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [212326.425698] CR2: 0000000000ef0010 CR3: 00000003ffd3c000 CR4: 00000000001407e0
> [212326.426659] Stack:
> [212326.427620]  ffff88040e803e00 ffffffffa0211d75 0000000000000004 ffff8803607f0558
> [212326.428609]  0000000000000009 ffff8801eb6ae000 ffff8801eb6ae140 ffff88030f80fbd0
> [212326.429630]  ffffffff8116fb60 ffff88030f80fd40 ffff88030f80fe58 ffff88030f80fcc8
> [212326.430640] Call Trace:
> [212326.431651]  [<ffffffffa0211d75>] ? nfs_permission+0x405/0xfb0 [nfs]
> [212326.432681]  [<ffffffff8116fb60>] kmemdup+0x20/0x50
> [212326.433717]  [<ffffffffa0211d75>] nfs_permission+0x405/0xfb0 [nfs]
> [212326.434760]  [<ffffffffa0212277>] nfs_permission+0x907/0xfb0 [nfs]
> [212326.435810]  [<ffffffffa0212350>] ? nfs_permission+0x9e0/0xfb0 [nfs]
> [212326.436863]  [<ffffffffa0212372>] nfs_permission+0xa02/0xfb0 [nfs]
> [212326.437924]  [<ffffffff8115300e>] do_read_cache_page+0x7e/0x1a0
> [212326.438990]  [<ffffffff8115314c>] read_cache_page+0x1c/0x20
> [212326.440078]  [<ffffffffa021252b>] nfs_permission+0xbbb/0xfb0 [nfs]
> [212326.441159]  [<ffffffffa0787690>] ? nfs4_proc_secinfo+0x63a0/0x63a0 [nfsv4]
> [212326.442251]  [<ffffffff811d9f16>] iterate_dir+0xa6/0xe0
> [212326.443347]  [<ffffffff811da359>] SyS_getdents+0x89/0x100
> [212326.444448]  [<ffffffff811da020>] ? fillonedir+0xd0/0xd0
> [212326.445552]  [<ffffffff810ff216>] ? __audit_syscall_exit+0x236/0x2e0
> [212326.446666]  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
> [212326.447783] Code: 25 88 dd 00 00 49 8b 50 08 4d 8b 20 4d 85 e4 0f 84 50 01 00 00 49 83 78 10 00 0f 84 45 01 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 bb 49 63
> [212326.449050] RIP  [<ffffffff811ad226>] __kmalloc_track_caller+0x86/0x260
> [212326.450277]  RSP <ffff88030f80fb78>
> [212326.451513] general protection fault: 0000 [#2] SMP
> [212326.452755] Modules linked in: rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs lockd fscache sunrpc macvlan xt_nat sit tunnel4 ip_tunnel sch_sfq ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT xt_limit 8021q nf_conntrack_ipv4 nf_defrag_ipv4 xt_LOG xt_tcpudp bridge ip6t_rt nf_conntrack_ipv6 stp llc nf_defrag_ipv6 xt_conntrack nf_conntrack iptable_filter ip6table_filter ip6_tables ip_tables x_tables it87 hwmon_vid nls_cp437 vfat fat x86_pkg_temp_thermal iTCO_wdt intel_powerclamp raid1 iTCO_vendor_support raid0 coretemp crct10dif_pclmul md_mod snd_hda_codec_hdmi crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul snd_hda_codec_realtek glue_helper ablk_helper cryptd snd_hda_codec_generic snd_hda_intel snd_hda_controller microcode i2c_i801 r8169 snd_hda_codec
> [212326.457001]  snd_hwdep mii snd_pcm snd_timer thermal fan snd acpi_cpufreq battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
> [212326.461578] CPU: 5 PID: 30360 Comm: find Tainted: P        WC O  3.15.6-1-ec2 #1
> [212326.463122] Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
> [212326.464678] task: ffff8801275bbb00 ti: ffff88030f80c000 task.ti: ffff88030f80c000
> [212326.466248] RIP: 0010:[<ffffffff811aa26a>]  [<ffffffff811aa26a>] __kmalloc+0x8a/0x280
> [212326.467835] RSP: 0018:ffff88030f80f608  EFLAGS: 00010082
> [212326.469445] RAX: 0000000000000000 RBX: ffff88030faa9000 RCX: 00000000000035ee
> [212326.471051] RDX: 00000000000035ed RSI: 0000000000000000 RDI: 0000000000000000
> [212326.472666] RBP: ffff88030f80f640 R08: 00000000000173c0 R09: ffff88040e803e00
> [212326.474272] R10: ffffffff8132d81f R11: 0000000000000000 R12: ff0074726f707262
> [212326.475873] R13: 0000000000008020 R14: 0000000000000008 R15: ffff88040e803e00
> [212326.477454] FS:  00007f3b98919700(0000) GS:ffff88041f340000(0000) knlGS:0000000000000000
> [212326.479005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [212326.480565] CR2: 0000000000ef0010 CR3: 00000003ffd3c000 CR4: 00000000001407e0
> [212326.482143] Stack:
> [212326.483720]  0000000000000000 ffff88030f80f718 ffff88030faa9000 ffff88030f80f6a8
> [212326.485307]  ffff88040e8634b0 0000000000000000 0000000000000001 ffff88030f80f690
> [212326.486899]  ffffffff8132d81f ffffffffa00ccc59 ffffffffa00ccc59 0000000000000021
> [212326.488505] Call Trace:
> [212326.490099]  [<ffffffff8132d81f>] acpi_ns_internalize_name+0x68/0xad
> [212326.491703]  [<ffffffff8132db3a>] acpi_ns_get_node+0x79/0xe2
> [212326.493299]  [<ffffffff81336827>] ? acpi_ut_allocate_object_desc_dbg+0x3e/0x6a
> [212326.494937]  [<ffffffff813368c2>] ? acpi_ut_create_internal_object_dbg+0x23/0x87
> [212326.496542]  [<ffffffff8132b531>] acpi_ns_evaluate+0x51/0x24d
> [212326.498143]  [<ffffffff8132b531>] ? acpi_ns_evaluate+0x51/0x24d
> [212326.499733]  [<ffffffff8132e319>] acpi_evaluate_object+0x189/0x285
> [212326.501312]  [<ffffffff8130f0bc>] acpi_execute_simple_method+0x43/0x45
> [212326.502856]  [<ffffffffa00cb63e>] acpi_video_register+0x3c1/0x593 [video]
> [212326.504361]  [<ffffffffa00cb789>] acpi_video_register+0x50c/0x593 [video]
> [212326.505815]  [<ffffffff81302599>] fb_notifier_callback+0x109/0x130
> [212326.507231]  [<ffffffff8150fc7d>] notifier_call_chain+0x4d/0x70
> [212326.508607]  [<ffffffff8108f137>] __blocking_notifier_call_chain+0x47/0x60
> [212326.509965]  [<ffffffff8108f166>] blocking_notifier_call_chain+0x16/0x20
> [212326.511285]  [<ffffffff81302f5b>] fb_notifier_call_chain+0x1b/0x20
> [212326.512602]  [<ffffffff8130350e>] fb_blank+0x9e/0xc0
> [212326.513908]  [<ffffffff812fa6e1>] fbcon_blank+0x1f1/0x300
> [212326.515203]  [<ffffffff810c1044>] ? wake_up_klogd+0x34/0x50
> [212326.516490]  [<ffffffff810c1259>] ? console_unlock+0x1f9/0x3d0
> [212326.517770]  [<ffffffff81073c8b>] ? lock_timer_base.isra.26+0x2b/0x50
> [212326.519050]  [<ffffffff8107219f>] ? internal_add_timer+0x2f/0x70
> [212326.520324]  [<ffffffff81074415>] ? mod_timer+0x105/0x200
> [212326.521593]  [<ffffffff8136d04a>] do_unblank_screen+0xba/0x1f0
> [212326.522860]  [<ffffffff8136d190>] unblank_screen+0x10/0x20
> [212326.524118]  [<ffffffff812ae8b9>] bust_spinlocks+0x19/0x40
> [212326.525366]  [<ffffffff8150cb18>] oops_end+0x38/0x150
> [212326.526605]  [<ffffffff8101639b>] die+0x4b/0x70
> [212326.527834]  [<ffffffff8150c5fa>] do_general_protection+0xca/0x150
> [212326.529061]  [<ffffffff8150bf68>] general_protection+0x28/0x30
> [212326.530282]  [<ffffffff811ad226>] ? __kmalloc_track_caller+0x86/0x260
> [212326.531504]  [<ffffffff811ad351>] ? __kmalloc_track_caller+0x1b1/0x260
> [212326.532713]  [<ffffffffa0211d75>] ? nfs_permission+0x405/0xfb0 [nfs]
> [212326.533917]  [<ffffffff8116fb60>] kmemdup+0x20/0x50
> [212326.535117]  [<ffffffffa0211d75>] nfs_permission+0x405/0xfb0 [nfs]
> [212326.536320]  [<ffffffffa0212277>] nfs_permission+0x907/0xfb0 [nfs]
> [212326.537522]  [<ffffffffa0212350>] ? nfs_permission+0x9e0/0xfb0 [nfs]
> [212326.538726]  [<ffffffffa0212372>] nfs_permission+0xa02/0xfb0 [nfs]
> [212326.539928]  [<ffffffff8115300e>] do_read_cache_page+0x7e/0x1a0
> [212326.541128]  [<ffffffff8115314c>] read_cache_page+0x1c/0x20
> [212326.542329]  [<ffffffffa021252b>] nfs_permission+0xbbb/0xfb0 [nfs]
> [212326.543531]  [<ffffffffa0787690>] ? nfs4_proc_secinfo+0x63a0/0x63a0 [nfsv4]
> [212326.544735]  [<ffffffff811d9f16>] iterate_dir+0xa6/0xe0
> [212326.545935]  [<ffffffff811da359>] SyS_getdents+0x89/0x100
> [212326.547137]  [<ffffffff811da020>] ? fillonedir+0xd0/0xd0
> [212326.548336]  [<ffffffff810ff216>] ? __audit_syscall_exit+0x236/0x2e0
> [212326.549557]  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
> [212326.550758] Code: 25 88 dd 00 00 49 8b 50 08 4d 8b 20 4d 85 e4 0f 84 64 01 00 00 49 83 78 10 00 0f 84 59 01 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 bb 49 63
> [212326.552107] RIP  [<ffffffff811aa26a>] __kmalloc+0x8a/0x280
> [212326.553311]  RSP <ffff88030f80f608>
> [212326.554506] ---[ end trace 71a1e508f45dbd1e ]---
>
> I'm thinking I should start turning on some of the more invasive debug
> kernel configs to get to the bottom of this...

Stopped memtest86 mid-way through the 2nd pass so I could get the full
kernel log:

http://pastebin.com/raw.php?i=qkZ0LNCr

NMI watchdog kicked in while it was hung.
