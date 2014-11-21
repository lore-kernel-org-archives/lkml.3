Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaKUSNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:13:24 -0500
Received: from lists.s-osg.org ([54.187.51.154]:55330 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaKUSNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:13:22 -0500
Date: Fri, 21 Nov 2014 16:13:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andreas Ruprecht <rupran@einserver.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] media: pci: smipcie: Fix dependency for DVB_SMIPCIE
Message-ID: <20141121161316.23963dc5@recife.lan>
In-Reply-To: <1416592319-23644-1-git-send-email-rupran@einserver.de>
References: <1416592319-23644-1-git-send-email-rupran@einserver.de>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 21 Nov 2014 18:51:59 +0100
Andreas Ruprecht <rupran@einserver.de> escreveu:

> In smipcie.c, the function i2c_bit_add_bus() is called. This
> function is defined by the I2C bit-banging interfaces enabled
> with CONFIG_I2C_ALGOBIT.
> 
> As there was no dependency in Kconfig, CONFIG_I2C_ALGOBIT could
> be set to "m" while CONFIG_DVB_SMIPCIE was set to "y", resulting
> in a build error due to an undefined reference. This patch adds
> the dependency on CONFIG_I2C_ALGOBIT in Kconfig.
> 
> Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> ---
>  drivers/media/pci/smipcie/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
> index 75a2992..c728721 100644
> --- a/drivers/media/pci/smipcie/Kconfig
> +++ b/drivers/media/pci/smipcie/Kconfig
> @@ -1,6 +1,6 @@
>  config DVB_SMIPCIE
>  	tristate "SMI PCIe DVBSky cards"
> -	depends on DVB_CORE && PCI && I2C
> +	depends on DVB_CORE && PCI && I2C && I2C_ALGOBIT

IMHO, the best would be, instead, to select I2C_ALGOBIT.

>  	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
>  	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
>  	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
