Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3CDLGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:06:00 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:59947 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3CDLF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:05:58 -0500
MIME-Version: 1.0
In-Reply-To: <20130301194359.700037464@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
	<20130301194359.700037464@linuxfoundation.org>
Date: Mon, 4 Mar 2013 14:05:57 +0300
Message-ID: <CALW4P+LD1Ah8cgTYBeAT5zR4mwq-K+_LP7rMq=ytBWW2Gp0P3w@mail.gmail.com>
Subject: Re: [ 73/77] [hid] usb hid quirks for Masterkit MA901 usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Jiri Kosina <jkosina@suse.cz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Mar 1, 2013 at 11:44 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Alexey Klimov <klimov.linux@gmail.com>
>
> commit 0322bd3980b3ebf7dde8474e22614cb443d6479a upstream.
>
> Don't let Masterkit MA901 USB radio be handled by usb hid drivers.
> This device will be handled by radio-ma901.c driver.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/hid/hid-core.c |    1 +
>  drivers/hid/hid-ids.h  |    3 +++
>  2 files changed, 4 insertions(+)
>
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -2071,6 +2071,7 @@ static const struct hid_device_id hid_ig
>         { HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_MASTERKIT, USB_DEVICE_ID_MASTERKIT_MA901RADIO) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -554,6 +554,9 @@
>  #define USB_VENDOR_ID_MADCATZ          0x0738
>  #define USB_DEVICE_ID_MADCATZ_BEATPAD  0x4540
>
> +#define USB_VENDOR_ID_MASTERKIT                        0x16c0
> +#define USB_DEVICE_ID_MASTERKIT_MA901RADIO     0x05df
> +
>  #define USB_VENDOR_ID_MCC              0x09db
>  #define USB_DEVICE_ID_MCC_PMD1024LS    0x0076
>  #define USB_DEVICE_ID_MCC_PMD1208LS    0x007a

These usb hid quirks are related to new usb radio driver
media/radio/radio-ma901.c  (commit
4834f4d1ff1dc574024e1a6de920ea99571090ff in upstream) that was merged
during 3.9 merge window. So i am not sure if they have any sense
without driver itself. Also, they shouldn't make any damage as far as
i can imagine.

-- 
Best regards, Klimov Alexey
