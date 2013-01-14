Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3ANDsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 22:48:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3ANDsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 22:48:03 -0500
MIME-Version: 1.0
In-Reply-To: <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
	<CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
Date: Mon, 14 Jan 2013 11:47:57 +0800
Message-ID: <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
From: Ming Lei <ming.lei@canonical.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 1:42 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
>
> 1. Compile a kernel with deadline elevator as module
> 2. Boot into it, make sure the elevator is selected
>   (I used "elevator=deadline" in the kernel command line)
> 3. Insert a FAT formatted mass storage device in an USB2 port
>    Observe "io scheduler deadline registered"
> 4. Pull the stick out, wait a moment, and either shutdown or just
>    and press alt-sysrq-W:

I can reproduce the problem too on one ehci-only system(Pandaboard)
with deadline elevator module case, and no such problem in the
built-in case, and still on 3.8-rc3.

Follows the dmesg log:

[   85.665679] usb 1-1.2.2: new high-speed USB device number 5 using ehci-omap
[   85.784423] usb 1-1.2.2: default language 0x0409
[   85.790008] usb 1-1.2.2: udev 5, busnum 1, minor = 4
[   85.790039] usb 1-1.2.2: New USB device found, idVendor=0951, idProduct=1624
[   85.790039] usb 1-1.2.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[   85.790069] usb 1-1.2.2: Product: DataTraveler G2
[   85.790069] usb 1-1.2.2: Manufacturer: Kingston
[   85.790100] usb 1-1.2.2: SerialNumber: 0019E06C5346EA41D0000071
[   85.790100] device: '1-1.2.2': device_add
[   85.790344] bus: 'usb': add device 1-1.2.2
[   85.790405] PM: Adding info for usb:1-1.2.2
[   85.790740] bus: 'usb': driver_probe_device: matched device 1-1.2.2
with driver usb
[   85.790771] bus: 'usb': really_probe: probing driver usb with device 1-1.2.2
[   85.790802] usb 1-1.2.2: usb_probe_device
[   85.790832] usb 1-1.2.2: configuration #1 chosen from 1 choice
[   85.791076] usb 1-1.2.2: adding 1-1.2.2:1.0 (config #1, interface 0)
[   85.791076] device: '1-1.2.2:1.0': device_add
[   85.791137] bus: 'usb': add device 1-1.2.2:1.0
[   85.791168] PM: Adding info for usb:1-1.2.2:1.0
[   85.791442] device: 'ep_81': device_add
[   85.791564] PM: Adding info for No Bus:ep_81
[   85.791564] device: 'ep_02': device_add
[   85.791687] PM: Adding info for No Bus:ep_02
[   85.791687] driver: '1-1.2.2': driver_bound: bound to device 'usb'
[   85.791717] bus: 'usb': really_probe: bound device 1-1.2.2 to driver usb
[   85.791748] PM: Moving platform:musb-hdrc.0.auto to end of list
[   85.791748] device: 'ep_00': device_add
[   85.791778] platform musb-hdrc.0.auto: Retrying from deferred list
[   85.791839] PM: Adding info for No Bus:ep_00
[   85.791839] bus: 'platform': driver_probe_device: matched device
musb-hdrc.0.auto with driver musb-hdrc
[   85.791839] bus: 'platform': really_probe: probing driver musb-hdrc
with device musb-hdrc.0.auto
[   85.791870] hub 1-1.2:1.0: state 7 ports 4 chg 0000 evt 0004
[   85.791900] unable to find transceiver of type USB2 PHY
[   85.797454] HS USB OTG: no transceiver configured
[   85.802703] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed
with status -517
[   85.811157] platform musb-hdrc.0.auto: Driver musb-hdrc requests
probe deferral
[   85.811187] platform musb-hdrc.0.auto: Added to deferred list
[   85.811218] PM: Moving platform:twl6030_usb to end of list
[   85.811218] platform twl6030_usb: Retrying from deferred list
[   85.811279] bus: 'platform': driver_probe_device: matched device
twl6030_usb with driver twl6030_usb
[   85.811279] bus: 'platform': really_probe: probing driver
twl6030_usb with device twl6030_usb
[   85.811309] twl6030_usb twl6030_usb: phy not ready, deferring probe
[   85.811462] platform twl6030_usb: Driver twl6030_usb requests probe deferral
[   85.811462] platform twl6030_usb: Added to deferred list
[   85.883331] Initializing USB Mass Storage driver...
[   85.883361] bus: 'usb': add driver usb-storage
[   85.883453] bus: 'usb': driver_probe_device: matched device
1-1.2.2:1.0 with driver usb-storage
[   85.883483] bus: 'usb': really_probe: probing driver usb-storage
with device 1-1.2.2:1.0
[   85.883514] usb-storage 1-1.2.2:1.0: usb_probe_interface
[   85.883544] usb-storage 1-1.2.2:1.0: usb_probe_interface - got id
[   85.884094] scsi0 : usb-storage 1-1.2.2:1.0
[   85.884155] device: 'host0': device_add
[   85.884185] bus: 'scsi': add device host0
[   85.884246] PM: Adding info for scsi:host0
[   85.884552] device: 'host0': device_add
[   85.884674] PM: Adding info for No Bus:host0
[   85.884948] driver: '1-1.2.2:1.0': driver_bound: bound to device
'usb-storage'
[   85.884979] bus: 'usb': really_probe: bound device 1-1.2.2:1.0 to
driver usb-storage
[   85.884979] PM: Moving platform:musb-hdrc.0.auto to end of list
[   85.885009] platform musb-hdrc.0.auto: Retrying from deferred list
[   85.885070] bus: 'platform': driver_probe_device: matched device
musb-hdrc.0.auto with driver musb-hdrc
[   85.885070] bus: 'platform': really_probe: probing driver musb-hdrc
with device musb-hdrc.0.auto
[   85.885131] unable to find transceiver of type USB2 PHY
[   85.886230] usbcore: registered new interface driver usb-storage
[   85.886230] USB Mass Storage support registered.
[   85.890655] HS USB OTG: no transceiver configured
[   85.895660] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed
with status -517
[   85.903839] platform musb-hdrc.0.auto: Driver musb-hdrc requests
probe deferral
[   85.903869] platform musb-hdrc.0.auto: Added to deferred list
[   85.903869] PM: Moving platform:twl6030_usb to end of list
[   85.903900] platform twl6030_usb: Retrying from deferred list
[   85.903930] bus: 'platform': driver_probe_device: matched device
twl6030_usb with driver twl6030_usb
[   85.903961] bus: 'platform': really_probe: probing driver
twl6030_usb with device twl6030_usb
[   85.903991] twl6030_usb twl6030_usb: phy not ready, deferring probe
[   85.904022] platform twl6030_usb: Driver twl6030_usb requests probe deferral
[   85.904052] platform twl6030_usb: Added to deferred list
[   86.901367] io scheduler deadline registered (default)
[  181.168487] INFO: task modprobe:2462 blocked for more than 90 seconds.
[  181.175323] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  181.183624] modprobe        D c04f1920     0  2462   2461 0x00000000
[  181.183685] [<c04f1920>] (__schedule+0x5fc/0x6d4) from [<c005eba4>]
(async_synchronize_cookie_domain+0xdc/0x
168)
[  181.183715] [<c005eba4>]
(async_synchronize_cookie_domain+0xdc/0x168) from [<c005ed04>]
(async_synchronize_f
ull+0x3c/0x60)
[  181.183776] [<c005ed04>] (async_synchronize_full+0x3c/0x60) from
[<c0085610>] (load_module+0x1aac/0x1cdc)
[  181.183807] [<c0085610>] (load_module+0x1aac/0x1cdc) from
[<c0085944>] (sys_init_module+0x104/0x110)
[  181.183837] [<c0085944>] (sys_init_module+0x104/0x110) from
[<c000dfe0>] (ret_fast_syscall+0x0/0x48)
[  271.175506] INFO: task modprobe:2462 blocked for more than 90 seconds.
[  271.182373] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  271.190826] modprobe        D c04f1920     0  2462   2461 0x00000000
[  271.190887] [<c04f1920>] (__schedule+0x5fc/0x6d4) from [<c005eba4>]
(async_synchronize_cookie_domain+0xdc/0x
168)
[  271.190917] [<c005eba4>]
(async_synchronize_cookie_domain+0xdc/0x168) from [<c005ed04>]
(async_synchronize_f
ull+0x3c/0x60)
[  271.190948] [<c005ed04>] (async_synchronize_full+0x3c/0x60) from
[<c0085610>] (load_module+0x1aac/0x1cdc)
[  271.190948] [<c0085610>] (load_module+0x1aac/0x1cdc) from
[<c0085944>] (sys_init_module+0x104/0x110)
[  271.190979] [<c0085944>] (sys_init_module+0x104/0x110) from
[<c000dfe0>] (ret_fast_syscall+0x0/0x48)



Thanks,
--
Ming Lei
