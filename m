Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaKJXrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:47:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKJXrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:47:14 -0500
Date: Tue, 11 Nov 2014 08:45:55 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver needs an owner
Message-ID: <20141110234555.GB21278@kroah.com>
References: <CAOMZO5CZ0rzhBquTLp+oo0ddvwy22iz0yE3pyap+wVDT0+oMKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CZ0rzhBquTLp+oo0ddvwy22iz0yE3pyap+wVDT0+oMKQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:36:29PM -0200, Fabio Estevam wrote:
> Wolfram,
> 
> Since commit 161d6981096f57("core: platform: add warning if driver has
> no owner") I get the following on mx28:
> 
> $ dmesg | grep owner
> [    0.111580] Driver 'reg-dummy' needs an owner
> [    0.184911] Driver 'imx23-pinctrl' needs an owner
> [    0.185321] Driver 'imx28-pinctrl' needs an ownerDriver 'gpio-mxs'
> needs an owner
> [    0.189719] Driver 'mxs_phy' needs an ownerDriver 'dummy' needs an owner
> [    0.286990] Driver 'uart-pl011' needs an owner
> [    0.675481] Driver 'mxs-dma' needs an owner
> [    0.713640] Driver 'reg-fixed-voltage' needs an owner
> [    0.740529] Driver 'Generic PHY' needs an owner
> [    0.745242] Driver 'Generic 10G PHY' needs an ownerDriver 'usbfs'
> needs an owner
> [    0.760398] Driver 'hub' needs an owner
> [    0.770501] Driver 'usb' needs an owner
> [    0.780824] Driver 'mxs-i2c' needs an owner
> [    1.286178] Driver 'arm-pmu' needs an owner
> [    1.294116] Driver 'alarmtimer' needs an owner<6>[    1.301869]
> futex hash table entries: 256 (order: 1, 11264 bytes)
> [    1.475709] Driver 'mxs-pwm' needs an owner
> [    1.485961] Driver 'generic-bl' needs an ownerDriver
> 'pwm-backlight' needs an owner
> [    1.505590] Driver 'mxsfb' needs an owner
> [    1.590942] Driver 'mxs-auart' needs an owner
> [    1.637906] Driver 'at24' needs an owner
> [    1.650206] Driver 'sd' needs an owner
> [    1.657976] Driver 'mtd_dataflash' needs an ownerDriver 'm25p80'
> needs an owner
> [    1.666303] Driver 'sst25l' needs an ownerDriver 'gpmi-nand' needs an owner
> [    1.692236] Driver 'mxs-spi' needs an owner
> [    1.746116] Driver 'SMSC LAN83C185' needs an owner
> [    1.751123] Driver 'SMSC LAN8187' needs an ownerDriver 'SMSC
> LAN8700' needs an owner
> [    1.759795] Driver 'SMSC LAN911x Internal PHY' needs an ownerDriver
> 'SMSC LAN8710/LAN8720' needs an owner
> [    1.770312] Driver 'ICPlus IP175C' needs an ownerDriver 'ICPlus
> IP1001' needs an owner
> [    1.779089] Driver 'ICPlus IP101A/G' needs an ownerDriver
> 'RTL8201CP Ethernet' needs an owner
> [    1.788523] Driver 'RTL8211B Gigabit Ethernet' needs an ownerDriver
> 'RTL8211E Gigabit Ethernet' needs an owner
> [    1.799480] Driver 'Micrel KS8737' needs an ownerDriver 'Micrel
> KSZ8021 or KSZ8031' needs an owner
> [    1.809398] Driver 'Micrel KSZ8031' needs an ownerDriver 'Micrel
> KSZ8041' needs an owner
> [    1.818360] Driver 'Micrel KSZ8041RNLI' needs an ownerDriver
> 'Micrel KSZ8051' needs an owner
> [    1.827672] Driver 'Micrel KSZ8001 or KS8721' needs an ownerDriver
> 'Micrel KSZ8081 or KSZ8091' needs an owner
> [    1.838476] Driver 'Micrel KSZ8061' needs an ownerDriver 'Micrel
> KSZ9021 Gigabit PHY' needs an owner
> [    1.848491] Driver 'Micrel KSZ9031 Gigabit PHY' needs an
> ownerDriver 'Micrel KSZ8873MLL Switch' needs an owner
> [    1.859480] Driver 'Micrel KSZ886X Switch' needs an ownerDriver
> 'fec' needs an owner
> [    2.003222] Driver 'enc28j60' needs an owner
> [    2.007873] Driver 'asix' needs an owner<6>[    2.012440] usbcore:
> registered new interface driver asix
> [    2.018057] Driver 'ax88179_178a' needs an owner
> [    2.029505] Driver 'cdc_ether' needs an owner
> [    2.040428] Driver 'smsc95xx' needs an owner
> [    2.051351] Driver 'net1080' needs an owner
> [    2.061885] Driver 'cdc_subset' needs an owner
> [    2.072933] Driver 'zaurus' needs an owner
> [    2.083378] Driver 'cdc_ncm' needs an owner
> [    2.100807] Driver 'usb-storage' needs an owner
> [    2.112237] Driver 'ci_hdrc' needs an owner
> [    2.117220] Driver 'msm_hsusb' needs an ownerDriver 'zevio_usb'
> needs an owner
> [    2.126321] Driver 'usbmisc_imx' needs an ownerDriver 'imx_usb'
> needs an owner
> [    2.228619] Driver 'stmp3xxx-rtc' needs an owner
> [    2.255190] Driver 'stmp3xxx_rtc_wdt' needs an owner
> [    2.274896] Driver 'mmcblk' needs an owner
> [    2.286272] Driver 'mxs-mmc' needs an owner
> [    2.342066] Driver 'leds-gpio' needs an owner
> [    2.354075] Driver 'mxs-dcp' needs an ownerDriver 'hid-generic'
> needs an owner
> [    2.375785] Driver 'a4tech' needs an ownerDriver 'apple' needs an owner
> [    2.383522] Driver 'belkin' needs an ownerDriver 'cherry' needs an owner
> [    2.391894] Driver 'chicony' needs an ownerDriver 'cypress' needs an owner
> [    2.399859] Driver 'ezkey' needs an ownerDriver 'kensington' needs an owner
> [    2.408450] Driver 'logitech' needs an ownerDriver 'microsoft' needs an owner
> [    2.416743] Driver 'monterey' needs an ownerDriver 'plantronics'
> needs an owner
> 
> 
> First issue is that we should break the line:
> 
> --- a/drivers/base/driver.c
> +++ b/drivers/base/driver.c
> @@ -152,7 +152,7 @@ int driver_register(struct device_driver *drv)
>         BUG_ON(!drv->bus->p);
> 
>         if (!drv->owner)
> -               printk(KERN_WARNING "Driver '%s' needs an owner", drv->name);
> +               printk(KERN_WARNING "Driver '%s' needs an owner\n", drv->name);
> 
> 
> Let's take drivers/i2c/busses/i2c-mxs.c: it has the following in the
> probe routine
> adap->owner = THIS_MODULE;
> 
> , and even though we still get:
> [    0.780824] Driver 'mxs-i2c' needs an owner
> 
> So what's the correct way to pass the owner?

Oops, we forgot that for drivers built into the kernel, THIS_MODULE is
NULL :(

Wolfram, want me to revert this patch?

thanks,

greg k-h
