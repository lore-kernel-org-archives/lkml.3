Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaCTHa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:30:27 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63457 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaCTHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:30:25 -0400
Date: Thu, 20 Mar 2014 00:30:21 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DCG_UPD_stlinux_kernel@list.st.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, Angus.Clark@st.com
Subject: Re: [PATCH 11/35] mtd: st_spi_fsm: Use device size to determine
 address width
Message-ID: <20140320073021.GC31517@norris-Latitude-E6410>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
 <1392735362-1245-12-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392735362-1245-12-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:55:38PM +0000, Lee Jones wrote:
> Take some known parameters, namely size and number of sectors and use
> them to determine weather a device can support 32bit addressing or not.
> If it can, set the associated flash capability flag for latter use.
> 
> Acked-by Angus Clark <angus.clark@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/devices/st_spi_fsm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index 68fa12e..1d7a13a0 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -670,6 +670,10 @@ static int stfsm_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	fsm->info = info;
>  
> +	/* Use device size to determine address width */
> +	if (info->sector_size * info->n_sectors > 0xFFFFFF)

Shouldn't you compare:

	if (info->sector_size * info->n_sectors > 0x1000000)

?

A device of size 0x1000000 can be addressed completely with only the
lower 24 bits.

> +		info->flags |= FLASH_FLAG_32BIT_ADDR;
> +
>  	platform_set_drvdata(pdev, fsm);
>  
>  	fsm->mtd.dev.parent	= &pdev->dev;

Brian
