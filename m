Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab3BGOC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:02:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab3BGOCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:02:55 -0500
Date: Thu, 7 Feb 2013 12:01:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, perex@perex.cz, sameo@linux.intel.com,
        tiwai@suse.de, w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH 09/15] drivers/media: add missing GENERIC_HARDIRQS
 dependencies
Message-ID: <20130207120117.463faa3a@redhat.com>
In-Reply-To: <1360167843-3587-10-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
	<1360167843-3587-10-git-send-email-heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed,  6 Feb 2013 17:23:57 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> escreveu:

> The SuperH VEU mem2mem video processing driver (VIDEO_SH_VEU)
> calls devm_request_threaded_irq() and therefore should depend
> on GENERIC_HARDIRQS.
> Texas Instruments WL1273 I2C FM Radio (RADIO_WL1273) selects
> MFD_CORE, which itself depends on GENERIC_HARDIRQS.
> So add the dependency to the TI driver as well.
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/media/platform/Kconfig |    2 +-
>  drivers/media/radio/Kconfig    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 05d7b63..a0639e7 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -204,7 +204,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
>  
>  config VIDEO_SH_VEU
>  	tristate "SuperH VEU mem2mem video processing driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2
> +	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	help
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index ead9928..24e64a0 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -192,7 +192,7 @@ config RADIO_TIMBERDALE
>  
>  config RADIO_WL1273
>  	tristate "Texas Instruments WL1273 I2C FM Radio"
> -	depends on I2C && VIDEO_V4L2
> +	depends on I2C && VIDEO_V4L2 && GENERIC_HARDIRQS
>  	select MFD_CORE
>  	select MFD_WL1273_CORE
>  	select FW_LOADER


-- 

Cheers,
Mauro
