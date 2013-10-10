Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3JJIDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:03:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab3JJIDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:03:03 -0400
Date: Thu, 10 Oct 2013 10:02:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Elias Vanderstuyft <elias.vds@gmail.com>,
        =?ISO-8859-15?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>
Subject: Re: [PATCH 2/3] HID:hid-lg: Fixed Report Descriptor for Logitech
 MOMO Force (Black) to split Accel/Brake into seperate axis
In-Reply-To: <1381363487-2167-2-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1310101002120.13289@pobox.suse.cz>
References: <1381363487-2167-1-git-send-email-simon@mungewell.org> <1381363487-2167-2-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Oct 2013, Simon Wood wrote:

> 
> Signed-off-by: Simon Wood <simon@mungewell.org>

Simon,

thanks for the series. I however very much dislike commits without a 
single line of changelog ... could you please resend the series with a few 
sentences as a patch description (i.e. what, why, how).

Thanks a lot.

> ---
>  drivers/hid/hid-lg.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
> index c6efdae..545da44 100644
> --- a/drivers/hid/hid-lg.c
> +++ b/drivers/hid/hid-lg.c
> @@ -47,6 +47,7 @@
>  #define DFP_RDESC_ORIG_SIZE	97
>  #define FV_RDESC_ORIG_SIZE	130
>  #define MOMO_RDESC_ORIG_SIZE	87
> +#define MOMO2_RDESC_ORIG_SIZE	87
>  
>  /* Fixed report descriptors for Logitech Driving Force (and Pro)
>   * wheel controllers
> @@ -284,6 +285,54 @@ static __u8 momo_rdesc_fixed[] = {
>  0xC0                /*  End Collection                      */
>  };
>  
> +static __u8 momo2_rdesc_fixed[] = {
> +0x05, 0x01,         /*  Usage Page (Desktop),               */
> +0x09, 0x04,         /*  Usage (Joystik),                    */
> +0xA1, 0x01,         /*  Collection (Application),           */
> +0xA1, 0x02,         /*      Collection (Logical),           */
> +0x95, 0x01,         /*          Report Count (1),           */
> +0x75, 0x0A,         /*          Report Size (10),           */
> +0x15, 0x00,         /*          Logical Minimum (0),        */
> +0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),     */
> +0x35, 0x00,         /*          Physical Minimum (0),       */
> +0x46, 0xFF, 0x03,   /*          Physical Maximum (1023),    */
> +0x09, 0x30,         /*          Usage (X),                  */
> +0x81, 0x02,         /*          Input (Variable),           */
> +0x95, 0x0A,         /*          Report Count (10),          */
> +0x75, 0x01,         /*          Report Size (1),            */
> +0x25, 0x01,         /*          Logical Maximum (1),        */
> +0x45, 0x01,         /*          Physical Maximum (1),       */
> +0x05, 0x09,         /*          Usage Page (Button),        */
> +0x19, 0x01,         /*          Usage Minimum (01h),        */
> +0x29, 0x0A,         /*          Usage Maximum (0Ah),        */
> +0x81, 0x02,         /*          Input (Variable),           */
> +0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),         */
> +0x09, 0x00,         /*          Usage (00h),                */
> +0x95, 0x04,         /*          Report Count (4),           */
> +0x81, 0x02,         /*          Input (Variable),           */
> +0x95, 0x01,         /*          Report Count (1),           */
> +0x75, 0x08,         /*          Report Size (8),            */
> +0x26, 0xFF, 0x00,   /*          Logical Maximum (255),      */
> +0x46, 0xFF, 0x00,   /*          Physical Maximum (255),     */
> +0x09, 0x01,         /*          Usage (01h),                */
> +0x81, 0x02,         /*          Input (Variable),           */
> +0x05, 0x01,         /*          Usage Page (Desktop),       */
> +0x09, 0x31,         /*          Usage (Y),                  */
> +0x81, 0x02,         /*          Input (Variable),           */
> +0x09, 0x32,         /*          Usage (Z),                  */
> +0x81, 0x02,         /*          Input (Variable),           */
> +0x06, 0x00, 0xFF,   /*          Usage Page (FF00h),         */
> +0x09, 0x00,         /*          Usage (00h),                */
> +0x81, 0x02,         /*          Input (Variable),           */
> +0xC0,               /*      End Collection,                 */
> +0xA1, 0x02,         /*      Collection (Logical),           */
> +0x09, 0x02,         /*          Usage (02h),                */
> +0x95, 0x07,         /*          Report Count (7),           */
> +0x91, 0x02,         /*          Output (Variable),          */
> +0xC0,               /*      End Collection,                 */
> +0xC0                /*  End Collection                      */
> +};
> +
>  /*
>   * Certain Logitech keyboards send in report #3 keys which are far
>   * above the logical maximum described in descriptor. This extends
> @@ -343,6 +392,15 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  		}
>  		break;
>  
> +	case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2:
> +		if (*rsize == MOMO2_RDESC_ORIG_SIZE) {
> +			hid_info(hdev,
> +				"fixing up Logitech Momo Racing Force (Black) report descriptor\n");
> +			rdesc = momo2_rdesc_fixed;
> +			*rsize = sizeof(momo2_rdesc_fixed);
> +		}
> +		break;
> +
>  	case USB_DEVICE_ID_LOGITECH_VIBRATION_WHEEL:
>  		if (*rsize == FV_RDESC_ORIG_SIZE) {
>  			hid_info(hdev,
> -- 
> 1.8.1.2
> 

-- 
Jiri Kosina
SUSE Labs
