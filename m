Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaKWO4W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 09:56:22 -0500
Received: from senator.holtmann.net ([87.106.208.187]:39675 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKWO4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 09:56:21 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v4] ath3k: Add support of MCI 13d3:3408 bt device
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <5471CFE9.9070109@gmail.com>
Date: Sun, 23 Nov 2014 22:56:11 +0800
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <4BD80C85-0288-404D-AB39-485359414DC9@holtmann.org>
References: <5471CFE9.9070109@gmail.com>
To: Dmitry Tunin <hanipouspilot@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> Add support for bluetooth MCI WB335 (AR9565) Wi-Fi+bt module.
> This bluetooth module requires loading patch and sysconfig by ath3k driver.
> 
> /sys/kernel/debug/usb/devices
> 
> T:  Bus=01 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#= 20 Spd=12 MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P:  Vendor=13d3 ProdID=3408 Rev= 0.02
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> 
> Signed-off-by: Dmitry Tunin<hanipouspilot@gmail.com>

space between the name and the email address.

> 
> ---
> 
> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index d85ced2..086240c 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -105,6 +105,7 @@ static const struct usb_device_id ath3k_table[] = {
>     { USB_DEVICE(0x13d3, 0x3375) },
>     { USB_DEVICE(0x13d3, 0x3393) },
>     { USB_DEVICE(0x13d3, 0x3402) },
> +    { USB_DEVICE(0x13d3, 0x3408) },
>     { USB_DEVICE(0x13d3, 0x3432) },

And your mail client messes up spaces vs tabs here.

> 
>     /* Atheros AR5BBU12 with sflash firmware */
> @@ -156,6 +157,7 @@ static const struct usb_device_id ath3k_blist_tbl[] = {
>     { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
>     { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
>     { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
> +    { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
>     { USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
> 
>     /* Atheros AR5BBU22 with sflash firmware */
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index edfc17b..091c813 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -182,6 +182,7 @@ static const struct usb_device_id blacklist_table[] = {
>     { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
>     { USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
>     { USB_DEVICE(0x13d3, 0x3402), .driver_info = BTUSB_ATH3012 },
> +    { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },
>     { USB_DEVICE(0x13d3, 0x3432), .driver_info = BTUSB_ATH3012 },
> 
>     /* Atheros AR5BBU12 with sflash firmware */

Regards

Marcel

