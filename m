Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaC1KPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:15:50 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51377 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaC1KPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:15:47 -0400
Date: Fri, 28 Mar 2014 11:15:17 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Michele Baldessari <michele@acksyn.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ftdi_sio: add id for Brainboxes VX-001
 ExpressCard
Message-ID: <20140328101517.GC22587@localhost>
References: <1395774051-22470-1-git-send-email-michele@acksyn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395774051-22470-1-git-send-email-michele@acksyn.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 07:00:51PM +0000, Michele Baldessari wrote:
> Custom VID/PID for Brainboxes VX-001 ExpressCard RS232 as reported in
> https://bugzilla.redhat.com/show_bug.cgi?id=1071914

Thanks for the patch. 

How about including the other PIDs listed in the report (in the attached
udev-rule) as well?
 
> Signed-off-by: Michele Baldessari <michele@acksyn.org>
> ---
>  drivers/usb/serial/ftdi_sio.c     | 2 ++
>  drivers/usb/serial/ftdi_sio_ids.h | 7 +++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index 44ab12986805..bf72063d6f48 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -909,6 +909,8 @@ static const struct usb_device_id id_table_combined[] = {
>  	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
>  	/* Cressi Devices */
>  	{ USB_DEVICE(FTDI_VID, FTDI_CRESSI_PID) },
> +	/* Brainbox Devices */
> +	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_001_PID) },
>  	{ }					/* Terminating entry */
>  };
>  
> diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> index e599fbfcde5f..ae842a203371 100644
> --- a/drivers/usb/serial/ftdi_sio_ids.h
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
> @@ -1326,3 +1326,10 @@
>   * Manufacturer: Cressi
>   */
>  #define FTDI_CRESSI_PID		0x87d0
> +
> +/*
> + * Product: ExpressCard 1 Port RS2323
> + * Manufacturer: Brainboxes
> + */

Could you just make this a "Brainboxes devices"-header and then list any
product in a comment following the PID instead? That would "scale"
better when adding more Brainboxes PIDs.

> +#define BRAINBOXES_VID		0x05d1
> +#define BRAINBOXES_VX_001_PID	0x1001

That is, something like:

/*
 * Brainboxes devices
 */
#define BRAINBOXES_VID		0x05d1
#define BRAINBOXES_VX_001_PID	0x1001	/* ExpressCard 1 Port RS2323 */

Thanks,
Johan
