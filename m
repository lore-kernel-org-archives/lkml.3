Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3BJLQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:16:40 -0500
Received: from smtp206.alice.it ([82.57.200.102]:48286 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab3BJLQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:16:37 -0500
Date: Sun, 10 Feb 2013 12:16:25 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: bskeggs@redhat.com
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Subject: Re: nouveau, linux3.8-rc5:  BUG: unable to handle kernel paging
 request at fffffffffffffff8
Message-Id: <20130210121625.219deeae511e4310286b9d8f@studenti.unina.it>
In-Reply-To: <1359200447.29660.0.camel@turiel>
References: <20130126115318.24f2e6aec77d046e6fef67ce@studenti.unina.it>
	<1359200447.29660.0.camel@turiel>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2013 21:40:47 +1000
Ben Skeggs <bskeggs@redhat.com> wrote:

> On Sat, 2013-01-26 at 11:53 +0100, Antonio Ospite wrote:
> > Hi,
> > 
> > I am experiencing a bug with nouveau with linux-3.8-rc5, my video
> > adapter is the one integrated on the MSI M3N78-VM motherboard (hence
> > x86_64):
> > 
> > 02:00.0 VGA compatible controller: NVIDIA Corporation C77 [GeForce 8200] (rev a2) (prog-if 00 [VGA controller])
> >         Subsystem: ASUSTeK Computer Inc. Device 82f2
> >         Flags: bus master, fast devsel, latency 0, IRQ 21
> >         Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
> >         Memory at f0000000 (64-bit, prefetchable) [size=128M]
> >         Memory at fa000000 (64-bit, prefetchable) [size=32M]
> >         I/O ports at ec00 [size=128]
> >         Expansion ROM at febe0000 [disabled] [size=128K]
> >         Capabilities: <access denied>
> >         Kernel driver in use: nouveau
> > 
> > The problem happens every time I use some 3D feature, for instance the
> > trace below is from after I started "blender":
> > 
> > 
> > [ 6163.299538] BUG: unable to handle kernel paging request at fffffffffffffff8
> > [ 6163.299600] IP: [<ffffffffa02cff32>] nouveau_mm_head+0x30/0x127 [nouveau]
>
> It's a known issue, and the fix will be in my next -fixes merge request.
> 
> Ben.

Hi Ben, the problem is still there in 3.8-rc7.

Regards,
   Antonio
 
> > [ 6163.299714] PGD 160e067 PUD 160f067 PMD 0 
> > [ 6163.299739] Oops: 0000 [#1] SMP 
> > [ 6163.299757] Modules linked in: hidp ebtable_nat ebtables cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace ipt_MASQUERADE xt_CHECKSUM bridge stp llc ppdev lp bnep rfcomm tun sit tunnel4 binfmt_misc uinput ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip6table_raw ip6table_mangle ip6t_REJECT xt_LOG nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6table_filter ip6_tables xt_tcpudp ipt_REJECT ipt_ULOG xt_limit xt_multiport xt_conntrack iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw ip_tables x_tables loop fuse snd_hda_codec_hdmi snd_hda_codec_via lm63 adm1021 snd_hda_intel snd_hda_codec snd_usb_audio snd_usbmidi_lib snd_hwdep lm90 snd_pcm_oss snd_mixer_oss f75375s snd_seq_midi snd_pcm snd_seq_midi_event snd_rawmidi snd_seq snd_page_alloc snd_seq_device adt7475 hwmon_vid snd_timer btusb snd nouveau bluetooth ttm drm_kms_help!
>  er!
> >   drm mx
> > m_wmi powernow_k8 i2c_algo_bit edac_mce_amd edac_core parport_pc shpchp kvm_amd soundcore rfkill crc16 kvm evdev pcspkr parport ehci_pci k8temp video asus_atk0110 wmi processor thermal_sys i2c_nforce2 i2c_core button ext3 mbcache jbd sg sr_mod cdrom usb_storage hid_generic usbhid hid sd_mod crc_t10dif dm_mod ahci libahci libata ohci_hcd ehci_hcd forcedeth scsi_mod usbcore usb_common floppy
> > [ 6163.300023] CPU 0 
> > [ 6163.300023] Pid: 3460, comm: Xorg Not tainted 3.8.0-rc5-ao2 #6 System manufacturer System Product Name/M3N78-VM
> > [ 6163.300023] RIP: 0010:[<ffffffffa02cff32>]  [<ffffffffa02cff32>] nouveau_mm_head+0x30/0x127 [nouveau]
> > [ 6163.300023] RSP: 0018:ffff8801167eb9c8  EFLAGS: 00010216
> > [ 6163.300023] RAX: 00000000ffffffff RBX: fffffffffffffff0 RCX: 000000000000006c
> > [ 6163.300023] RDX: 000000000000006c RSI: 0000000000000001 RDI: ffff8801167e6108
> > [ 6163.300023] RBP: ffff8800bb334d78 R08: 0000000000000000 R09: ffff8800bb334d78
> > [ 6163.300023] R10: 0000000000000360 R11: ffff8800bb334cc0 R12: 000000000000006c
> > [ 6163.300023] R13: ffff8801167e6001 R14: ffff8801167e6020 R15: ffff8801167eba90
> > [ 6163.300023] FS:  00007f23f04c2880(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
> > [ 6163.300023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 6163.300023] CR2: fffffffffffffff8 CR3: 00000001194d6000 CR4: 00000000000007f0
> > [ 6163.300023] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [ 6163.300023] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [ 6163.300023] Process Xorg (pid: 3460, threadinfo ffff8801167ea000, task ffff88011770a7c0)
> > [ 6163.300023] Stack:
> > [ 6163.300023]  00000000000080d0 ffffffff167e6020 0000000000000002 0000000000000360
> > [ 6163.300023]  0000000000000002 0000000000000010 ffff8801167e6000 ffff8801167e6020
> > [ 6163.300023]  ffff8801167eba90 ffffffffa02e19be ffff8801167ebb00 00000360ffffe000
> > [ 6163.300023] Call Trace:
> > [ 6163.300023]  [<ffffffffa02e19be>] ? nv50_fb_vram_new+0xc5/0x1f2 [nouveau]
> > [ 6163.300023]  [<ffffffffa0324e3a>] ? nouveau_vram_manager_new+0x62/0xa4 [nouveau]
> > [ 6163.300023]  [<ffffffffa029fc6a>] ? ttm_bo_mem_space+0x113/0x301 [ttm]
> > [ 6163.300023]  [<ffffffff81383c00>] ? _raw_write_lock_irqsave+0x19/0x2a
> > [ 6163.300023]  [<ffffffff8110b000>] ? create_object+0x1e9/0x299
> > [ 6163.300023]  [<ffffffffa029feef>] ? ttm_bo_move_buffer+0x97/0xdd [ttm]
> > [ 6163.300023]  [<ffffffffa029ffd4>] ? ttm_bo_validate+0x9f/0xdd [ttm]
> > [ 6163.300023]  [<ffffffffa02a0353>] ? ttm_bo_init+0x341/0x37d [ttm]
> > [ 6163.300023]  [<ffffffffa0326663>] ? nouveau_bo_new+0x239/0x25e [nouveau]
> > [ 6163.300023]  [<ffffffffa032629d>] ? nouveau_ttm_tt_unpopulate+0xa3/0xa3 [nouveau]
> > [ 6163.300023]  [<ffffffff811c796b>] ? idr_get_empty_slot+0x18a/0x292
> > [ 6163.300023]  [<ffffffffa0327d92>] ? nouveau_gem_new+0x53/0xf7 [nouveau]
> > [ 6163.300023]  [<ffffffffa0327ed5>] ? nouveau_gem_ioctl_new+0x9f/0x107 [nouveau]
> > [ 6163.300023]  [<ffffffffa02700ea>] ? drm_gem_flink_ioctl+0xc1/0xde [drm]
> > [ 6163.300023]  [<ffffffffa026e603>] ? drm_ioctl+0x28c/0x36a [drm]
> > [ 6163.300023]  [<ffffffffa0327e36>] ? nouveau_gem_new+0xf7/0xf7 [nouveau]
> > [ 6163.300023]  [<ffffffff8111949e>] ? vfs_ioctl+0x1e/0x31
> > [ 6163.300023]  [<ffffffff81119cd6>] ? do_vfs_ioctl+0x3ee/0x430
> > [ 6163.300023]  [<ffffffff8110cf1c>] ? vfs_read+0xac/0xf5
> > [ 6163.300023]  [<ffffffff81119d65>] ? sys_ioctl+0x4d/0x7c
> > [ 6163.300023]  [<ffffffff81388f29>] ? system_call_fastpath+0x16/0x1b
> > [ 6163.300023] Code: 44 89 c0 41 56 f7 d0 41 55 41 88 f5 41 54 41 89 d4 55 4c 89 cd 53 48 83 ec 18 48 8b 5f 10 89 44 24 0c 48 83 eb 10 e9 da 00 00 00 <48> 8b 43 08 44 8b 53 34 44 8b 7b 38 48 39 f8 45 89 d3 47 8d 0c 
> > [ 6163.300023] RIP  [<ffffffffa02cff32>] nouveau_mm_head+0x30/0x127 [nouveau]
> > [ 6163.300023]  RSP <ffff8801167eb9c8>
> > [ 6163.300023] CR2: fffffffffffffff8
> > [ 6163.300023] ---[ end trace b0239eaa41f9b476 ]---
> > [ 6165.326199] nouveau E[   PDISP][0000:02:00.0] chid 1 mthd 0x0080 data 0x00000000 0x000b5080
> > 
> > 
> > I had a similar issue in 3.7-rc cycle, here is a link to the discussion
> > https://lkml.org/lkml/2012/10/29/696 where David explained the cause,
> > I am not sure if this is the same scenario tho.
> > 

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
