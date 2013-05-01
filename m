Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3EAM7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 08:59:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab3EAM7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 08:59:33 -0400
Date: Wed, 1 May 2013 14:59:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando_b1@lab.ntt.co.jp>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH] HID: fix botched tree merge that disabled fix-up for
 certain Sony RF receivers
In-Reply-To: <1367367983.4712.5.camel@nexus>
Message-ID: <alpine.LNX.2.00.1305011458440.20139@pobox.suse.cz>
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>  <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>  <50F52986.2080002@lab.ntt.co.jp>  <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>  <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz> 
 <1367367906.4712.4.camel@nexus> <1367367983.4712.5.camel@nexus>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Fernando Luis Vázquez Cao wrote:

> It looks like the manual merge 0d69a3c731e120b05b7da9fb976830475a3fbc01 ("Merge
> branches 'for-3.9/sony' and 'for-3.9/steelseries' into for-linus") accidentally
> removed Sony RF receiver with USB product id 0x0374 from the "have special
> driver" list, effectively nullifying a464918419f94a0043d2f549d6defb4c3f69f68a
> ("HID: add support for Sony RF receiver with USB product id 0x0374"). Add the
> device back to the list.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-3.9/drivers/hid/hid-core.c linux-3.9-fix/drivers/hid/hid-core.c
> --- linux-3.9/drivers/hid/hid-core.c	2013-04-29 09:36:01.000000000 +0900
> +++ linux-3.9-fix/drivers/hid/hid-core.c	2013-04-30 21:53:57.596269692 +0900
> @@ -1702,6 +1702,7 @@ static const struct hid_device_id hid_ha
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
>  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_THINGM, USB_DEVICE_ID_BLINK1) },

Thanks a lot for noticing. Applied.

-- 
Jiri Kosina
SUSE Labs
