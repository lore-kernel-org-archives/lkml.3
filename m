Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3LCDy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:54:29 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37538 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3LCDy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:54:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com, nm@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: omap3-beagle: Fix USB host on beagle boards (for 3.13)
Date: Tue, 03 Dec 2013 04:54:28 +0100
Message-ID: <3636447.xncPcCYRzc@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385387745-7162-1-git-send-email-rogerq@ti.com>
References: <1385387745-7162-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Monday 25 November 2013 15:55:45 Roger Quadros wrote:
> Beagle (rev. C4) and Beagle-XM (all revs) need VAUX2 1.8V supply
> for the USB PHY.
> 
> As the generic PHY driver can't handle more than one supply
> at the moment, we configure this supply to be always on.
> This will cause a very small power impact if the USB host subsystem
> is not in use, about 76.86 micro-W + LDO power.
> 
> Older Beagle boards (prior to C4) don't have VAUX2 connected anywhere,
> so there won't be any functional impact on those boards other than
> some additional LDO power consumption.

Do I need any patch other than this one (on top of v3.13-rc1) to enable the
ethernet port on a Beagleboard-xM rev B ? Here's what the kernel reports at
boot (with ignore_loglevel set on the command line).

[    3.388305] ehci-omap 48064800.ehci: EHCI Host Controller
[    3.394165] ehci-omap 48064800.ehci: new USB bus registered, assigned bus number 2
[    3.402252] ehci-omap 48064800.ehci: reset hcs_params 0x1313 dbg=0 cc=1 pcc=3 ordered ports=3
[    3.411254] ehci-omap 48064800.ehci: reset hcc_params 0016 thresh 1 uframes 256/512/1024 park
[    3.422027] ehci-omap 48064800.ehci: park 0
[    3.426544] ehci-omap 48064800.ehci: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[    3.436248] ehci-omap 48064800.ehci: irq 93, io mem 0x48064800
[    3.442443] ehci-omap 48064800.ehci: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    3.467407] ehci-omap 48064800.ehci: USB 2.0 started, EHCI 1.00
[    3.475494] usb usb2: default language 0x0409
[    3.480712] usb usb2: udev 1, busnum 2, minor = 128
[    3.485809] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.493011] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.500640] usb usb2: Product: EHCI Host Controller
[    3.505737] usb usb2: Manufacturer: Linux 3.13.0-rc1-00022-g0c6e4db ehci_hcd
[    3.513183] usb usb2: SerialNumber: 48064800.ehci
[    3.521270] usb usb2: usb_probe_device
[    3.525207] usb usb2: configuration #1 chosen from 1 choice
[    3.531890] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.539855] hub 2-0:1.0: usb_probe_interface
[    3.544342] hub 2-0:1.0: usb_probe_interface - got id
[    3.549835] hub 2-0:1.0: USB hub found
[    3.554290] hub 2-0:1.0: 3 ports detected
[    3.558593] hub 2-0:1.0: standalone hub
[    3.562591] hub 2-0:1.0: individual port power switching
[    3.568237] hub 2-0:1.0: individual port over-current protection
[    3.574523] hub 2-0:1.0: power on to power good time: 20ms
[    3.581085] hub 2-0:1.0: local power source is good
[    3.587646] hub 2-0:1.0: enabling power on all ports
[    3.598693] of_get_named_gpiod_flags exited with status 0
[    3.607208] input: gpio_keys.6 as /devices/gpio_keys.6/input/input0
[    3.617370] twl_rtc rtc.10: setting system clock to 2000-01-01 00:37:16 UTC (946687036)
[    3.628295] omap_vout:Could not register Video driver
[    3.633575] sr_init: No PMIC hook to init smartreflex
[    3.641265] sr_init: platform driver register failed for SR
[    3.765655] ehci-omap 48064800.ehci: GetStatus port:2 status 001c03 0  ACK POWER sig=? CSC CONNECT
[    3.775329] hub 2-0:1.0: port 2: status 0501 change 0001
[    3.877471] hub 2-0:1.0: state 7 ports 3 chg 0004 evt 0000
[    3.883758] hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    3.947357] ehci-omap 48064800.ehci: GetStatus port:2 status 001402 0  ACK POWER sig=k CSC
[    3.977264] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0004
[    3.983062] ehci-omap 48064800.ehci: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    3.993041] hub 2-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[    4.157440] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[    4.165283] hub 2-0:1.0: hub_suspend
[    4.169311] usb usb2: bus auto-suspend, wakeup 1
[    4.174133] ehci-omap 48064800.ehci: suspend root hub
[   15.878875] ALSA device list:
[   15.881988]   No soundcards found.
[   15.888214] omap_uart 49020000.serial: no wakeirq for uart2
[   15.894866] Waiting 10 sec before mounting root device...
[  120.959472] VFS: Unable to mount root fs via NFS, trying floppy.
[  120.968048] VFS: Cannot open root device "nfs" or unknown-block(2,0): error -6
[  120.975585] Please append a correct "root=" boot option; here are the available partitions:
[  120.984558] b300         3941376 mmcblk0  driver: mmcblk
[  120.990203]   b301          803249 mmcblk0p1 00000000-01
[  120.995788]   b302         3132675 mmcblk0p2 00000000-02
[  121.001678] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)

> Reported-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap3-beagle-xm.dts | 8 ++++++++
>  arch/arm/boot/dts/omap3-beagle.dts    | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts
> b/arch/arm/boot/dts/omap3-beagle-xm.dts index 31a632f..b39918e 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -215,3 +215,11 @@
>  &usbhsehci {
>  	phys = <0 &hsusb2_phy>;
>  };
> +
> +&vaux2 {
> +	regulator-name = "usb_1v8";
> +	regulator-min-microvolt = <1800000>;
> +	regulator-max-microvolt = <1800000>;
> +	regulator-always-on;
> +};
> +
> diff --git a/arch/arm/boot/dts/omap3-beagle.dts
> b/arch/arm/boot/dts/omap3-beagle.dts index fa532aa..9764556 100644
> --- a/arch/arm/boot/dts/omap3-beagle.dts
> +++ b/arch/arm/boot/dts/omap3-beagle.dts
> @@ -178,3 +178,11 @@
>  	mode = <3>;
>  	power = <50>;
>  };
> +
> +&vaux2 {
> +	regulator-name = "vdd_ehci";
> +	regulator-min-microvolt = <1800000>;
> +	regulator-max-microvolt = <1800000>;
> +	regulator-always-on;
> +};
> +
-- 
Regards,

Laurent Pinchart

