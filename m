Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaEVIT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:19:28 -0400
Received: from afflict.kos.to ([92.243.29.197]:40600 "EHLO afflict.kos.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaEVITZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:19:25 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2014 04:19:25 EDT
Date: Thu, 22 May 2014 11:12:02 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RESEND] mmc: dove: fix missing MACH_DOVE dependency
Message-ID: <20140522081202.GA21151@afflict.kos.to>
References: <1400522571-10799-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400522571-10799-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014@08:02:51PM +0200, Sebastian Hesselbarth wrote:
> DT-enabled Dove moved over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE Kconfig. This slipped through the cracks and now is
> a fix to allow to build Dove's SDHCI driver for mach-mvebu on v3.15-rc.

Dove cubox has usually rootfs on mmc, so this patch is very much needed
for using multiplatform kernel on dove cubox.

Tested-by: Riku Voipio <riku.voipio@iki.fi>

> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Acked-by: Jason Cooper <jason@lakedaemon.net>
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
