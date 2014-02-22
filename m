Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaBVSoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:44:25 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:59082 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751893AbaBVSoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:44:24 -0500
Date: Sat, 22 Feb 2014 19:44:19 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, linux@roeck-us.net,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 10/11] watchdog: xilinx: Enable this driver for Zynq
Message-ID: <20140222184419.GA21504@spo001.leaseweb.com>
References: <cover.1392212059.git.michal.simek@xilinx.com> <a978b8d0511748e4558f5169896da44c742a49f3.1392212059.git.michal.simek@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a978b8d0511748e4558f5169896da44c742a49f3.1392212059.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> Enable this driver for Zynq.
> Move it to architecture independent Kconfig part.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
> 
> Changes in v3: None
> Changes in v2: None
> 
> Build tested by zero day testing system.
> ---
>  drivers/watchdog/Kconfig | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 9db5d3c..6120403 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -111,6 +111,15 @@ config WM8350_WATCHDOG
>  	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
>  	  the watchdog triggers the system will be reset.
> 
> +config XILINX_WATCHDOG
> +	tristate "Xilinx Watchdog timer"
> +	select WATCHDOG_CORE
> +	help
> +	  Watchdog driver for the xps_timebase_wdt ip core.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called of_xilinx_wdt.
> +
>  # ALPHA Architecture
> 
>  # ARM Architecture
> @@ -1022,19 +1031,6 @@ config M54xx_WATCHDOG
> 
>  # MicroBlaze Architecture
> 
> -config XILINX_WATCHDOG
> -	tristate "Xilinx Watchdog timer"
> -	depends on MICROBLAZE
> -	select WATCHDOG_CORE
> -	---help---
> -	  Watchdog driver for the xps_timebase_wdt ip core.
> -
> -	  IMPORTANT: The xps_timebase_wdt parent must have the property
> -	  "clock-frequency" at device tree.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called of_xilinx_wdt.
> -
>  # MIPS Architecture
> 
>  config ATH79_WDT
> --
> 1.8.2.3
> 

Are we sure that we don't need an additional dependancy (like depends on HAS_IOMEM) to not have issues with other architectures?

Kind regards,
Wim.

