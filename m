Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3F1MHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:07:45 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:38400 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3F1MHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:07:43 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>, "Dan Williams" <djbw@fb.com>,
        =?iso-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: 3.9.8: cannot boot with iommu=on using 6gbps highpoint sata card
Date: Fri, 28 Jun 2013 08:00:58 -0400
Message-ID: <002a01ce73f7$27281e20$75785a60$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac5z9xJkYoEFPTQLRlWNY/XxpjVgvw==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This bug I reported in November 2012:
http://www.kernelhub.org/?p=2&msg=170797
http://home.comcast.net/~jpiszcz/20121128/highpoint.jpg

Some discussion on the patches:
http://www.kernelhub.org/?p=2&msg=172597
http://www.kernelhub.org/?p=2&msg=171846
http://www.kernelhub.org/?p=2&msg=172346

My current choices:
1. Stick with old kernel (3.7.x) + patch, which works w/IOMMU=on and use
6gbps SATA board.
2. Put drive back on motherboard SATA2 and the machine will boot properly
with any kernel.
3. I would prefer to use 6gbps if possible.

There is still a problem with 3.9.8: (below)

Rebooting to new kernel (3.9.8) from the 3.7.x kernel w/ patch provided
earlier:

Jun 28 07:48:54 p34 [ 5809.227191] EXT4-fs (sdc2): re-mounted. Opts: (null) 
Jun 28 07:48:56 p34 [ 5811.283882] sd 7:0:0:0: [sdc] Synchronizing SCSI
cache 
Jun 28 07:48:56 p34 [ 5811.284402] sd 0:0:1:0: [sdb] Synchronizing SCSI
cache 
Jun 28 07:48:56 p34 [ 5811.284522] sd 0:0:0:0: [sda] Synchronizing SCSI
cache 
Jun 28 07:48:56 p34 [ 5811.284911] 3w-sas: Shutting down host 0. 
Jun 28 07:49:03 p34 [ 5818.107989] 3w-sas: Shutdown complete. 
Jun 28 07:50:50 p34 [    6.127384] usb 6-2.1: new full-speed USB device
number 4 using uhci_hcd 
Jun 28 07:50:50 p34 [    6.248468] usb 6-2.1: New USB device found,
idVendor=413c, idProduct=2002 
Jun 28 07:50:50 p34 [    6.249011] usb 6-2.1: New USB device strings: Mfr=1,
Product=2, SerialNumber=0 
Jun 28 07:50:50 p34 [    6.250654] usb 6-2.1: Product: Dell USB Keyboard Hub

