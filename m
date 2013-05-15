Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3EOHWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:22:45 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37056 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab3EOHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:22:44 -0400
Date: Wed, 15 May 2013 10:24:09 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [Regression] Boot failure on ALIX during LED probe
Message-ID: <20130515102409.5218231c@vostro>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the below with Linux 3.8.7-grsec and 3.9.2-grsec. Where as
3.6.11-grsec is a known good. I believe the same would happen on on
vanilla kernels too.

[ 15.709955] general protection fault: 0000 [#1] SMP
[ 15.712287] Modules linked in: leds_gpio(+) via_rhine mii cs5535_mfd mfd_core geode_rng rng_core geode_aes isofs nls_utf8 nls_cp437 vfat fat pata_acpi pata_cs5536 pata_amd ata_generic libata ehci_pci ehci_hcd ohci_hcd usbcore usb_common sd_mod scsi_mod squashfs loop
[ 15.712287] Pid: 782, comm: modprobe Not tainted 3.8.7-0-grsec #1-Alpine
[ 15.712287] EIP: 0060:[] EFLAGS: 00010212 CPU: 0
[ 15.712287] EIP is at __gpio_cansleep+0xd/0x14
[ 15.712287] EAX: 00000000 EBX: ce3c2818 ECX: c1379bf0 EDX: 00000000
[ 15.712287] ESI: c142f7a4 EDI: c142f770 EBP: cdd67ddc ESP: cdd67dbc
[ 15.712287] DS: 0068 ES: 0068 FS: 00d8 GS: 007b SS: 0068
[ 15.712287] CR0: 8005003b CR2: aaa409b0 CR3: 0dd16000 CR4: 00000090
[ 15.712287] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 15.712287] DR6: ffff0ff0 DR7: 00000400
[ 15.712287] Process modprobe (pid: 782, ti=ce6d6a90 task=ce6d6700 task.ti=ce6d6a90)
[ 15.712287] Stack:
[ 15.712287] d0aa91cb 00000000 c142f660 ce3c2814 00000000 c142f660 c142f654 d0aa7014
[ 15.712287] cdd67df0 c11a5efd c142f660 d0aa7014 d0aa7014 cdd67e04 c11a4bf2 c142f660
[ 15.712287] d0aa7014 c142f694 cdd67e18 c11a4d2b cdd67e20 d0aa7014 00000000 cdd67e34
[ 15.712287] Call Trace:
[ 15.712287] [] ? gpio_led_probe+0xba/0x203 [leds_gpio]
[ 15.712287] [] platform_drv_probe+0x26/0x48
[ 15.712287] [] driver_probe_device+0x80/0x172
[ 15.712287] [] __driver_attach+0x47/0x63
[ 15.712287] [] bus_for_each_dev+0x3c/0x66
[ 15.712287] [] driver_attach+0x14/0x16
[ 15.712287] [] ? driver_probe_device+0x172/0x172
[ 15.712287] [] bus_add_driver+0xbd/0x1bc
[ 15.712287] [] ? 0xd0aaafff
[ 15.712287] [] ? 0xd0aaafff
[ 15.712287] [] driver_register+0x74/0xec
[ 15.712287] [] ? notifier_call_chain+0x25/0x46
[ 15.712287] [] ? 0xd0aaafff
[ 15.712287] [] platform_driver_register+0x38/0x3a
[ 15.712287] [] gpio_led_driver_init+0xd/0x5b5 [leds_gpio]
[ 15.712287] [] do_one_initcall+0x6a/0xff
[ 15.712287] [] load_module+0x15b2/0x18de
[ 15.712287] [] ? insert_vmalloc_vmlist+0x14/0x52
[ 15.712287] [] ? __vmalloc_node_range+0x13e/0x15f
[ 15.712287] [] sys_init_module+0x113/0x129
[ 15.712287] [] syscall_call+0x7/0xb
[ 15.712287] Code: 00 5c 50 c1 75 14 8b 82 04 5c 50 c1 a8 01 74 0a 8b 8a 08 5c 50 c1 eb 02 31 c9 89 c8 5d c3 6b c0 0c 55 89 e5 5d 8b 80 00 5c 50 c1 40 40 83 e0 01 c3 6b d0 0c 55 89 e5 53 8b 8a 00 5c 50 c1 8b
[ 15.712287] EIP: [] __gpio_cansleep+0xd/0x14 SS:ESP 0068:cdd67dbc
[ 15.714343] ---[ end trace d6fdd52620ab8376 ]---
[ 16.491213] cs5535-gpio cs5535-gpio: reserved resource region [io 0x6100-0x61ff]
[ 16.604968] cs5535-mfgpt cs5535-mfgpt: reserved resource region [io 0x6200-0x623f]
[ 16.606766] cs5535-mfgpt cs5535-mfgpt: 8 MFGPT timers available

This goes away if gpio_cs5535 is downloaded by hand before leds_gpio.
To me it seems that recent gpiolib changes do not handle the case that
the gpio chip driver is loaded after leds-gpio. Or perhaps leds-gpio
should request that platform specific module first if needed.

The relevant config is:
CONFIG_ALIX=y
CONFIG_LEDS_GPIO=m
CONFIG_GPIO_CS5535=m

Full config available at:
http://git.alpinelinux.org/cgit/aports/tree/main/linux-grsec/kernelconfig.x86


