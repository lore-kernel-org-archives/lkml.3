Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaJJJhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:37:35 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:57406 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaJJJhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:37:33 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 10 Oct 2014 11:34:43 +0200
From: Johan Hovold <johan@kernel.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
Message-ID: <20141010093443.GD12494@localhost>
References: <1412930694-28769-1-git-send-email-frans.klaver@xsens.com>
 <1412933547-10906-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412933547-10906-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:32:27AM +0200, Frans Klaver wrote:
> Add new IDs for the Xsens Awinda Station and Awinda Dongle.
> 
> While at it, order the definitions by PID and add a logical separation
> between devices using Xsens' VID and those using FTDI's VID.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/usb/serial/ftdi_sio.c     | 2 ++
>  drivers/usb/serial/ftdi_sio_ids.h | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index dc72b92..e4eccb6 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -661,6 +661,8 @@ static const struct usb_device_id id_table_combined[] = {
>  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
>  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
>  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
> +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
> +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },

These are still not in alphabetical order. :)

>  	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
>  	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
>  	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
> diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> index 5937b2d..b68084c 100644
> --- a/drivers/usb/serial/ftdi_sio_ids.h
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
> @@ -143,8 +143,12 @@
>   * Xsens Technologies BV products (http://www.xsens.com).
>   */
>  #define XSENS_VID		0x2639
> -#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
> +#define XSENS_AWINDA_STATION_PID 0x0101
> +#define XSENS_AWINDA_DONGLE_PID 0x0102
>  #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
> +#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
> +
> +/* Xsens devices using FTDI VID */
>  #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
>  #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
>  #define XSENS_CONVERTER_2_PID	0xD38A

Looks good otherwise.

Thanks,
Johan
