Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3HMFLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:11:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47950 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3HMFLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:11:17 -0400
X-Auth-Info: 7hY2WqoQmu1Ol7/rvCD3QU07vpfGcYyN/rwSU5IVNGQ=
From: Marek Vasut <marex@denx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/4] mtd: m25p80: Pass flags through CAT25_INFO macro
Date: Mon, 12 Aug 2013 22:07:03 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        kernel@pengutronix.de
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de> <1376302946-11534-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1376302946-11534-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201308122207.04080.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sascha Hauer,

> The flags may have to be overwritten, so add them to the CAT25_INFO
> macro.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/mtd/devices/m25p80.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> index 2f3d2a5..75d4391 100644
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> @@ -694,13 +694,13 @@ struct flash_info {
>  		.flags = (_flags),					\
>  	})
> 
> -#define CAT25_INFO(_sector_size, _n_sectors, _page_size, _addr_width)	
\
> +#define CAT25_INFO(_sector_size, _n_sectors, _page_size, _addr_width,
> _flags)	\ ((kernel_ulong_t)&(struct flash_info) {				
\
>  		.sector_size = (_sector_size),				\
>  		.n_sectors = (_n_sectors),				\
>  		.page_size = (_page_size),				\
>  		.addr_width = (_addr_width),				\
> -		.flags = M25P_NO_ERASE,					\
> +		.flags = (_flags),					\
>  	})
> 
>  /* NOTE: double check command sets and memory organization when you add
> @@ -732,7 +732,7 @@ static const struct spi_device_id m25p_ids[] = {
>  	{ "en25qh256", INFO(0x1c7019, 0, 64 * 1024, 512, 0) },
> 
>  	/* Everspin */
> -	{ "mr25h256", CAT25_INFO(  32 * 1024, 1, 256, 2) },
> +	{ "mr25h256", CAT25_INFO(  32 * 1024, 1, 256, 2, M25P_NO_ERASE) },
> 
>  	/* GigaDevice */
>  	{ "gd25q32", INFO(0xc84016, 0, 64 * 1024,  64, SECT_4K) },
> @@ -846,11 +846,11 @@ static const struct spi_device_id m25p_ids[] = {
>  	{ "w25q256", INFO(0xef4019, 0, 64 * 1024, 512, SECT_4K) },
> 
>  	/* Catalyst / On Semiconductor -- non-JEDEC */
> -	{ "cat25c11", CAT25_INFO(  16, 8, 16, 1) },
> -	{ "cat25c03", CAT25_INFO(  32, 8, 16, 2) },
> -	{ "cat25c09", CAT25_INFO( 128, 8, 32, 2) },
> -	{ "cat25c17", CAT25_INFO( 256, 8, 32, 2) },
> -	{ "cat25128", CAT25_INFO(2048, 8, 64, 2) },
> +	{ "cat25c11", CAT25_INFO(  16, 8, 16, 1, M25P_NO_ERASE) },
> +	{ "cat25c03", CAT25_INFO(  32, 8, 16, 2, M25P_NO_ERASE) },
> +	{ "cat25c09", CAT25_INFO( 128, 8, 32, 2, M25P_NO_ERASE) },
> +	{ "cat25c17", CAT25_INFO( 256, 8, 32, 2, M25P_NO_ERASE) },
> +	{ "cat25128", CAT25_INFO(2048, 8, 64, 2, M25P_NO_ERASE) },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(spi, m25p_ids);

I can't say I like the growing macro magic (voodoo?) in this file, but your 
patch doesn't break anything and I don't feel like reworking this, so:

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
