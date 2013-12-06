Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3LFLpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:45:22 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59517 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3LFLpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:45:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131206074455.GB21029@glanzmann.de>
References: <20131206074455.GB21029@glanzmann.de>
Date: Fri, 6 Dec 2013 06:45:16 -0500
X-Google-Sender-Auth: z3ncBhOsF803-U7Bo47XsTEgQWY
Message-ID: <CAKb7Uvht8=ydSgCe-mKpoR3LRvf1KJw2_CAV_0zeh2t4nt9nww@mail.gmail.com>
Subject: Re: Regression: drm/nouveau/clk: implement power state and engine
 clock control in core (7c856522069755ab9d163a24ac332cd3cb35fe30) breaks
 GeForce 9400 on Intel Mac Mini Model November 2010 model
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Thomas Glanzmann <thomas@glanzmann.de>, Ben Skeggs <bskeggs@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 2:44 AM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> [    7.569394] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
> [    7.569460] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
> [    7.569530] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
> [    7.571151] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
> [    7.633082] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
> [    7.633155] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
> [    7.633468] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
> [    7.633533] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
> [    7.654309] nouveau  [     PMC][0000:02:00.0] MSI interrupts enabled
> [    7.654417] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
> [    7.654481] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
> [    7.654546] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 0 tags
> [    7.687282] nouveau  [  PTHERM][0000:02:00.0] FAN control: none / external
> [    7.687366] nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
> [    7.687429] nouveau  [  PTHERM][0000:02:00.0] internal sensor: yes
> [    7.687500] nouveau  [     CLK][0000:02:00.0] 03: core 150 MHz shader 300 MHz
> [    7.687575] nouveau  [     CLK][0000:02:00.0] 05: core 150 MHz shader 300 MHz
> [    7.687648] nouveau  [     CLK][0000:02:00.0] 0e: core 350 MHz shader 800 MHz
> [    7.687721] nouveau  [     CLK][0000:02:00.0] 0f: core 450 MHz shader 1100 MHz
> [    7.687806] nouveau E[     CLK][0000:02:00.0] 17 freq unknown
> [    7.687867] nouveau E[     CLK][0000:02:00.0] init failed, -22

http://lists.freedesktop.org/archives/nouveau/2013-December/015304.html

> [    7.687932] nouveau E[     DRM] failed to create 0x80000080, -22
> [    7.692470] BUG: unable to handle kernel NULL pointer dereference at 000000000000004c
> [    7.692640] IP: [<ffffffffa057f34f>] drm_unplug_minor+0xd/0x31 [drm]
> [    7.692757] PGD b7c93067 PUD 0
> [    7.692901] Oops: 0000 [#1] SMP
> [    7.693049] Modules linked in: nouveau(+) video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop hid_generic usbhid hid snd_hda_codec_realtek arc4 b43 rng_core bcma mac80211 cfg80211 rfkill snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer evdev coretemp snd ssb kvm_intel pcmcia pcmcia_core applesmc ehci_pci ohci_pci ohci_hcd kvm ehci_hcd input_polldev mmc_core i2c_nforce2 pcspkr shpchp soundcore usbcore i2c_core usb_common acpi_cpufreq processor button thermal_sys ext4 crc16 mbcache jbd2 btrfs crc32c libcrc32c xor raid6_pq dm_mod sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ata_generic ahci libahci microcode firewire_ohci libata firewire_core crc_itu_t scsi_mod
> [    7.696174] CPU: 1 PID: 1131 Comm: modprobe Not tainted 3.12.0-rc3+ #40
> [    7.696174] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
> [    7.696174] task: ffff8800b7c33080 ti: ffff8800b7c8e000 task.ti: ffff8800b7c8e000
> [    7.696174] RIP: 0010:[<ffffffffa057f34f>]  [<ffffffffa057f34f>] drm_unplug_minor+0xd/0x31 [drm]
> [    7.696174] RSP: 0018:ffff8800b7c8fb38  EFLAGS: 00010282
> [    7.696174] RAX: 0000000000000000 RBX: ffff8800b8e2a440 RCX: ffffffffa059f737
> [    7.696174] RDX: ffffffffa0594610 RSI: ffffffffa059f753 RDI: ffff8800b8e2a440
> [    7.696174] RBP: ffff88013acc8000 R08: 0000000000000040 R09: ffff8800b7c8fa78
> [    7.696174] R10: ffff8800b7c8fa78 R11: ffff8800b7c8fa78 R12: ffffffffa0669360
> [    7.696174] R13: 00000000ffffffea R14: ffff88013acc8098 R15: ffffffffa06692f0
> [    7.696174] FS:  0000000000000000(0000) GS:ffff88013fd00000(0063) knlGS:00000000f754db40
> [    7.696174] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [    7.696174] CR2: 000000000000004c CR3: 00000000b7c38000 CR4: 00000000000407e0
> [    7.696174] Stack:
> [    7.696174]  ffff8800b8e2a440 ffffffffa057f464 ffff8800b7dff800 ffffffffa057f47f
> [    7.696174]  ffff8800b7dff800 ffffffffa05813aa ffff88000000000d 0000000000000000
> [    7.696174]  ffff88013acc8000 ffff88013acc8000 ffff88013acb1b20 ffffffffa06692f0
> [    7.696174] Call Trace:
> [    7.696174]  [<ffffffffa057f464>] ? drm_put_minor+0x35/0x40 [drm]
> [    7.696174]  [<ffffffffa057f47f>] ? drm_dev_free+0x10/0x66 [drm]
> [    7.696174]  [<ffffffffa05813aa>] ? drm_get_pci_dev+0x10a/0x124 [drm]
> [    7.696174]  [<ffffffffa06185a2>] ? nouveau_drm_probe+0x1d1/0x1fb [nouveau]

http://lists.freedesktop.org/archives/dri-devel/2013-December/050098.html
