Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaESSSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:18:05 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:48051 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaESSSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:18:03 -0400
Date: Mon, 19 May 2014 20:14:47 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] mmc: dove: fix missing MACH_DOVE dependency
Message-ID: <20140519181447.GA7824@lunn.ch>
References: <1400522571-10799-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400522571-10799-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 08:02:51PM +0200, Sebastian Hesselbarth wrote:
> DT-enabled Dove moved over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE Kconfig. This slipped through the cracks and now is
> a fix to allow to build Dove's SDHCI driver for mach-mvebu on v3.15-rc.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Acked-by: Jason Cooper <jason@lakedaemon.net>

Tested-by: Andrew Lunn <andrew@lunn.ch>

Thanks Sebastian

       Andrew

> ---
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mmc/host/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 8aaf8c1f3f63..37665553ef33 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -168,7 +168,7 @@ config MMC_SDHCI_ESDHC_IMX
>  
>  config MMC_SDHCI_DOVE
>  	tristate "SDHCI support on Marvell's Dove SoC"
> -	depends on ARCH_DOVE
> +	depends on ARCH_DOVE || MACH_DOVE
>  	depends on MMC_SDHCI_PLTFM
>  	select MMC_SDHCI_IO_ACCESSORS
>  	help
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
