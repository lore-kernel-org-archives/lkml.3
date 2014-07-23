Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbaGWX6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:58:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbaGWX6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:58:51 -0400
Date: Wed, 23 Jul 2014 16:58:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH v4] Lattice ECP3 FPGA: Correct endianness
Message-ID: <20140723235850.GA1241@kroah.com>
References: <CAL8zT=g5aO1aNbADQ9Usv6J952D5t8_NvmDozTjvtczq-BGbrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8zT=g5aO1aNbADQ9Usv6J952D5t8_NvmDozTjvtczq-BGbrw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:39:35AM +0200, Jean-Michel Hautbois wrote:
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
> index bb26f08..2c86319 100644
> --- a/drivers/misc/lattice-ecp3-config.c
> +++ b/drivers/misc/lattice-ecp3-config.c
> @@ -16,6 +16,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/platform_device.h>
>  #include <linux/delay.h>
> +#include <asm/unaligned.h>
> 
>  #define FIRMWARE_NAME    "lattice-ecp3.bit"
> 
> @@ -92,8 +93,8 @@ static void firmware_load(const struct firmware *fw,
> void *context)
>      /* Trying to speak with the FPGA via SPI... */
>      txbuf[0] = FPGA_CMD_READ_ID;
>      ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
> -    dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
> -    jedec_id = *(u32 *)&rxbuf[4];
> +    jedec_id = get_unaligned_be32(&rxbuf[4]);
> +    dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", jedec_id);

Your email client ate all the tabs and spit out spaces and then
line-wrapped the patch, making it impossible to apply :(

Can you fix it up and resend it in a format we can use?

thanks,

greg k-h
