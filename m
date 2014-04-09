Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbaDIVJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:09:54 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37373 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbaDIVJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:09:52 -0400
MIME-Version: 1.0
Date: Wed, 9 Apr 2014 17:09:51 -0400
X-Google-Sender-Auth: jnkJ_lztg0VmFNGJ82KqMh0yAtI
Message-ID: <CA+5PVA5VBns=hkOSViucrpT340uG0=hgrWqf=LYHTBFAe74tBg@mail.gmail.com>
Subject: Oops in acpi_gpiochip_add on MacBookPro with Linux v3.14-12042-g69cd9eba3886
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-gpio@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

With Linux v3.14-12042-g69cd9eba3886 I get an oops from the bcma
module on the MacBookPro 10,2 I have here.  This works fine with Linux
v3.14-7333-g59ecc26004e7.  There have been no changes between those
two versions to bcma itself, but the GPIO merge did go in that window.
 I can attempt to do a bisect tomorrow, but looking over some of the
GPIO commits it seems pretty relevant to the ACPI GPIO changes.  I'm
hoping someone here has an idea on what the issue might be and has
some possible things for me to test for fixes.

I've transcribed the oops below by hand from a pic I took of the oops
because it doesn't wind up in the logs.  The pic itself can be
accessed here:

https://drive.google.com/file/d/0B03YtBX8ablKdC10NTdmQnBidVk/

josh

bcma: bus0: Found chip with id 0x4331, rev 0x02, and package 0x09
bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x25,
class 0x0)
bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev
0x1D, class 0x0)
bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x13, class 0x0)
BUG: unable to handle kernel NULL pointer dereference at 00000000000003d8
IP: [<ffffffff81400765>] acpi_gpiochip_add+0x15/0x1c0
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: snd_pcm(+) sdhci_pci(+) i2c_i801 bcma(+) sdhci mmc_core....
CPU: 1 PID: 636 Comm: systemd-udevd Not tainted 3.15.0-0.rc0.git10.1.fc21.x86_64
Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS
MBP102.88Z.01...
task: ffff880.....
RIP: 0010:[<ffffffff81400765>] [<ffffffff81400765>] acpi_gpiochip_add+0x15/0x1c0
....
Call Trace:
gpiochip_add
bcma_gpio_init
bcma_bus_register
bcma_host_pci_probe
local_pci_probe
? pci_match_device
pci_device_probe
driver_probe_device
__driver_attach
? __driver_attach
bus_for_each_dev
driver_attach
bus_add_driver
? bcma_bus_early_register
driver_register
? bcma_bus_early_register
__pci_register_driver
bcma_host_pci_init
bcma_modinit
do_one_initcall
? set_memory_nx
load_module
? store_uevent
? kernel_read
SyS_finit_module
system_call_fastpath
