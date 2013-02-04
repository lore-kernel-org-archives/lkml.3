Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3BDM7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:59:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50235 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3BDM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:59:29 -0500
Date: Mon, 4 Feb 2013 15:59:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, devel@driverdev.osuosl.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] staging/xgifb: Remove unnecessary bitshifts in
 XGI_SetCRT1ModeRegs
Message-ID: <20130204125901.GH4937@mwanda>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
 <1359928479-8484-8-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359928479-8484-8-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 10:54:37PM +0100, Peter Huewe wrote:
> Since data can only be 0x0000, 0x0035 or 0x0048 we can simply skip the
> bit shifting and masking as data & 0xFF is always equal to data and
> data & 0xFF00 is always 0.
> So we simply use data and 0 directly and save the assignment.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/staging/xgifb/vb_setmode.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
> index 6f366f4..1ff1178 100644
> --- a/drivers/staging/xgifb/vb_setmode.c
> +++ b/drivers/staging/xgifb/vb_setmode.c
> @@ -1083,10 +1083,8 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
>  			data = 0x0048;
>  	}
>  
> -	data2 = data & 0x00FF;
> -	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFF, data2);
> -	data2 = (data & 0xFF00) >> 8;
> -	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFC, data2);
> +	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFF, data);
> +	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFC, 0);

This patch is fine.

This is a fairly common pattern where people do:

	write_a_char(data & 0xff);
	write_a_char((data >> 8) & 0xff);

It feels there should be a macro to do the shift and mask but I'm
not sure what it would look like.

regards,
dan carpenter