Jun 28 07:50:50 p34 [    6.252476] usb 6-2.1: Manufacturer: Dell 
Jun 28 07:50:50 p34 [    6.264087] input: Dell Dell USB Keyboard Hub as
/devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.0/input/input5 
Jun 28 07:50:50 p34 [    6.265041] hid-generic 0003:413C:2002.0004:
input,hidraw3: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] on
usb-0000:00:1d.0-2.1/input0 
Jun 28 07:50:50 p34 [    6.274732] input: Dell Dell USB Keyboard Hub as
/devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.1/6-2.1:1.1/input/input6 
Jun 28 07:50:50 p34 [    6.275752] hid-generic 0003:413C:2002.0005:
input,hidraw4: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on
usb-0000:00:1d.0-2.1/input1 
Jun 28 07:50:50 p34 [    6.343561] usb 6-2.3: new low-speed USB device
number 5 using uhci_hcd 
Jun 28 07:50:50 p34 [    6.476670] usb 6-2.3: New USB device found,
idVendor=045e, idProduct=0040 
Jun 28 07:50:50 p34 [    6.477220] usb 6-2.3: New USB device strings: Mfr=1,
Product=3, SerialNumber=0 
Jun 28 07:50:50 p34 [    6.479064] usb 6-2.3: Product: Microsoft 3-Button
Mouse with IntelliEye(TM) 
Jun 28 07:50:50 p34 [    6.480944] usb 6-2.3: Manufacturer: Microsoft 
Jun 28 07:50:50 p34 [    6.500368] input: Microsoft Microsoft 3-Button Mouse
with IntelliEye(TM) as
/devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2.3/6-2.3:1.0/input/input7 
Jun 28 07:50:50 p34 [    6.501539] hid-generic 0003:045E:0040.0006:
input,hidraw5: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with
IntelliEye(TM)] on usb-0000:00:1d.0-2.3/input0 
Jun 28 07:50:52 p34 [    7.840750] ata14.00: qc timeout (cmd 0xa1) 
Jun 28 07:50:52 p34 [    7.848753] ata7.00: qc timeout (cmd 0xec) 
Jun 28 07:50:52 p34 [    7.849304] ata7.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Jun 28 07:50:52 p34 [    8.156029] ata7: SATA link up 6.0 Gbps (SStatus 133
SControl 300) 
Jun 28 07:50:52 p34 [    8.341165] ata14.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Jun 28 07:50:53 p34 [    9.146828] ata14: SATA link up 1.5 Gbps (SStatus 113
SControl 300) 
Jun 28 07:51:02 p34 [   18.164175] ata7.00: qc timeout (cmd 0xec) 
Jun 28 07:51:02 p34 [   18.164740] ata7.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Jun 28 07:51:02 p34 [   18.166487] ata7: limiting SATA link speed to 3.0
Gbps 
Jun 28 07:51:02 p34 [   18.473437] ata7: SATA link up 6.0 Gbps (SStatus 133
SControl 320) 
Jun 28 07:51:03 p34 [   19.154971] ata14.00: qc timeout (cmd 0xa1) 
Jun 28 07:51:04 p34 [   19.655389] ata14.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Jun 28 07:51:04 p34 [   19.656004] ata14: limiting SATA link speed to 1.5
Gbps 
Jun 28 07:51:04 p34 [   20.463046] ata14: SATA link up 1.5 Gbps (SStatus 113
SControl 310) 
Jun 28 07:51:32 p34 [   48.497977] ata7.00: qc timeout (cmd 0xec) 
Jun 28 07:51:32 p34 [   48.498547] ata7.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Jun 28 07:51:33 p34 [   48.805177] ata7: SATA link up 6.0 Gbps (SStatus 133
SControl 320) 
Jun 28 07:51:34 p34 [   50.487585] ata14.00: qc timeout (cmd 0xa1) 
Jun 28 07:51:35 p34 [   50.987948] ata14.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Jun 28 07:51:36 p34 [   51.793613] ata14: SATA link up 1.5 Gbps (SStatus 113
SControl 310) 
Jun 28 07:51:36 p34 [   52.294202] VFS: Cannot open root device "822" or
unknown-block(8,34): error -6 
Jun 28 07:51:36 p34 [   52.294770] Please append a correct "root=" boot
option; here are the available partitions: 
Jun 28 07:51:36 p34 [   52.296927] 0800      29296762880 sda 
Jun 28 07:51:36 p34  driver: sd 
Jun 28 07:51:36 p34 [   52.298832]   0801      29296760832 sda1
95a4bdc9-ee53-4f8d-8f59-c28a52ac2da3
Jun 28 07:51:36 p34  
Jun 28 07:51:36 p34 [   52.300841] 0810      29296762880 sdb 
Jun 28 07:51:36 p34  driver: sd 
Jun 28 07:51:36 p34 [   52.302851]   0811      29296760832 sdb1
d8879e67-9c5a-4672-bf82-38ba2f5229ab
Jun 28 07:51:36 p34  
Jun 28 07:51:36 p34 [   52.304897] Kernel panic - not syncing: VFS: Unable
to mount root fs on unknown-block(8,34) 
Jun 28 07:51:36 p34 [   52.306888] Pid: 1, comm: swapper/0 Not tainted 3.9.8
#1 
Jun 28 07:51:36 p34 [   52.308938] Call Trace: 
Jun 28 07:51:36 p34 [   52.310856]  [<ffffffff81750207>] panic+0xbd/0x1bf 
Jun 28 07:51:36 p34 [   52.312905]  [<ffffffff81abd28a>]
mount_block_root+0x1f9/0x297 
Jun 28 07:51:36 p34 [   52.314964]  [<ffffffff81abd37e>]
mount_root+0x56/0x59 
Jun 28 07:51:36 p34 [   52.317018]  [<ffffffff81abd4b1>]
prepare_namespace+0x130/0x15c 
Jun 28 07:51:36 p34 [   52.319071]  [<ffffffff81abcfb9>]
kernel_init_freeable+0x185/0x193 
Jun 28 07:51:36 p34 [   52.321091]  [<ffffffff81abc80b>] ?
do_early_param+0x8a/0x8a 
Jun 28 07:51:36 p34 [   52.323074]  [<ffffffff8174b920>] ?
rest_init+0x70/0x70 
Jun 28 07:51:36 p34 [   52.325025]  [<ffffffff8174b929>]
kernel_init+0x9/0xf0 
Jun 28 07:51:36 p34 [   52.326923]  [<ffffffff8175856c>]
ret_from_fork+0x7c/0xb0 
Jun 28 07:51:36 p34 [   52.328634]  [<ffffffff8174b920>] ?
rest_init+0x70/0x70 
Jun 28 07:51:36 p34 [   52.331133] drm_kms_helper: panic occurred, switching
back to text console 
Jun 28 07:51:36 p34 [   52.332358] ------------[ cut here ]------------ 
Jun 28 07:51:36 p34 [   52.336000] WARNING: at arch/x86/kernel/smp.c:123
native_smp_send_reschedule+0x53/0x60() 
Jun 28 07:51:36 p34 [   52.339181] Hardware name: X8DTH-i/6/iF/6F 
Jun 28 07:51:36 p34 [   52.342368] Pid: 1, comm: swapper/0 Not tainted 3.9.8
#1 
Jun 28 07:51:36 p34 [   52.345576] Call Trace: 
Jun 28 07:51:36 p34 [   52.348663]  <IRQ> 
Jun 28 07:51:36 p34  [<ffffffff810609e5>] warn_slowpath_common+0x75/0xb0 
Jun 28 07:51:36 p34 [   52.351784]  [<ffffffff81060b05>]
warn_slowpath_null+0x15/0x20 
Jun 28 07:51:36 p34 [   52.354883]  [<ffffffff81021253>]
native_smp_send_reschedule+0x53/0x60 
Jun 28 07:51:36 p34 [   52.357988]  [<ffffffff8108cac1>]
trigger_load_balance+0x1a1/0x230 
Jun 28 07:51:36 p34 [   52.361095]  [<ffffffff810859a4>]
scheduler_tick+0x104/0x140 
Jun 28 07:51:36 p34 [   52.364179]  [<ffffffff8106d482>]
update_process_times+0x62/0x80 
Jun 28 07:51:36 p34 [   52.367245]  [<ffffffff81097339>]
tick_sched_handle.isra.9+0x29/0x60 
Jun 28 07:51:36 p34 [   52.370318]  [<ffffffff81097494>]
tick_sched_timer+0x44/0x70 
Jun 28 07:51:36 p34 [   52.373368]  [<ffffffff8107f10a>]
__run_hrtimer.isra.31+0x4a/0xd0 
Jun 28 07:51:36 p34 [   52.376482]  [<ffffffff8107fa35>]
hrtimer_interrupt+0xe5/0x220 
Jun 28 07:51:36 p34 [   52.379521]  [<ffffffff81021bc4>]
smp_apic_timer_interrupt+0x64/0xa0 
Jun 28 07:51:36 p34 [   52.382568]  [<ffffffff8175928a>]
apic_timer_interrupt+0x6a/0x70 
Jun 28 07:51:36 p34 [   52.385620]  <EOI> 
Jun 28 07:51:36 p34  [<ffffffff810ee22c>] ? cache_grow+0x7c/0x2b0 
Jun 28 07:51:36 p34 [   52.388707]  [<ffffffff810ee79d>]
____cache_alloc_node+0x7d/0x150 
Jun 28 07:51:36 p34 [   52.391769]  [<ffffffff817512ce>]
alternate_node_alloc+0x65/0x6d 
Jun 28 07:51:36 p34 [   52.394820]  [<ffffffff810eed54>]
__kmalloc+0x154/0x180 
Jun 28 07:51:36 p34 [   52.397864]  [<ffffffff813e5467>]
drm_crtc_helper_set_config+0x127/0xb10 
Jun 28 07:51:36 p34 [   52.400911]  [<ffffffff81061ebc>] ?
console_unlock+0x1fc/0x3c0 
Jun 28 07:51:36 p34 [   52.403963]  [<ffffffff813f6b69>]
drm_mode_set_config_internal+0x29/0x60 
Jun 28 07:51:36 p34 [   52.406989]  [<ffffffff813e361f>]
drm_fb_helper_restore_fbdev_mode+0x4f/0x70 
Jun 28 07:51:36 p34 [   52.409972]  [<ffffffff813e3685>]
drm_fb_helper_force_kernel_mode+0x45/0x80 
Jun 28 07:51:36 p34 [   52.412906]  [<ffffffff813e3714>]
drm_fb_helper_panic+0x24/0x30 
Jun 28 07:51:36 p34 [   52.415784]  [<ffffffff81080efd>]
notifier_call_chain+0x4d/0x70 
Jun 28 07:51:36 p34 [   52.418619]  [<ffffffff8108100d>]
__atomic_notifier_call_chain+0xd/0x10 
Jun 28 07:51:36 p34 [   52.421453]  [<ffffffff81081021>]
atomic_notifier_call_chain+0x11/0x20 
Jun 28 07:51:36 p34 [   52.424283]  [<ffffffff8175022e>] panic+0xe4/0x1bf 
Jun 28 07:51:36 p34 [   52.427098]  [<ffffffff81abd28a>]
mount_block_root+0x1f9/0x297 
Jun 28 07:51:36 p34 [   52.429912]  [<ffffffff81abd37e>]
mount_root+0x56/0x59 
Jun 28 07:51:36 p34 [   52.432732]  [<ffffffff81abd4b1>]
prepare_namespace+0x130/0x15c 
Jun 28 07:51:36 p34 [   52.435421]  [<ffffffff81abcfb9>]
kernel_init_freeable+0x185/0x193 
Jun 28 07:51:36 p34 [   52.438047]  [<ffffffff81abc80b>] ?
do_early_param+0x8a/0x8a 
Jun 28 07:51:36 p34 [   52.440675]  [<ffffffff8174b920>] ?
rest_init+0x70/0x70 
Jun 28 07:51:36 p34 [   52.443292]  [<ffffffff8174b929>]
kernel_init+0x9/0xf0 
Jun 28 07:51:36 p34 [   52.445888]  [<ffffffff8175856c>]
ret_from_fork+0x7c/0xb0 
Jun 28 07:51:36 p34 [   52.448480]  [<ffffffff8174b920>] ?
rest_init+0x70/0x70 
Jun 28 07:51:36 p34 [   52.451055] ---[ end trace 97c8306a30953a9d ]---

Justin.

