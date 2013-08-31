Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3HaPyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 11:54:14 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61963 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3HaPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 11:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <kvsve9$5ou$1@ger.gmane.org>
References: <kvsve9$5ou$1@ger.gmane.org>
Date: Sat, 31 Aug 2013 11:54:12 -0400
X-Google-Sender-Auth: cRZLrzTgdwBUrfJamghzeq9qto8
Message-ID: <CAKb7UvgnSjLpowUV3=0rozDQ6HENnY_cfrjQTCf2UMBH0uPvsQ@mail.gmail.com>
Subject: Re: Crashes on 3.0.11-rc7: nouveau?
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: ael <law_ence.dev@ntlworld.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 10:43 AM, ael <law_ence.dev@ntlworld.com> wrote:
> Aug 31 11:31:53 conquest2 kernel: ------------[ cut here ]------------
> Aug 31 11:31:53 conquest2 kernel: WARNING: CPU: 0 PID: 4566 at
> drivers/gpu/drm/nouveau/nouveau_bo.c:151 nouveau_bo_del_ttm+0x62/0x70
> [nouveau]()
> Aug 31 11:31:53 conquest2 kernel: Modules linked in: snd_hrtimer
> cpufreq_userspace cpufreq_stats cpufreq_powersave lp hwmon_vid nfsd
> auth_rpcgss oid_registry exportfs nfs_acl nfs lockd sunrpc ipv6 analog
> joydev dm_crypt dm_mod nouveau snd_intel8x0 snd_ac97_codec ac97_bus video
> snd_pcm_oss snd_mixer_oss backlight snd_pcm mxm_wmi snd_page_alloc
> snd_seq_dummy snd_mpu401 snd_mpu401_uart snd_seq_oss wmi snd_seq_midi ttm
> snd_rawmidi snd_seq_midi_event snd_seq fbcon bitblit snd_seq_device
> softcursor font snd_timer drm_kms_helper snd drm sg k8temp forcedeth ns558
> sr_mod cdrom hwmon psmouse serio_raw pcspkr gameport i2c_algo_bit evdev
> ohci_pci ohci_hcd ehci_pci ehci_hcd soundcore parport_pc parport i2c_nforce2
> i2c_core floppy thermal processor button unix
> Aug 31 11:31:53 conquest2 kernel: CPU: 0 PID: 4566 Comm: Xorg Not tainted
> 3.11.0-rc4_c2+ #99
> Aug 31 11:31:53 conquest2 kernel: Hardware name: System manufacturer System
> name/A8N-SLI DELUXE, BIOS ASUS A8N-SLI DELUXE ACPI BIOS Revision 1805
> 09/29/2006
> Aug 31 11:31:53 conquest2 kernel: 0000000000000009 ffff88007cad3c48
> ffffffff81384a50 ffff88007cad3c80
> Aug 31 11:31:53 conquest2 kernel: ffffffff8105d2ab ffff880036c10c00
> 000000000000a480 ffff88007c908158
> Aug 31 11:31:53 conquest2 kernel: ffff880036c10c00 ffff880036c10c00
> ffff88007cad3c90 ffffffff8105d2f5
> Aug 31 11:31:53 conquest2 kernel: Call Trace:
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff81384a50>] dump_stack+0x19/0x1b
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff8105d2ab>]
> warn_slowpath_common+0x7b/0xb0
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff8105d2f5>]
> warn_slowpath_null+0x15/0x20
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa03567d2>]
> nouveau_bo_del_ttm+0x62/0x70 [nouveau]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa0238668>]
> ttm_bo_release_list+0x98/0xe0 [ttm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa023924d>]
> ttm_bo_release+0x16d/0x200 [ttm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa0239309>]
> ttm_bo_unref+0x29/0x30 [ttm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa03591e6>]
> nouveau_gem_object_del+0x46/0x60 [nouveau]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa0133394>]
> drm_gem_object_free+0x24/0x30 [drm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa0133750>]
> drm_gem_object_release_handle+0xb0/0xc0 [drm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff811e4c8f>]
> idr_for_each+0xaf/0x100
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa01336a0>] ?
> drm_gem_handle_create+0xe0/0xe0 [drm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff81385f2d>] ? mutex_lock+0xd/0x20
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa0133c1b>]
> drm_gem_release+0x1b/0x30 [drm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffffa0132499>]
> drm_release+0x589/0x600 [drm]
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff810eafcf>] __fput+0xaf/0x230
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff810eb189>] ____fput+0x9/0x10
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff810735c5>]
> task_work_run+0x95/0xc0
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff8105ebbf>] do_exit+0x5df/0x890
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff81069de3>] ?
> restore_altstack+0x13/0x30
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff8105ef60>]
> do_group_exit+0x30/0x70
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff8105efb2>]
> SyS_exit_group+0x12/0x20
> Aug 31 11:31:53 conquest2 kernel: [<ffffffff81388590>]
> system_call_fastpath+0x16/0x1bAug 31 11:31:53 conquest2 kernel: ---[ end
> trace 76bc7ab59b9ea669 ]---

