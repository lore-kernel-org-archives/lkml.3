Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbaEPSPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:15:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54838 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061AbaEPSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:15:13 -0400
Date: Fri, 16 May 2014 14:10:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-wireless@vger.kernel.org, Kumar Amit Mehta <gmate.amit@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND] orinoco_usb: Fix broken firmware load error
 checking
Message-ID: <20140516181054.GF3431@tuxdriver.com>
References: <201405162001.59695.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201405162001.59695.linux@rainbow-software.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is already merged in wireless-next...

commit fe5d96246e9c4d266c4a8dca99f82ad82f2305b5
Author: Ondrej Zary <linux@rainbow-software.org>
Date:   Fri May 9 18:10:34 2014 +0200

    orinoco_usb: Fix broken firmware load error checking
    
    The check of ezusb_firmware_download() return value (added by commit
    488ec878034eccb852267b0e27ce9d511f75c587) is broken because
    ezusb_firmware_download() returns 1 on success.
    This causes the driver not to work with the following error:
    orinoco_usb: probe of 3-3:1.0 failed with error -14
    
    Check the return value only for negative values.
    
    This fix should be applied to -stable kernels too.
    
    Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

On Fri, May 16, 2014 at 08:01:59PM +0200, Ondrej Zary wrote:
> The check of ezusb_firmware_download() return value (added by commit
> 488ec878034eccb852267b0e27ce9d511f75c587) is broken because
> ezusb_firmware_download() returns 1 on success.
> This causes the driver not to work with the following error:
> orinoco_usb: probe of 3-3:1.0 failed with error -14
> 
> Check the return value only for negative values.
> 
> This fix should be applied to -stable kernels too.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/net/wireless/orinoco/orinoco_usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
> index f9805c9..1cbb783 100644
> --- a/drivers/net/wireless/orinoco/orinoco_usb.c
> +++ b/drivers/net/wireless/orinoco/orinoco_usb.c
> @@ -1687,7 +1687,7 @@ static int ezusb_probe(struct usb_interface *interface,
>  		firmware.code = fw_entry->data;
>  	}
>  	if (firmware.size && firmware.code) {
> -		if (ezusb_firmware_download(upriv, &firmware))
> +		if (ezusb_firmware_download(upriv, &firmware) < 0)
>  			goto error;
>  	} else {
>  		err("No firmware to download");
> -- 
> Ondrej Zary
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
