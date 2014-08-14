Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaHNMQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:16:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9393 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaHNMQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:16:45 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6f-53eca8aa43f1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        zhenfu.fang@rock-chips.com, cf@rock-chips.com, lintao@rock-chips.com,
        chenfen@rock-chips.com, zyf@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yzq@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, zhangqing@rock-chips.com,
        hl@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: move rockchip related code to a separate file
Date: Thu, 14 Aug 2014 14:16:40 +0200
Message-id: <1436855.vkDg4bXI8B@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1408003293-27375-1-git-send-email-addy.ke@rock-chips.com>
References: <1406786498-3935-1-git-send-email-addy.ke@rock-chips.com>
 <1408003293-27375-1-git-send-email-addy.ke@rock-chips.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfSzUcRzHfe/3cD83p58LfdOKbrVGUlazb0/CVv1abWralD/o4hfW4XaH
	pfWHXU7ScITrPCuJy1OI0zw/jFG4lIcmxDLjLIvmoUXd3dr89/p83q/3Pv98KEwQR9hRoeGR
	rDRcJBaSPLxvc8bqiKZE73Nsq+04Kt5a5SBFwjyJ5tQ9BFIO1QOU39lPoA/FbSTq/vgCQyn6
	QgJtTS8QqGvhM47WqnoxVFuwiqH++VKARjfiCVSnWidRzpI/KowvwtHQuxwSdW6lAPRyRMdB
	vSPLJFKqynG0OK7CkaKpk4uWJnUY6i73RWkFApRbUUSiL6lj/1T9HIbifs9wUP6UFvNwYBRN
	SpIpyysDTHasDmeGkpM4TOmrFZKpKXFiqjWPSWZ8uJFkPvXICWZ0vpDD/MlqwZnkWg1g6ofz
	MGa5et9VSz/emSBWHBrNSo+63+KFtCx/40rGLe6tFKeRsSCFlwjMKUifgJPpuVwT28LBiUoy
	EfAoAa0C8Jn6Ddc0xHFgUlm60SLpUzD1kQYY2Jo+AKcX5YRBwugRAmo3eglDsJP2hj/avhoZ
	pw9CVXOZscynHWFO1UPj3oa+BLX1paSBzemLUB6fxDFdkwPYmFFMmApWcO3pBG5gjLaHzS0Z
	hImdYYsik1QCOmublrVNy9qmFQBMA2xYSaBEdjs4zNVFJgqTRYUHuwRGhFUD42/M2mlBaSxq
	BzQFhBZ8xm/BR0CIomUxYe0AUpjQmn89X+8j4AeJYu6z0ogAaZSYlbWDPRQu3MVvVZy+JqCD
	RZHsXZaVsNL/KYcyt4sFfpluKWpPgbih4pev7YMOn3AuUynujTS74uCd3H1ob+WdASXrlqA9
	vyqcdXW64OnfsF8rOXmDsp7aTHOccH8yqvZ6ndkUv/vsTa+BNOckXXa0GTXYM/99R12OziNA
	3tHwNiivde59n+1P7+VzgBWrLWtkzy1bD3ddtl/3GIvTjwlxWYjI1QmTykR/AY/oPUMXAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, August 14, 2014 04:01:33 PM Addy Ke wrote:
> To support HS200 and UHS-1, we need add a big hunk of code,
> as shown in the following patches. So a separate file for
> rockchip SOCs is suitable.
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/mmc/host/Kconfig           |   9 +++
>  drivers/mmc/host/Makefile          |   1 +
>  drivers/mmc/host/dw_mmc-pltfm.c    |  57 ---------------
>  drivers/mmc/host/dw_mmc-rockchip.c | 146 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 156 insertions(+), 57 deletions(-)
>  create mode 100644 drivers/mmc/host/dw_mmc-rockchip.c
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index a565254..ae61df6 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -621,6 +621,15 @@ config MMC_DW_PCI
>  
>  	  If unsure, say N.
>  
> +config MMC_DW_ROCKCHIP
> +	tristate "Rockchip specific extensions for Synopsys DW Memory Card Interface"
> +	depends on MMC_DW

While you are at it you may also add (in this or in incremental patch)
dependency on ARCH_ROCKCHIP so this driver becomes limited to Rockchip
architecture.

> +	select MMC_DW_PLTFM
> +	help
> +	  This selects support for Rockchip SoC specific extensions to the
> +	  Synopsys DesignWare Memory Card Interface driver. Select this option
> +	  for platforms based on RK3066, RK3188 and RK3288 SoC's.
> +
>  config MMC_SH_MMCIF
>  	tristate "SuperH Internal MMCIF support"
>  	depends on MMC_BLOCK

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

