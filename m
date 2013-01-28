Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3A1OJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:09:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab3A1OJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:09:05 -0500
Message-ID: <5106867F.80309@redhat.com>
Date: Mon, 28 Jan 2013 15:09:03 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: iwl3945 prints warning
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm getting tthis warning printed with current 3.8-rc  kernel
My hw is Lenovo  T61.


[    5.920284] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
[    5.976605] systemd[1]: Started NFS file locking service..
[    5.982624] NFSD: starting 90-second grace period (net ffffffff81aa08c0)
[    5.987930] ------------[ cut here ]------------
[    5.988026] WARNING: at lib/dma-debug.c:933 check_unmap+0x4ae/0x9a0()
[    5.988111] Hardware name: 6464CTO
[    5.988194] iwl3945 0000:03:00.0: DMA-API: device driver failed to check 
map error[device address=0x00000000bb7a7800] [size=4096 bytes] [mapped as page]
[    5.988286] Modules linked in:
[    5.988411]  rfcomm bnep btusb bluetooth snd_hda_codec_analog iTCO_wdt 
iTCO_vendor_support arc4 hid_generic iwl3945 iwlegacy mac80211 snd_hda_intel 
snd_hda_codec coretemp snd_seq psmouse i2c_i801 serio_raw microcode i2c_core 
snd_seq_device r852 sm_common cfg80211 nand snd_pcm nand_ecc r592 nand_ids mtd 
memstick lpc_ich mfd_core e1000e thinkpad_acpi snd_page_alloc ehci_pci 
snd_timer ehci_hcd nvram wmi snd soundcore evdev binfmt_misc usbhid hid loop 
vhost_net tun kvm_intel kvm nfsd exportfs auth_rpcgss nfs_acl lockd sunrpc 
dm_mod pcmcia sr_mod cdrom sdhci_pci sdhci mmc_core yenta_socket uhci_hcd 
usbcore usb_common video backlight autofs4
[    5.992114] Pid: 635, comm: libvirtd Not tainted 3.8.0-rc5-00006-g0e5e62f #119
[    5.992177] Call Trace:
[    5.992177]  <IRQ>  [<ffffffff8103fcd0>] warn_slowpath_common+0x70/0xa0
[    5.992177]  [<ffffffff8103fd4c>] warn_slowpath_fmt+0x4c/0x50
[    5.992177]  [<ffffffff8132e18e>] check_unmap+0x4ae/0x9a0
[    5.992177]  [<ffffffff8132e6df>] debug_dma_unmap_page+0x5f/0x70
[    5.992177]  [<ffffffff81329b50>] ? unmap_single+0x20/0x30
[    5.992177]  [<ffffffffa05584b2>] il3945_irq_tasklet+0x392/0x710 [iwl3945]
[    5.992177]  [<ffffffff810498e8>] tasklet_action+0x98/0x220
[    5.992177]  [<ffffffff8104a10f>] __do_softirq+0xdf/0x3f0
[    5.992177]  [<ffffffff8156adcc>] call_softirq+0x1c/0x30
[    5.992177]  [<ffffffff810045f5>] do_softirq+0x65/0xa0
[    5.992177]  [<ffffffff8104a5d5>] irq_exit+0xc5/0xd0
[    5.992177]  [<ffffffff8156b486>] do_IRQ+0x56/0xc0
[    5.992177]  [<ffffffff81564ffc>] ? __do_page_fault+0x20c/0x5b0
[    5.992177]  [<ffffffff81561def>] common_interrupt+0x6f/0x6f
[    5.992177]  <EOI>  [<ffffffff810b1a9e>] ? lock_release+0xae/0x300
[    5.992177]  [<ffffffff81073aef>] up_read+0x1f/0x40
[    5.992177]  [<ffffffff81564ffc>] __do_page_fault+0x20c/0x5b0
[    5.992177]  [<ffffffff810af0b5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[    5.992177]  [<ffffffff815622e3>] ? error_sti+0x5/0x6
[    5.992177]  [<ffffffff8131c1cd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    5.992177]  [<ffffffff815653ae>] do_page_fault+0xe/0x10
[    5.992177]  [<ffffffff815620e2>] page_fault+0x22/0x30
[    5.992177] ---[ end trace c0d06cdbbf41cb39 ]---
[    5.992177] Mapped at:
[    5.992177]  [<ffffffff8132eab1>] debug_dma_map_page+0x91/0x140
[    5.992177]  [<ffffffffa05555fa>] il3945_rx_allocate+0xaa/0x270 [iwl3945]
[    5.992177]  [<ffffffffa0558efb>] il3945_rx_replenish+0x1b/0x50 [iwl3945]
[    5.992177]  [<ffffffffa055b4b1>] il3945_hw_nic_init+0x1a1/0x5e0 [iwl3945]
[    5.992177]  [<ffffffffa0556790>] __il3945_up+0xc0/0x2d0 [iwl3945]


Zdenek
