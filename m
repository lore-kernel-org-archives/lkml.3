Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaEIJba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:31:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38704 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaEIJb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:31:28 -0400
Date: Fri, 9 May 2014 10:31:25 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] bus/arm-cci: add dependency on OF && CPU_V7
Message-ID: <20140509093125.GB32007@e102568-lin.cambridge.arm.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <1399560990-1402858-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 May 2014 09:31:34.0453 (UTC) FILETIME=[77E8FE50:01CF6B69]
X-MC-Unique: 114050910312607801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 03:56:18PM +0100, Arnd Bergmann wrote:
> The arm-cci code uses device tree helpers for initialization
> that don't work on kernels built without CONFIG_OF. Further,
> it contains an inline assembly in cci_enable_port_for_self()
> that uses ARMv7 instructions and fails to build when targetting
> other ARM instruction set versions.
> 
> This works around both issues by limiting the scope of the
> Kconfig symbol to platforms that can actually build this driver
> cleanly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> ---
>  drivers/bus/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> index 552373c..d53417e 100644
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -37,7 +37,7 @@ config OMAP_INTERCONNECT
>  
>  config ARM_CCI
>  	bool "ARM CCI driver support"
> -	depends on ARM
> +	depends on ARM && OF && CPU_V7
>  	help
>  	  Driver supporting the CCI cache coherent interconnect for ARM
>  	  platforms.

The dependency on CPU_V7 will need reworking, since we might want to
enable the driver on arm64 platforms too (eg CCI PMUs), other than that:

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

