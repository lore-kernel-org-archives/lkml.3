Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaHHLZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:25:00 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:33248 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHLY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:24:58 -0400
Message-ID: <53E4B386.7050103@xs4all.nl>
Date: Fri, 08 Aug 2014 13:24:54 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
CC: linux-media@vger.kernel.org
Subject: Re: 3.15.8 USB issue with uvc cam
References: <53DCE329.4030106@xs4all.nl> <2923628.39nbDsJU79@avalon> <53E4472C.4040509@xs4all.nl>
In-Reply-To: <53E4472C.4040509@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The Logitech C615 works OK if moved away from a USB3 port into a
non-USB3 port.
So it appears a USB3 issue.
Is 'xhci_hcd 0000:02:00.0: ERROR: unexpected command
completion code 0x11' a possible root cause?

My board has:

# lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Root Complex
00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 15h (Models
10h-1fh) I/O Memory Management Unit
00:01.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] Trinity [Radeon HD 7660D]
00:01.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Trinity
HDMI Audio Controller
00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Root Port
00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Root Port
00:10.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI
Controller (rev 03)
00:10.1 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI
Controller (rev 03)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA
Controller [AHCI mode] (rev 40)
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
Controller (rev 11)
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI
Controller (rev 11)
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
Controller (rev 11)
00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI
Controller (rev 11)
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller
(rev 14)
00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD] FCH Azalia
Controller (rev 01)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge
(rev 11)
00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] FCH PCI Bridge
(rev 40)
00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
Controller (rev 11)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 0
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models 10h-1fh) Processor Function 5
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
02:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host
Controller (rev 01)
03:06.0 Serial controller: MosChip Semiconductor Technology Ltd. PCI
9835 Multi-I/O Controller (rev 01)


And the Etron EJ168 is the only USB3 provider here?
How can we fix this issue?

Kind regards,
Udo


On 2014-08-08 05:42, Udo van den Heuvel wrote:
> Hello,
> 
> I get WARNINGs when trying to use a Logitech C615 cam.
> See attachment for full dmesg of errors but excerpt below:
> 
> [80346.835015] xhci_hcd 0000:02:00.0: ERROR: unexpected command
> completion code 0x11.
> [80346.835027] usb 6-2: Not enough bandwidth for altsetting 11
> [80346.835137] ------------[ cut here ]------------
> [80346.835155] WARNING: CPU: 3 PID: 20594 at
> drivers/media/v4l2-core/videobuf2-core.c:2011
> __vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
> [80346.835158] Modules linked in: uvcvideo cdc_acm bnep bluetooth fuse
> edac_core cpufreq_userspace ipt_REJECT nf_conntrack_netbios_ns
> nf_conntrack_broadcast iptable_filter ip6t_REJECT ipt_MASQUERADE
> xt_tcpudp nf_conntrack_ipv6 iptable_nat nf_defrag_ipv6 nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack ip_tables
> ip6table_filter ip6_tables x_tables eeprom it87 hwmon_vid ext2
> snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi ppdev pwc
> videobuf2_vmalloc videobuf2_memops kvm_amd kvm v4l2_common
> videobuf2_core snd_hda_codec_realtek snd_hda_codec_generic videodev
> snd_hda_intel snd_hda_controller cp210x snd_hda_codec usbserial snd_seq
> snd_seq_device microcode snd_pcm parport_serial parport_pc parport
> snd_timer k10temp snd evdev i2c_piix4 button acpi_cpufreq nfsd
> auth_rpcgss oid_registry
> [80346.835218]  nfs_acl lockd sunrpc binfmt_misc autofs4 hid_generic
> usbhid ohci_pci ehci_pci ehci_hcd ohci_hcd radeon sr_mod cdrom fbcon
> bitblit cfbfillrect softcursor cfbimgblt cfbcopyarea font i2c_algo_bit
> xhci_hcd backlight drm_kms_helper ttm drm fb fbdev
> [80346.835250] CPU: 3 PID: 20594 Comm: skype Tainted: G        W
> 3.15.8 #6
> [80346.835254] Hardware name: Gigabyte Technology Co., Ltd. To be filled
> by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
> [80346.835257]  0000000000000000 0000000079d580f4 ffffffff814f2373
> 0000000000000000
> [80346.835262]  ffffffff81069fe1 0000000000000000 ffff88040ec532e8
> 0000000000000000
> [80346.835267]  ffff88040ec530d8 ffff8803f0c46f00 ffffffffa041d832
> ffff88040ec530d8
> [80346.835272] Call Trace:
> [80346.835283]  [<ffffffff814f2373>] ? dump_stack+0x4a/0x75
> [80346.835289]  [<ffffffff81069fe1>] ? warn_slowpath_common+0x81/0xb0
> [80346.835299]  [<ffffffffa041d832>] ? __vb2_queue_cancel+0x102/0x170
> [videobuf2_core]
> [80346.835307]  [<ffffffffa041f53d>] ? vb2_internal_streamoff+0x1d/0x50
> [videobuf2_core]
> [80346.835314]  [<ffffffffa06140d5>] ? uvc_queue_enable+0x75/0xb0 [uvcvideo]
> [80346.835321]  [<ffffffffa0619091>] ? uvc_video_enable+0x141/0x1a0
> [uvcvideo]
> [80346.835327]  [<ffffffffa0615e1f>] ? uvc_v4l2_do_ioctl+0xd6f/0x1580
> [uvcvideo]
> [80346.835339]  [<ffffffffa0448bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
> [80346.835345]  [<ffffffffa06150b0>] ?
> uvc_v4l2_set_streamparm.isra.12+0x1c0/0x1c0 [uvcvideo]
> [80346.835352]  [<ffffffff81091d9f>] ? preempt_count_add+0x3f/0x90
> [80346.835356]  [<ffffffff814f73ee>] ? _raw_spin_lock+0xe/0x30
> [80346.835360]  [<ffffffff814f748d>] ? _raw_spin_unlock+0xd/0x30
> [80346.835367]  [<ffffffff8110f77e>] ? __pte_alloc+0xce/0x170
> [80346.835376]  [<ffffffffa04447df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
> [80346.835386]  [<ffffffffa04527b6>] ? do_video_ioctl+0x246/0x1330
> [videodev]
> [80346.835392]  [<ffffffff8111999a>] ? mmap_region+0x15a/0x5a0
> [80346.835402]  [<ffffffffa0453922>] ? v4l2_compat_ioctl32+0x82/0xb8
> [videodev]
> [80346.835408]  [<ffffffff81186182>] ? compat_SyS_ioctl+0x132/0x1120
> [80346.835414]  [<ffffffff81105833>] ? vm_mmap_pgoff+0xe3/0x120
> [80346.835421]  [<ffffffff814f97c5>] ? cstar_dispatch+0x7/0x1a
> [80346.835424] ---[ end trace 44e3d272b6c91a71 ]---
> [80346.835427] ------------[ cut here ]------------
> 
> 
> What is wrong here?
> 
> Kind regards,
> Udo
> 
> 

