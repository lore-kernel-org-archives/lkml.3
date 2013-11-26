Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab3KZXTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:19:16 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52787 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3KZXTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:19:14 -0500
MIME-Version: 1.0
In-Reply-To: <201311262303.26996.s.L-H@gmx.de>
References: <201311262303.26996.s.L-H@gmx.de>
Date: Tue, 26 Nov 2013 18:19:13 -0500
X-Google-Sender-Auth: 6o22VZ7_qj6FhN4A4yIpBERw2LU
Message-ID: <CAKb7UvinEmz4YFoes2w5JJp-sJ_tsDeAWj-Aa5Yw56m2=j3xHw@mail.gmail.com>
Subject: Re: nouveau/ NV11: 3.12 freezes if X.org is started headless
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 6:03 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> v3.11 is fine, with and without monitor attached.
> v3.12 is fine as long as X.org isn't started (but may fail to reboot
>       cleanly). If a monitor is connected I don't observe any problems,
>       it freezes without a monitor connected.
> v3.13-rc1-95-gb975dc3 appears not to freeze without a monitor anymore
>       (I didn't confirm that it's fine with a monitor attached), but I
>       end up with the following Oops (this is before X.org is started).
>
> [drm] hdmi device  not found 1 0 1
> nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x011000a1
> nouveau  [  DEVICE][0000:01:00.0] Chipset: NV11 (NV11)
> nouveau  [  DEVICE][0000:01:00.0] Family : NV11
> nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
> nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
> nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
> nouveau  [   VBIOS][0000:01:00.0] BMP version 5.11
> nouveau  [   VBIOS][0000:01:00.0] version 03.11.00.18.00
> nouveau W[   VBIOS][0000:01:00.0] DCB contains no useful data
> nouveau W[   VBIOS][0000:01:00.0] DCB contains no useful data
> nouveau W[   VBIOS][0000:01:00.0] DCB contains no useful data
> nouveau W[   VBIOS][0000:01:00.0] DCB contains no useful data
> nouveau W[  PTIMER][0000:01:00.0] unknown input clock freq
> nouveau  [     PFB][0000:01:00.0] RAM type: SDRAM
> nouveau  [     PFB][0000:01:00.0] RAM size: 32 MiB
> nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
> BUG: unable to handle kernel NULL pointer dereference at   (null)
> IP: [<e0ecaa4e>] _nouveau_clock_init+0x2a/0xaf [nouveau]
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: snd arc4 psmouse serio_raw pcspkr i2c_viapro soundcore nouveau(+) video rtl8180 mxm_wmi eeprom_93cx6 wmi mac80211 i2c_algo_bit drm_kms_helper ttm cfg80211 parport_pc processor button parport drm rfkill via_agp ext4 crc16 mbcache jbd2 dm_mod sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ata_generic pata_acpi 8139too 8139cp mii uhci_hcd ehci_pci ehci_hcd floppy pata_via libata usbcore usb_common scsi_mod
> CPU: 0 PID: 360 Comm: modprobe Not tainted 3.13.0-rc1-00095-gb975dc3 #42
> Hardware name:    /GA-7VT600, BIOS F5 08/16/2004
> task: dee1e880 ti: de33c000 task.ti: de33c000
> EIP: 0060:[<e0ecaa4e>] EFLAGS: 00010246 CPU: 0
> EIP is at _nouveau_clock_init+0x2a/0xaf [nouveau]
> EAX: de19c94c EBX: de19c900 ECX: 00000000 EDX: e0f3689c
> ESI: 00000000 EDI: de19c9c8 EBP: de19c944 ESP: de33db90
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> CR0: 8005003b CR2: 00000000 CR3: 1e078000 CR4: 00000790
> Stack:
>  00000013 e0ebe0da de29d600 00000005 de19c900 00000000 de29d600 00000013
>  e0ebe17d de19c900 00000005 e0f2e8ca 00000001 00000012 00000012 e0ee7f01
>  00000000 00000012 de2caa38 0000000c 000000c0 de33dc00 00000000 00000000
> Call Trace:
>  [<e0ebe0da>] ? nouveau_object_inc+0x30/0x15a [nouveau]
>  [<e0ebe17d>] ? nouveau_object_inc+0xd3/0x15a [nouveau]
>  [<e0ee7f01>] ? nouveau_devobj_ctor+0x58c/0x5cd [nouveau]
>  [<e0ebdc3b>] ? nouveau_object_ctor+0x31/0xb7 [nouveau]
>  [<e0ebe352>] ? nouveau_object_new+0x14e/0x1e8 [nouveau]
>  [<e0ebdd28>] ? nouveau_object_ref+0x67/0x98 [nouveau]
>  [<e0f0d12b>] ? nouveau_drm_load+0x1ea/0x724 [nouveau]
>  [<e0803e3c>] ? drm_dev_register+0xd6/0x16c [drm]
>  [<e0805311>] ? drm_get_pci_dev+0x8c/0x110 [drm]
>  [<c1189d00>] ? pci_read_config_byte+0x14/0x17
>  [<e0f0d7e1>] ? nouveau_drm_probe+0x17c/0x19e [nouveau]
>  [<c118da65>] ? pci_device_probe+0x50/0x9d
>  [<c1117aeb>] ? sysfs_create_link+0x24/0x2d
>  [<c120a714>] ? driver_probe_device+0x8c/0x191
>  [<c116897f>] ? kobject_add_internal+0x105/0x1ae
>  [<c118d5c0>] ? pci_match_id+0x18/0x36
>  [<c120a885>] ? __driver_attach+0x44/0x5f
>  [<c120947d>] ? bus_for_each_dev+0x50/0x5a
>  [<c120a379>] ? driver_attach+0x14/0x16
>  [<c120a841>] ? __device_attach+0x28/0x28
>  [<c120a0e1>] ? bus_add_driver+0xd9/0x190
>  [<c120ad08>] ? driver_register+0x77/0xab
>  [<e0a84000>] ? 0xe0a83fff
>  [<e0a84000>] ? 0xe0a83fff
>  [<c100043f>] ? do_one_initcall+0x8f/0x12c
>  [<c1094f2d>] ? jump_label_module_notify+0x139/0x15a
>  [<c1048c79>] ? notifier_call_chain+0x29/0x42
>  [<c1048e72>] ? __blocking_notifier_call_chain+0x45/0x51
>  [<c1076dcb>] ? load_module+0x13e3/0x18e1
>  [<c107733b>] ? SyS_init_module+0x72/0x88
>  [<c12ed88d>] ? sysenter_do_call+0x12/0x28
> Code: d2 55 b9 21 00 00 00 57 56 53 89 c3 8d 68 44 83 ec 10 8b 70 40 89 ef 31 c0 f3 ab 8d 43 4c 89 43 4c 89 43 50 c6 83 c4 00 00 00 ff <8b> 16 83 fa 19 74 39 89 d8 ff 93 e8 00 00 00 89 c7 8b 06 85 ff
> EIP: [<e0ecaa4e>] _nouveau_clock_init+0x2a/0xaf [nouveau] SS:ESP 0068:de33db90
> CR2: 0000000000000000
> ---[ end trace 0f90bffd76312ecf ]---

The oops in 3.13-rc1 should be fixed by applying the equivalent of
http://cgit.freedesktop.org/~darktama/nouveau/commit/?id=0397aaaa009092427dc60aea8b3c21c00526d8ba
. Also note that libdrm had a bug when compiled with gcc-4.8 for
pre-nv50 cards, not sure if the fixes have made it to Debian/unstable,
but you need libdrm-2.4.48+ (or compile it with gcc-4.7/clang).
Lastly, another thing to try if you're getting random hangs is booting
with nouveau.agpmode=0 (and if that helps, seeing if =1 or =2 still
work ok). If that helps, it can be added to the quirks list.
