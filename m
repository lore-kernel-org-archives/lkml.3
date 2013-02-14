Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161077Ab3BNW4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:56:04 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62468 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030277Ab3BNW4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:56:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OU4EU8iFtHoSUZrdH8D3n
Date: Thu, 14 Feb 2013 14:55:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH 7/9] remoteproc: omap: depend on OMAP_MBOX_FWK
Message-ID: <20130214225557.GI11362@atomide.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360882071-4072668-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130214 14:51]:
> Patch a62a6e98 "ARM: OMAP2+: Disable code that currently does not work
> with multiplaform" makes the OMAP_MBOX_FWK option depend on !MULTIPLATFORM,
> which means we cannot simply select that symbol from OMAP_REMOTEPROC.
> 
> Turning the 'select' into 'depends on' ensures that all dependencies
> are correct until OMAP_MBOX_FWK loses its dependency.
> 
> Without this patch, building allmodconfig results in:
> 
> drivers/remoteproc/omap_remoteproc.c:31:26: fatal error: plat/mailbox.h: No such file or directory
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tony Lindgren <tony@atomide.com>

> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/remoteproc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index 0b24108..cc1f7bf 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -12,8 +12,8 @@ config OMAP_REMOTEPROC
>  	depends on HAS_DMA
>  	depends on ARCH_OMAP4
>  	depends on OMAP_IOMMU
> +	depends on OMAP_MBOX_FWK
>  	select REMOTEPROC
> -	select OMAP_MBOX_FWK
>  	select RPMSG
>  	help
>  	  Say y here to support OMAP's remote processors (dual M3
> -- 
> 1.8.1.2
> 
