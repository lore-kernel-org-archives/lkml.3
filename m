Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaL2Gqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:46:49 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44167 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaL2Gqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:46:48 -0500
Date: Mon, 29 Dec 2014 12:16:39 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: ft1000-usb: ft1000_hw.c:  Fix a
 potential memory leak.
Message-ID: <20141229064639.GB3749@sudip-PC>
References: <1419705907-5937-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419705907-5937-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 07:45:07PM +0100, Rickard Strandqvist wrote:
> Avoid allocate memory if we will exit the function.
> 
> Was found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> index 2e13e7b..72b8f03 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> @@ -331,15 +331,15 @@ int card_send_command(struct ft1000_usb *ft1000dev, void *ptempbuffer,
>  
>  	DEBUG("card_send_command: enter card_send_command... size=%d\n", size);

this is not applying to next-20141226. your tree is not a current one. This DEBUG line was changed by patch "b5d8204d00fa3bcd1f3b4b060fb90675d00baee0"

thanks
sudip

>  
> +	ret = ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
> +	if (ret)
> +		return ret;
> +
>  	commandbuf = kmalloc(size + 2, GFP_KERNEL);
>  	if (!commandbuf)
>  		return -ENOMEM;
>  	memcpy((void *)commandbuf + 2, (void *)ptempbuffer, size);
>  
> -	ret = ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
> -	if (ret)
> -		return ret;
> -
>  	if (temp & 0x0100)
>  		usleep_range(900, 1100);
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
