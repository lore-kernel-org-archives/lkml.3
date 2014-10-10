Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaJJJEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:04:10 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64994 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaJJJEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:04:06 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 10 Oct 2014 11:01:17 +0200
From: Johan Hovold <johan@kernel.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
Message-ID: <20141010090117.GA12494@localhost>
References: <1412930694-28769-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412930694-28769-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:44:54AM +0200, Frans Klaver wrote:
> Add new IDs for the Xsens Awinda Station and Awinda Dongle.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/usb/serial/ftdi_sio.c     | 2 ++
>  drivers/usb/serial/ftdi_sio_ids.h | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index dc72b92..4969875 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -663,6 +663,8 @@ static const struct usb_device_id id_table_combined[] = {
>  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
>  	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
>  	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
> +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
> +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },

Could you keep the XSENS_VID entries sorted alphabetically here?

>  	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
>  	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
>  	{ USB_DEVICE(FTDI_VID, FTDI_ACTIVE_ROBOTS_PID) },
> diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> index 5937b2d..be3fffe 100644
> --- a/drivers/usb/serial/ftdi_sio_ids.h
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
> @@ -145,6 +145,8 @@
>  #define XSENS_VID		0x2639
>  #define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
>  #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
> +#define XSENS_AWINDA_STATION_PID 0x0101
> +#define XSENS_AWINDA_DONGLE_PID 0x0102

And sorted by PID here (even though the two current entries are not, you
could reorder them as well).

I noticed that the below PIDs use the FTDI VID. Perhaps a comment or at
least a separating empty line would be appropriate.

>  #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
>  #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
>  #define XSENS_CONVERTER_2_PID	0xD38A

Thanks,
Johan
