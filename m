Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaBBNP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 08:15:27 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:32857 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaBBNPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 08:15:10 -0500
Date: Sun, 2 Feb 2014 14:15:18 +0100
From: Johan Hovold <johan@hovold.com>
To: Ulrich Hahn <uhahn@eanco.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ..another device for the ftdi_sio driver, 3rd infusion
Message-ID: <20140202131518.GA27835@localhost>
References: <1391339456.31834.1@biblenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391339456.31834.1@biblenovo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 12:10:56PM +0100, Ulrich Hahn wrote:

Please use a more descriptive subject line (which will end up as the
commit log summary), e.g.

	"[PATCH v3] USB: ftdi_sio: add Tagsys RFID Reader ids"

Note that the patch version should go in the [PATCH vX] (which will not
show up in the git log).

You should also consider adding a slightly more verbose message in the
body as well (e.g. mentioning which two devices you add support for).
Right now your commit log would be empty.

> Signed-off-by: Ulrich Hahn <uhahn@eanco.de>
> 
> diff -ur linux-3.13.1/drivers/usb/serial/ftdi_sio.c linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio.c
> --- linux-3.13.1/drivers/usb/serial/ftdi_sio.c	2014-01-29 14:06:37.000000000 +0100
> +++ linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio.c	2014-02-02 11:57:08.625914749 +0100
> @@ -192,6 +192,8 @@
>  	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
>  	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
>  	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
> +	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
> +	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
>  	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
>  	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
>  	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
> Only in linux-3.13.1+tagsys/drivers/usb/serial: ftdi_sio.c.orig
> diff -ur linux-3.13.1/drivers/usb/serial/ftdi_sio_ids.h linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio_ids.h
> --- linux-3.13.1/drivers/usb/serial/ftdi_sio_ids.h	2014-01-29 14:06:37.000000000 +0100
> +++ linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio_ids.h	2014-02-02 11:57:08.629914782 +0100
> @@ -363,6 +363,13 @@
>  /* Sprog II (Andrew Crosland's SprogII DCC interface) */
>  #define FTDI_SPROG_II		0xF0C8
>  
> +/*
> + * Tagsys RFID Readers
> + * survey (two of them) by Ulrich Hahn

No need to include the author in the comment. It will be apparent from
the git log.

> + */
> +#define FTDI_TAGSYS_LP101_PID	0xF0E9	/* Tagsys L-P101 RFID*/
> +#define FTDI_TAGSYS_P200X_PID	0xF0EE	/* Tagsys Medio P200x RFID*/
> +
>  /* an infrared receiver for user access control with IR tags */
>  #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */

Thanks,
Johan
