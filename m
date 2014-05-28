Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaE1Nn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:43:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbaE1Nn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:43:56 -0400
Date: Wed, 28 May 2014 15:43:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Reyad Attiyat <reyad.attiyat@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH] HID: hid-sensor-hub: Set report quirk for Microsoft
 Surface
In-Reply-To: <1401175750-3008-1-git-send-email-reyad.attiyat@gmail.com>
Message-ID: <alpine.LNX.2.00.1405281541100.17241@pobox.suse.cz>
References: <1401175750-3008-1-git-send-email-reyad.attiyat@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Reyad Attiyat wrote:

> Add the Microsoft Surface Pro 2 Type/Touch and default device hardware ID's
> Set report quirk for the device in hid-sensor-hub
> 
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> ---
>  drivers/hid/hid-ids.h        | 3 +++
>  drivers/hid/hid-sensor-hub.c | 9 +++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 34bb220..18e2099 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -633,6 +633,9 @@
>  #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
>  #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K	0x0730
>  #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500	0x076c
> +#define USB_DEVICE_ID_MS_SURFACE_PRO_2   0x0799
> +#define USB_DEVICE_ID_MS_TOUCH_COVER_2   0x07a7
> +#define USB_DEVICE_ID_MS_TYPE_COVER_2    0x07a9
>  
>  #define USB_VENDOR_ID_MOJO		0x8282
>  #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> index be14b56..eefaaf6 100644
> --- a/drivers/hid/hid-sensor-hub.c
> +++ b/drivers/hid/hid-sensor-hub.c
> @@ -711,6 +711,15 @@ static const struct hid_device_id sensor_hub_devices[] = {
>  	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_TEXAS_INSTRUMENTS,
>  			USB_DEVICE_ID_TEXAS_INSTRUMENTS_LENOVO_YOGA),
>  			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
> +	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
> +			USB_DEVICE_ID_MS_SURFACE_PRO_2),
> +			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
> +	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
> +			USB_DEVICE_ID_MS_TOUCH_COVER_2),
> +			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
> +	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, USB_VENDOR_ID_MICROSOFT,
> +			USB_DEVICE_ID_MS_TYPE_COVER_2),
> +			.driver_data = HID_SENSOR_HUB_ENUM_QUIRK},
>  	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, HID_ANY_ID,
>  		     HID_ANY_ID) },
>  	{ }

[ Benjamin added to CC]

How does this combine with f3b0cbce01 and e24d0d399b2f in Linus' tree?

-- 
Jiri Kosina
SUSE Labs
