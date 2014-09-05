Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaIEIfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:35:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaIEIf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:35:26 -0400
Date: Fri, 5 Sep 2014 10:35:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: John DeSilva <desilvjo@umich.edu>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add Holtek USB ID 04d9:a0c2 ETEKCITY Scroll
In-Reply-To: <1409879285-15816-1-git-send-email-desilvjo@umich.edu>
Message-ID: <alpine.LNX.2.00.1409051034470.12309@pobox.suse.cz>
References: <1409879285-15816-1-git-send-email-desilvjo@umich.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, John DeSilva wrote:

> The report descriptor for the HOLTEK USB ID 04d9:a0c2 (ETEKCITY Scroll
> T-140 Gaming Mouse) is set to a very large amount of consumer usages
> (2^16), exceeding HID_MAX_USAGES. Added id, bindings and comments for
> the mouse, and reduced the usage and logical maximums to 0x2fff,
> consistent with the other mice in the category.
> Tested on the hardware.
> 
> Signed-off-by: John C. DeSilva <desilvjo@umich.edu>

Thanks for the patch.

> ---
>  drivers/hid/hid-holtek-mouse.c | 4 ++++
>  drivers/hid/hid-ids.h          | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
> index d60fbd0..78b3a0c 100644
> --- a/drivers/hid/hid-holtek-mouse.c
> +++ b/drivers/hid/hid-holtek-mouse.c
> @@ -29,6 +29,7 @@
>   *   and Zalman ZM-GM1
>   * - USB ID 04d9:a081, sold as SHARKOON DarkGlider Gaming mouse
>   * - USB ID 04d9:a072, sold as LEETGION Hellion Gaming Mouse
> + * - USB ID 04d9:a0c2, sold as ETEKCITY Scroll T-140 Gaming Mouse
>   */
>  
>  static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
> @@ -42,6 +43,7 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  		switch (hdev->product) {
>  		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067:
>  		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072:
> +		case USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2:
>  			if (*rsize >= 122 && rdesc[115] == 0xff && rdesc[116] == 0x7f
>  					&& rdesc[120] == 0xff && rdesc[121] == 0x7f) {
>  				hid_info(hdev, "Fixing up report descriptor\n");
> @@ -74,6 +76,8 @@ static const struct hid_device_id holtek_mouse_devices[] = {
>  			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
>  			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
> +			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2) },

You also need entry in hid_have_special_driver[] to make sure that 
hid-core doesn't override hid-holtek-mouse.

Could you please fix that and resend? Thanks.

>  	{ }
>  };
>  MODULE_DEVICE_TABLE(hid, holtek_mouse_devices);
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 25cd674..c7b36ad 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -479,6 +479,7 @@
>  #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A070	0xa070
>  #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A072	0xa072
>  #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
> +#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2	0xa0c2
>  #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
>  
>  #define USB_VENDOR_ID_IMATION		0x0718
> -- 
> 1.8.5.5
> 

-- 
Jiri Kosina
SUSE Labs
