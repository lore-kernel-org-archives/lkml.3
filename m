Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbaB0G6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:58:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:60648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB0G6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:58:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,552,1389772800"; 
   d="scan'208";a="463243647"
Message-ID: <1393484282.2637.17.camel@rzhang1-mobl4>
Subject: Re: [PATCH 2/2] thermal,rcar_thermal: Add dependency on HAS_IOMEM
From: Zhang Rui <rui.zhang@intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, horms@verge.net.au,
        laurent.pinchart+renesas@ideasonboard.com,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Date: Thu, 27 Feb 2014 14:58:02 +0800
In-Reply-To: <1390688954-4940-1-git-send-email-richard@nod.at>
References: <1390688954-4940-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-25 at 23:29 +0100, Richard Weinberger wrote:
> Commit beeb5a1e (thermal: rcar-thermal: Enable driver compilation with COMPILE_TEST)
> broke build on archs wihout io memory.
> 
> On archs like S390 or um this driver cannot build nor work.
> Make it depend on HAS_IOMEM to bypass build failures.
> 
> drivers/thermal/rcar_thermal.c:404: undefined reference to `devm_ioremap_resource'
> drivers/thermal/rcar_thermal.c:426: undefined reference to `devm_ioremap_resource'
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Kuninori,

are you okay with this patch?

thanks,
rui

> ---
>  drivers/thermal/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 35c0664..88efa8f 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -136,6 +136,7 @@ config SPEAR_THERMAL
>  config RCAR_THERMAL
>  	tristate "Renesas R-Car thermal driver"
>  	depends on ARCH_SHMOBILE || COMPILE_TEST
> +	depends on HAS_IO_MEM
>  	help
>  	  Enable this to plug the R-Car thermal sensor driver into the Linux
>  	  thermal framework.


