Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3IBLgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:36:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab3IBLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:36:08 -0400
Date: Mon, 2 Sep 2013 13:36:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Vasily Titskiy <qehgt0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2] HID: usbhid: quirk for N-Trig DuoSense Touch Screen
In-Reply-To: <CABSveYikpdAy9rUDfVrL=jAj7OCqFXyPd7GsvjTnhH3K=u--Zg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1309021335330.3796@pobox.suse.cz>
References: <CABSveYikpdAy9rUDfVrL=jAj7OCqFXyPd7GsvjTnhH3K=u--Zg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Aug 2013, Vasily Titskiy wrote:

> The DuoSense touchscreen device causes a 10 second timeout. This fix
> removes the delay.
> 
> Signed-off-by: Vasily Titskiy <qehgt0@gmail.com>
> ---
>  drivers/hid/hid-ids.h           |    1 +
>  drivers/hid/usbhid/hid-quirks.c |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 2168885..376170e 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -646,6 +646,7 @@
>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16   0x0012
>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17   0x0013
>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18   0x0014
> +#define USB_DEVICE_ID_NTRIG_DUOSENSE 0x1500
> 
>  #define USB_VENDOR_ID_ONTRAK 0x0a07
>  #define USB_DEVICE_ID_ONTRAK_ADU100 0x0064
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 19b8360..1671b47 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -109,6 +109,7 @@ static const struct hid_blacklist {
>   { USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD,
> HID_QUIRK_NO_INIT_REPORTS },
>   { USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X,
> HID_QUIRK_MULTI_INPUT },
>   { USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
> + { USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE,
> HID_QUIRK_NO_INIT_REPORTS },
>   { 0, 0 }
>  };

Vasily,

your mail client is line-wrapping text, which causes corrupted patches.

I have fixed it up and applied, but please keep that in mind for your 
future submissions.

Thanks,

-- 
Jiri Kosina
SUSE Labs