This is not a crash, but a warning. Also one that should have been
taken care of in 3.11-rc7 -- are you absolutely sure you're running
that kernel and not some 3.11-rc6+ one? This is the commit that should
have fixed it (and worked great for me):

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=78ae0ad403daf11cf63da86923d2b5dbeda3af8f

Based on what you pasted, you were actually running "3.11.0-rc4_c2+"
which probably didn't contain the above commit.

>
> =============================================================================
>
>
> Aug 31 12:54:56 conquest2 kernel: general protection fault: 0000 [#1]
> Aug 31 12:54:56 conquest2 kernel: Modules linked in: rpcsec_gss_krb5 nfsv4
> snd_hrtimer cpufreq_userspace cpufreq_stats cpufreq_powersave lp hwmon_vid
> nfsd auth_
> rpcgss oid_registry exportfs nfs_acl nfs lockd sunrpc ipv6 analog joydev
> dm_crypt dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
> snd_mixer_oss snd_pcm
> nouveau video backlight fbcon snd_page_alloc mxm_wmi snd_seq_dummy
> snd_mpu401 snd_mpu401_uart bitblit psmouse snd_seq_oss softcursor wmi
> snd_seq_midi ttm font s
> nd_rawmidi drm_kms_helper snd_seq_midi_event sg snd_seq drm i2c_algo_bit
> sr_mod k8temp cdrom hwmon forcedeth serio_raw ohci_pci snd_seq_device pcspkr
> evdev ohci
> _hcd snd_timer snd ns558 gameport ehci_pci ehci_hcd i2c_nforce2 i2c_core
> parport_pc parport floppy soundcore thermal processor button unix
> Aug 31 12:54:56 conquest2 kernel: CPU: 0 PID: 5555 Comm: ifconfig Not
> tainted 3.11.0-rc7_c2+ #100
> Aug 31 12:54:56 conquest2 kernel: Hardware name: System manufacturer System
> name/A8N-SLI DELUXE, BIOS ASUS A8N-SLI DELUXE ACPI BIOS Revision 1805
> 09/29/2006
> Aug 31 12:54:56 conquest2 kernel: task: ffff88007d3f4150 ti:
> ffff88000156e000 task.ti: ffff88000156e000
> Aug 31 12:54:56 conquest2 kernel: RIP: 0010:[<ffffffff813846b3>]
> [<ffffffff813846b3>] cache_flusharray+0x15/0x77
> Aug 31 12:54:56 conquest2 kernel: RSP: 0018:ffff88000156fc10  EFLAGS:
> 00010046
> Aug 31 12:54:56 conquest2 kernel: RAX: 400000000000082c RBX:
> 0000000001228d30 RCX: 4000000000000064
> Aug 31 12:54:56 conquest2 kernel: RDX: ffffea000089db98 RSI:
> 0000000001228d30 RDI: ffff8800500aa950
> Aug 31 12:54:56 conquest2 kernel: RBP: ffff88000156fc20 R08:
> 0000000000000001 R09: 0000000000000000
> Aug 31 12:54:56 conquest2 kernel: R10: ffffc90000018434 R11:
> ffffc90000018000 R12: 0000000000000000
> Aug 31 12:54:56 conquest2 kernel: R13: ffff880027635800 R14:
> 0000000000000000 R15: ffff88007c85c000
> Aug 31 12:54:56 conquest2 kernel: FS:  00007f6d57661700(0000)
> GS:ffffffff814df000(0000) knlGS:0000000000000000
> Aug 31 12:54:56 conquest2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 000000008005003b
> Aug 31 12:54:56 conquest2 kernel: CR2: 0000000001228d34 CR3:
> 0000000005621000 CR4: 00000000000007f0
> Aug 31 12:54:56 conquest2 kernel: Stack:
> Aug 31 12:54:56 conquest2 kernel: 0000000001228d30 0000000000000286
> ffff88000156fc48 ffffffff810e09de
> Aug 31 12:54:56 conquest2 kernel: ffff8800276358c0 ffff88007c85c660
> ffff880036632080 ffff88000156fc58
> Aug 31 12:54:56 conquest2 kernel: ffffffff81300a7c ffff88000156fc80
> ffffffff81302b22 ffff880036632080
> Aug 31 12:54:56 conquest2 kernel: Call Trace:
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810e09de>] kfree+0xbe/0xd0
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81300a7c>]
> skb_free_head+0x6c/0x80
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302b22>]
> skb_release_data+0xe2/0xf0
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302b4f>]
> skb_release_all+0x1f/0x30
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302b6d>] __kfree_skb+0xd/0x90
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81302c08>] consume_skb+0x18/0x40
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812b4dab>]
> skge_rx_clean+0x4b/0xa0
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812b8a45>] skge_down+0x3f5/0x520
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130a955>]
> __dev_close_many+0x75/0xc0
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130a9c8>] __dev_close+0x28/0x40
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130e6cc>]
> __dev_change_flags+0x9c/0x180
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8130e863>]
> dev_change_flags+0x23/0x70
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8135e0fb>]
> devinet_ioctl+0x5ab/0x660
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff8135eeb4>] inet_ioctl+0x74/0x90
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812f8b4c>]
> sock_do_ioctl.constprop.46+0x1c/0x50
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff812f8df8>] sock_ioctl+0x58/0x2b0
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810f973c>]
> do_vfs_ioctl+0x7c/0x4e0
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810f39fd>] ?
> final_putname+0x1d/0x40
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff810f9c31>] SyS_ioctl+0x91/0xb0
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81053339>] ?
> do_page_fault+0x9/0x10
> Aug 31 12:54:56 conquest2 kernel: [<ffffffff81388bd0>]
> system_call_fastpath+0x16/0x1b
> Aug 31 12:54:56 conquest2 kernel: Code: 8b 52 30 48 8b 0a 48 89 c2 48 83 ca
> 01 5d 80 e1 40 48 0f 45 c2 c3 55 48 89 e5 41 54 53 48 8b 47 78 48 89 f3 44
> 8b 66 08 48 8b 00 <48> 8b 40 40 48 85 c0 74 2a 8b 10 8b 48 04 29 d1 74 21 41
> 39 cc
> Aug 31 12:54:56 conquest2 kernel: RSP <ffff88000156fc10>
> Aug 31 12:54:56 conquest2 kernel: ---[ end trace 41fcd322c82e6632 ]---
>
> =======================================================================
>
> Kernel: 3.11.0-rc7
>
> CPU:
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 31
> model name      : AMD Athlon(tm) 64 Processor 3000+
> stepping        : 0
> microcode       : 0x41
> cpu MHz         : 1809.156
>
> Video/GPU:
>
> VGA compatible controller: NVIDIA Corporation NV43 [GeForce 6600] (rev a2)
> (prog-if 00 [VGA controller])
>         Subsystem: ASUSTeK Computer Inc. Device 819a
>         Flags: bus master, fast devsel, latency 0, IRQ 18
>         Memory at d0000000 (32-bit, non-prefetchable) [size=64M]
>         Memory at c0000000 (64-bit, prefetchable) [size=256M]
>         Memory at d4000000 (64-bit, non-prefetchable) [size=16M]
>         Expansion ROM at d5000000 [disabled] [size=128K]
>         Capabilities: [60] Power Management version 2
>         Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [78] Express Endpoint, MSI 00
>         Capabilities: [100] Virtual Channel
>         Capabilities: [128] Power Budgeting <?>
>         Kernel driver in use: nouveau
>
> ==============================================================
>
> Config attached (gz).
>
> ael
>
>
