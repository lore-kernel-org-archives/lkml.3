Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaCXRsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:48:55 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30315 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaCXRsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:48:52 -0400
X-IronPort-AV: E=Sophos;i="4.97,722,1389772800"; 
   d="scan'208";a="21022286"
Message-ID: <53306FF3.1090706@broadcom.com>
Date: Mon, 24 Mar 2014 18:48:35 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sabrina Dubroca <sd@queasysnail.net>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-gpio@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michael Buesch <m@bues.ch>,
        <b43-dev@lists.infradead.org>
Subject: Re: [bisected] NULL pointer dereference in acpi_gpiochip_add (on
 modprobe ssb)
References: <20140324154944.GB25669@kria>
In-Reply-To: <20140324154944.GB25669@kria>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Michael
+ b43-dev-list

On 03/24/14 16:49, Sabrina Dubroca wrote:
> Hi,
>
> With next-20140324, I get the BUG below when I modprobe ssb.
> I bisected it to aa92b6f689ac
> "gpio / ACPI: Allocate ACPI specific data directly in acpi_gpiochip_add()"
>
> The device that needs ssb is:
> 0c:00.0 Network controller [0280]: Broadcom Corporation BCM4321 802.11a/b/g/n [14e4:4328] (rev 03)
>          Subsystem: Dell Wireless 1500 Draft 802.11n WLAN Mini-card [1028:000a]
>          Kernel driver in use: b43-pci-bridge
>          Kernel modules: ssb
>
>
> [   92.693606] ssb: Found chip with id 0x4321, rev 0x03 and package 0x00
> [   92.693649] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
> [   92.693675] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
> [   92.693699] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x04, vendor 0x4243)
> [   92.693723] ssb: Core 3 found: PCI (cc 0x804, rev 0x0D, vendor 0x4243)
> [   92.693746] ssb: Core 4 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
> [   92.753554] BUG: unable to handle kernel NULL pointer dereference at 00000138
> [   92.753760] IP: [<c126c2b3>] acpi_gpiochip_add+0x13/0x190
> [   92.753901] *pde = 00000000
> [   92.753986] Oops: 0000 [#1] PREEMPT SMP
> [   92.754125] Modules linked in: ssb(+) mmc_core netconsole nouveau mxm_wmi i2c_algo_bit drm_kms_helper ttm drm joydev mousedev tg3 coretemp kvm_intel ptp pcmcia kvm pps_core libphy dell_laptop gpio_ich rfkill yenta_socket pcmcia_rsrc intel_agp intel_gtt iTCO_wdt iTCO_vendor_support dell_wmi sparse_keymap pcmcia_core evdev agpgart dcdbas snd_hda_codec_idt snd_hda_codec_generic microcode psmouse pcspkr i2c_i801 i2c_core serio_raw lpc_ich mfd_core acpi_cpufreq ac battery thermal button wmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm video snd_timer shpchp processor snd soundcore nfs lockd sunrpc ext4 crc16 mbcache jbd2 sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix libata scsi_mod firewire_ohci firewire_core crc_itu_t uhci_hcd ehci_pci ehci_hcd usbcore usb_common
> [   92.756833] CPU: 0 PID: 512 Comm: modprobe Tainted: G        W     3.14.0-rc7-next-20140324-t1 #24
> [   92.756833] Hardware name: Dell Inc. Latitude D830                   /0UY141, BIOS A02 06/07/2007
> [   92.756833] task: f5799900 ti: f543e000 task.ti: f543e000
> [   92.756833] EIP: 0060:[<c126c2b3>] EFLAGS: 00010282 CPU: 0
> [   92.756833] EIP is at acpi_gpiochip_add+0x13/0x190
> [   92.756833] EAX: 00000000 EBX: f57824c4 ECX: 00000000 EDX: 00000000
> [   92.756833] ESI: f57824c4 EDI: 00000010 EBP: f543fc54 ESP: f543fc40
> [   92.756833]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   92.756833] CR0: 8005003b CR2: 00000138 CR3: 355f8000 CR4: 000007d0
> [   92.756833] Stack:
> [   92.756833]  f543fc5c fd1f7790 f57824c4 000000be 00000010 f543fc84 c1269f4e f543fc74
> [   92.756833]  fd1f78bd 00008002 f57822b0 f5782090 fd1f8400 00000286 fd1f9994 00000000
> [   92.756833]  f5782000 f543fc8c fd1f7e39 f543fcc8 fd1f0bd8 000000c0 00000000 00000000
> [   92.756833] Call Trace:
> [   92.756833]  [<fd1f7790>] ? ssb_pcie_mdio_write+0xa0/0xd0 [ssb]
> [   92.756833]  [<c1269f4e>] gpiochip_add+0xee/0x300
> [   92.756833]  [<fd1f78bd>] ? ssb_pcicore_serdes_workaround+0xfd/0x140 [ssb]
> [   92.756833]  [<fd1f7e39>] ssb_gpio_init+0x89/0xa0 [ssb]
> [   92.756833]  [<fd1f0bd8>] ssb_attach_queued_buses+0xc8/0x2d0 [ssb]
> [   92.756833]  [<fd1f0f65>] ssb_bus_register+0x185/0x1f0 [ssb]
> [   92.756833]  [<fd1f3120>] ? ssb_pci_xtal+0x220/0x220 [ssb]
> [   92.756833]  [<fd1f106c>] ssb_bus_pcibus_register+0x2c/0x80 [ssb]
> [   92.756833]  [<fd1f40dc>] ssb_pcihost_probe+0x9c/0x110 [ssb]
> [   92.756833]  [<c1276c8f>] pci_device_probe+0x6f/0xc0
> [   92.756833]  [<c11bdb55>] ? sysfs_create_link+0x25/0x40
> [   92.756833]  [<c131d8b9>] driver_probe_device+0x79/0x360
> [   92.756833]  [<c1276512>] ? pci_match_device+0xb2/0xc0
> [   92.756833]  [<c131dc51>] __driver_attach+0x71/0x80
> [   92.756833]  [<c131dbe0>] ? __device_attach+0x40/0x40
> [   92.756833]  [<c131bd87>] bus_for_each_dev+0x47/0x80
> [   92.756833]  [<c131d3ae>] driver_attach+0x1e/0x20
> [   92.756833]  [<c131dbe0>] ? __device_attach+0x40/0x40
> [   92.756833]  [<c131d007>] bus_add_driver+0x157/0x230
> [   92.756833]  [<c131e219>] driver_register+0x59/0xe0
> [   92.756833]  [<fd8f1000>] ? 0xfd8f0fff
> [   92.756833]  [<c1276622>] __pci_register_driver+0x32/0x40
> [   92.756833]  [<fd1f3f53>] ssb_pcihost_register+0x33/0x40 [ssb]
> [   92.756833]  [<fd8f1083>] b43_pci_ssb_bridge_init+0xd/0xf [ssb]
> [   92.756833]  [<fd8f105e>] ssb_modinit+0x5e/0x76 [ssb]
> [   92.756833]  [<c100047a>] do_one_initcall+0xaa/0x160
> [   92.756833]  [<c144272d>] ? mutex_unlock+0xd/0x10
> [   92.756833]  [<c10ed57c>] ? trace_module_notify+0xcc/0x1b0
> [   92.756833]  [<c11059aa>] ? jump_label_module_notify+0x17a/0x1c0
> [   92.756833]  [<c14471a1>] ? notifier_call_chain+0x41/0x60
> [   92.756833]  [<c10673d4>] ? __blocking_notifier_call_chain+0x44/0x60
> [   92.756833]  [<c10b62bf>] load_module+0x1b4f/0x2260
> [   92.756833]  [<c10b6b38>] SyS_finit_module+0x78/0xb0
> [   92.756833]  [<c111f02b>] ? vm_mmap_pgoff+0x7b/0xa0
> [   92.756833]  [<c144ab98>] sysenter_do_call+0x12/0x28
> [   92.756833] Code: b8 fe ff ff ff e9 79 ff ff ff 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec 08 66 66 66 66 90 89 c6 8b 40 04<8b>  80 38 01 00 00 85 c0 0f 84 dc 00 00 00 8b 78 04 85 ff 0f 84
> [   92.756833] EIP: [<c126c2b3>] acpi_gpiochip_add+0x13/0x190 SS:ESP 0068:f543fc40
> [   92.756833] CR2: 0000000000000138
> [   92.867899] ---[ end trace b5df37015ae9f231 ]---
>
>
> Thanks,
>

