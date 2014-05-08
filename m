Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaEHSqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:46:15 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:62862 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705AbaEHSqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:46:13 -0400
Message-ID: <1399574770.4085.7.camel@x220>
Subject: Re: [PATCH 2/2] phy: exynos: fix SATA phy license typo
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Date: Thu, 08 May 2014 20:46:10 +0200
In-Reply-To: <1399560433-1402630-4-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	 <1399560433-1402630-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 May 2014 18:46:10.0940 (UTC) FILETIME=[C7D433C0:01CF6AED]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 16:46 +0200, Arnd Bergmann wrote:
> If the license string doesn't match exactly, the module refuses
> to load.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> ---
>  drivers/phy/phy-exynos5250-sata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
> index c9361b7..0568945 100644
> --- a/drivers/phy/phy-exynos5250-sata.c
> +++ b/drivers/phy/phy-exynos5250-sata.c
> @@ -246,6 +246,6 @@ static struct platform_driver exynos_sata_phy_driver = {
>  module_platform_driver(exynos_sata_phy_driver);
>  
>  MODULE_DESCRIPTION("Samsung SerDes PHY driver");
> -MODULE_LICENSE("GPL V2");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
>  MODULE_AUTHOR("Yuvaraj C D <yuvaraj.cd@samsung.com>");

A bit of grepping the tree showed me
    Documentation/blackfin/gptimers-example.c:83:MODULE_LICENSE("BSD");
    drivers/dma/dma-jz4740.c:617:MODULE_LICENSE("GPLv2");
    drivers/input/misc/sirfsoc-onkey.c:216:MODULE_LICENSE("GPLv2");
    drivers/pci/host/pci-mvebu.c:1042:MODULE_LICENSE("GPLv2");
    drivers/pci/host/pci-tegra.c:1719:MODULE_LICENSE("GPLv2");
    drivers/power/reset/restart-poweroff.c:65:MODULE_LICENSE("GPLv2");

It seems these need to be changed too. But, except for dma-jz4740.c,
these are all files that can't be built as (part of) a module. Which
explains why no one noticed. Maybe I'll submit some trivial patches, in
a few days, to clean this up.


Paul Bolle

