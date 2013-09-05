Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383Ab3IEH2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:28:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38817 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab3IEH2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:28:15 -0400
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Dave Jones <davej@redhat.com>
Cc: mchehab@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: dvb-usb/technisat-usb2: Fix cut-n-paste thinko
Date: Thu, 05 Sep 2013 09:28:13 +0200
Message-ID: <3501409.n7PgjBMFjV@dibcom294>
Organization: KernelLabs Inc.
User-Agent: KMail/4.8.5 (Linux/3.5.0-39-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20130904235917.GC5727@redhat.com>
References: <20130904235917.GC5727@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Wednesday 04 September 2013 19:59:17 Dave Jones wrote:
> This looks like it was cut and pasted from the code above which does
> similar checks on txlen, but someone forgot to change the variable.

This someone would be me.

> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c
> b/drivers/media/usb/dvb-usb/technisat-usb2.c index 40832a1..98d24ae
> 100644
> --- a/drivers/media/usb/dvb-usb/technisat-usb2.c
> +++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
> @@ -102,7 +102,7 @@ static int technisat_usb2_i2c_access(struct usb_device
> *udev, if (rxlen > 62) {
>  		err("i2c RX buffer can't exceed 62 bytes (dev 0x%02x)",
>  				device_addr);
> -		txlen = 62;
> +		rxlen = 62;
>  	}
> 
>  	b[0] = I2C_SPEED_100KHZ_BIT;

Nice catch.

Mauro, feel free to add my signed-off-line, when integrating

Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>



--
Patrick 
