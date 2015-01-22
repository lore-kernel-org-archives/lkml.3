Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbbAVGBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:01:13 -0500
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:50403
	"EHLO know-smtprelay-omc-3.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbAVGBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:01:01 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 01:01:00 EST
X-Originating-IP: [82.33.62.46]
X-Spam: 0
X-Authority: v=2.1 cv=N7qnFgNB c=1 sm=1 tr=0 a=43HWeVr0mW5rhQls5iFsjw==:117
 a=43HWeVr0mW5rhQls5iFsjw==:17 a=5IRWAbXhAAAA:8 a=M1kyBYkWWGkA:10
 a=kj9zAlcOel0A:10 a=YNv0rlydsVwA:10 a=aIdt2sKeyWLdsn2Bib4A:9 a=CjuIK1q_8ugA:10
Date: Thu, 22 Jan 2015 05:52:42 +0000
From: James Dingwall <james@dingwall.me.uk>
To: linux-kernel@vger.kernel.org
Subject: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
Message-ID: <20150122055242.GA11089@dingwall.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since 3.18.2 I am getting the oops below during boot whilst running as a dom0 under xen 4.4.1 / 4.5.0.  Is this a known issue or worth bisecting to identify the exact commit which causes this?

Thanks,
James

[  173.735541] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  173.735789] IP: [<ffffffff8134e7c2>] misc_deregister+0x50/0xa5
[  173.735958] PGD 71480067 PUD 71bc6067 PMD 0 
[  173.736077] Oops: 0002 [#1] SMP 
[  173.736152] Modules linked in: it87 hwmon_vid autofs4 nfsd xen_pciback xen_gntalloc bridge stp llc ipv6 rbd ceph libceph openvswitch geneve vxlan ip6_udp_tunnel udp_tunnel tun tmem 
xen_acpi_processor xen_gntdev xen_blkback xen_netback i915 fbcon bitblit softcursor font tileblit video drm_kms_helper snd_hda_codec_realtek snd_hda_codec_generic coretemp microcode(-) drm lpc_ich 
i2c_i801 mfd_core snd_hda_intel firewire_ohci r8169 mii ata_generic evdev e1000e snd_hda_controller rtc_cmos i2c_algo_bit snd_hda_codec i2c_core cfbfillrect cfbimgblt cfbcopyarea backlight fb 
snd_pcm processor fbdev snd_hwdep snd_timer button intel_agp intel_gtt snd parport_pc parport thermal_sys dm_zero dm_thin_pool dm_persistent_data dm_bio_prison xts lrw gf128mul glue_helper 
ablk_helper cryptd aes_x86_64 iscsi_tcp libiscsi_tcp
[  173.738197]  libiscsi scsi_transport_iscsi tg3 ptp pps_core libphy hwmon e1000 fuse btrfs ext4 jbd2 linear raid0 dm_raid raid1 raid10 dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash 
dm_log firewire_core hid_sunplus hid_samsung hid_pl hid_petalynx hid_gyration usbhid ohci_hcd uhci_hcd usb_storage ehci_pci ehci_hcd megaraid_sas 3w_xxxx qla1280 aic7xxx scsi_transport_spi sr_mod 
cdrom sg ahci libahci sata_nv sata_sil pata_amd libata
[  173.738197] CPU: 1 PID: 5381 Comm: rmmod Tainted: G        W      3.18.2 #118
[  173.738197] Hardware name: Gigabyte Technology Co., Ltd. G33M-S2/G33M-S2, BIOS F7K 07/31/2009
[  173.738197] task: ffff880073dca940 ti: ffff880071434000 task.ti: ffff880071434000
[  173.738197] RIP: e030:[<ffffffff8134e7c2>]  [<ffffffff8134e7c2>] misc_deregister+0x50/0xa5
[  173.738197] RSP: e02b:ffff880071437eb8  EFLAGS: 00010247
[  173.738197] RAX: 0000000000000000 RBX: ffffffffa0511e20 RCX: 00000028739a828b
[  173.738197] RDX: 0000000000000000 RSI: ffff880073dc0604 RDI: ffff880078866840
[  173.738197] RBP: ffff880071437ec8 R08: 00000000bfff1433 R09: ffff88007f68a0b0
[  173.738197] R10: 0000000000007ff0 R11: 0000000000000000 R12: 00000000ffffff87
[  173.738197] R13: 0000000000000800 R14: 00000000019c11c0 R15: 00000000019c1010
[  173.738197] FS:  00007f7ac2926700(0000) GS:ffff88007f680000(0000) knlGS:0000000000000000
[  173.738197] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  173.738197] CR2: 0000000000000008 CR3: 0000000072886000 CR4: 0000000000002660
[  173.738197] Stack:
[  173.738197]  ffff88007f6113c0 0000000000000000 ffff880071437ee8 ffffffffa0511253
[  173.738197]  0000000000000000 ffffffffa0511f30 ffff880071437f78 ffffffff81093fdf
[  173.738197]  00000000c22d6d00 ffffffffa0511f30 ffff880000000800 ffff880071437efc
[  173.738197] Call Trace:
[  173.738197]  [<ffffffffa0511253>] microcode_exit+0x20/0xb1 [microcode]
[  173.738197]  [<ffffffff81093fdf>] SyS_delete_module+0x118/0x1a6
[  173.738197]  [<ffffffff8100af73>] ? do_notify_resume+0x6a/0x78
[  173.738197]  [<ffffffff814caae9>] system_call_fastpath+0x12/0x17
[  173.738197] Code: f1 07 64 81 e8 3a 70 cf ff b8 ea ff ff ff eb 6b 48 c7 c7 20 fa 71 81 e8 1a a4 17 00 48 8b 43 20 48 8b 53 18 48 8b 3d e6 73 57 00 <48> 89 42 08 48 89 10 48 b8 00 01 10 00 00 00 
ad de 8b 33 48 89 
[  173.738197] RIP  [<ffffffff8134e7c2>] misc_deregister+0x50/0xa5
[  173.738197]  RSP <ffff880071437eb8>
[  173.738197] CR2: 0000000000000008
[  173.784081] ---[ end trace 0ab648576ba0af94 ]---


Previously in 3.18.1:
[  176.855832] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
[  176.855844] microcode: CPU0 update to revision 0x60f failed
[  176.856107] microcode: CPU1 sig=0x10676, pf=0x1, revision=0x60c
[  176.856115] microcode: CPU1 update to revision 0x60f failed
[  176.861597] microcode: Microcode Update Driver: v2.00 removed.


Same 3.18.2 kernel on bare metal (different system but identical hardware):
[   46.002857] microcode: Microcode Update Driver: v2.00 removed.
