Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaE0VYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:24:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23122 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaE0VYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:24:49 -0400
Date: Wed, 28 May 2014 00:24:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcin Kostrzewa <marckostrzewa@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fred Akers <knivey@botops.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove duplicated comment and fix brace placement in
 drivers/staging/comedi/drivers/addi-data/hwdrv_acpi3501.c
Message-ID: <20140527212424.GS15585@mwanda>
References: <1401200257-790-1-git-send-email-marckostrzewa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401200257-790-1-git-send-email-marckostrzewa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject should be:

[PATCH] Staging: comedi: addi-data: <short title. clean up else statement>



On Tue, May 27, 2014 at 02:17:35PM +0000, Marcin Kostrzewa wrote:
> Signed-off-by: Marcin Kostrzewa <marckostrzewa@gmail.com>
> ---
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
> index 20e89b0..8add8d8 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
> @@ -104,9 +104,7 @@ static int apci3501_write_insn_timer(struct comedi_device *dev,
>  			outl(ul_Command1, dev->iobase + APCI3501_TIMER_CTRL_REG);
>  		}
>  
> -		else if (data[1] == 0)	/* Stop The Watchdog */
> -		{
> -			/* Stop The Watchdog */
> +		else if (data[1] == 0) { /* Stop The Watchdog */


While you're at it, could you also move it like this:

		} else if (data[1] == 0) { /* Stop The Watchdog */

(I wouldn't have asked you to do this, except that you need to resend
anyway with a fixed subject line).

regards,
dan carpenter

>  			ul_Command1 = inl(dev->iobase + APCI3501_TIMER_CTRL_REG);
>  			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
>  			outl(0x0, dev->iobase + APCI3501_TIMER_CTRL_REG);
> -- 
> 1.9.2
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
