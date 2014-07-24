Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbaGXL1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:27:43 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:58128 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756908AbaGXL1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:27:42 -0400
Message-ID: <1406201260.20036.28.camel@x220>
Subject: Re: [PATCH 10/28] phy: add hix5hd2-sata-phy driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Jul 2014 13:27:40 +0200
In-Reply-To: <1406026611-30493-11-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
	 <1406026611-30493-11-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2014 11:27:40.0634 (UTC) FILETIME=[4778DBA0:01CFA732]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 16:26 +0530, Kishon Vijay Abraham I wrote:
> From: Jiancheng Xue <xuejiancheng@huawei.com>
> 
> Add hix5hd2-sata-phy driver on Hisilicon hix5hd2 soc.
> 
> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---

This landed as commit e379413a346c in today's linux-next (ie,
next-20140724). 

>  drivers/phy/Kconfig            |    8 ++
>  drivers/phy/Makefile           |    1 +
>  drivers/phy/phy-hix5hd2-sata.c |  192 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 201 insertions(+)
>  create mode 100644 drivers/phy/phy-hix5hd2-sata.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 64b98d2..30c82fc 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -109,6 +109,14 @@ config PHY_EXYNOS5250_SATA
>  	  SATA 3.0 Gb/s, SATA 6.0 Gb/s speeds. It supports one SATA host
>  	  port to accept one SATA device.
>  
> +config PHY_HIX5HD2_SATA
> +	tristate "HIX5HD2 SATA PHY Driver"
> +	depends on ARCH_HIX5HD2 && OF && HAS_IOMEM
> +	select GENERIC_PHY
> +	select MFD_SYSCON
> +	help
> +	  Support for SATA PHY on Hisilicon hix5hd2 Soc.
> +
>  config PHY_SUN4I_USB
>  	tristate "Allwinner sunxi SoC USB PHY driver"
>  	depends on ARCH_SUNXI && HAS_IOMEM && OF

Apparently the code to add ARCH_HIX5HD2 is still pending. (I already
asked about that symbol in https://lkml.org/lkml/2014/6/19/99 .)

So currently this driver won't get build testing through linux-next.
Perhaps this entry could optionally depend on COMPILE_TEST, if build
testing is wanted, that is. (I assume there are ate least build robots
using COMPILE_TEST. Is that correct?)


Paul Bolle

