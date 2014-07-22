Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbaGVX1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:27:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaGVX1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:27:48 -0400
Date: Tue, 22 Jul 2014 16:27:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH v3] Lattice ECP3 FPGA: Correct endianness
Message-ID: <20140722232748.GA19112@kroah.com>
References: <CAL8zT=jfAPG3P7FW1Akp1Q2pbji=Vt_6jUJJzCFvp8F2uBs+fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8zT=jfAPG3P7FW1Akp1Q2pbji=Vt_6jUJJzCFvp8F2uBs+fg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 07:00:37PM +0200, Jean-Michel Hautbois wrote:
> This code corrects endianness and avoids a sparse error.
> Tested with Lattice ECP3-35 with Freescale i.MX6.
> It also sends uevent in order to load it.
> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  drivers/misc/lattice-ecp3-config.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/misc/lattice-ecp3-config.c
> b/drivers/misc/lattice-ecp3-config.c
> index bb26f08..f77ff4b 100644
> --- a/drivers/misc/lattice-ecp3-config.c
> +++ b/drivers/misc/lattice-ecp3-config.c
> @@ -16,6 +16,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/platform_device.h>
>  #include <linux/delay.h>
> +#include <asm/unaligned.h>
> 
>  #define FIRMWARE_NAME  "lattice-ecp3.bit"
> 
> @@ -92,8 +93,8 @@ static void firmware_load(const struct firmware *fw,
> void *context)
>         /* Trying to speak with the FPGA via SPI... */
>         txbuf[0] = FPGA_CMD_READ_ID;
>         ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
> -       dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
> -       jedec_id = *(u32 *)&rxbuf[4];
> +       jedec_id = get_unaligned_be32(&rxbuf[4]);
> +       dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", jedec_id);

All tabs are converted to spaces, making this patch impossible to apply
:(


Can you fix that up and resend?

thanks,

greg k-h
