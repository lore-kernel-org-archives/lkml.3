Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3KLPcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:32:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41150 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab3KLPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:32:40 -0500
Message-ID: <528249EE.6080109@ti.com>
Date: Tue, 12 Nov 2013 10:31:58 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
CC: <wim@iguana.be>, <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <galak@kernel.crashing.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: Fwd: [PATCH 1/8] watchdog: davinci: change driver to use WDT
 core
References: <1383680783-12114-2-git-send-email-ivan.khoronzhuk@ti.com> <527A287C.2090401@ti.com>
In-Reply-To: <527A287C.2090401@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 November 2013 06:31 AM, ivan.khoronzhuk wrote:
> To reduce code duplicate and increase code readability use WDT core
> code to handle WDT interface.
> 
> Remove io_lock as the WDT core uses mutex to lock each wdt device.
> Remove wdt_state as the WDT core track state with its own variable.
> 
> The watchdog_init_timeout() can read timeout value from timeout-sec
> property if the passed value is out of bounds. So set initial
> heartbeat value more than max value in order to initialize heartbeat
> in next way. If heartbeat is not set thought module parameter, try
> to read it's value from WDT node timeout-sec property. If node has
> no one, use default value.
> 
> The heartbeat is hold in wdd->timeout by WDT core, so use it in
> order to set timeout period.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  drivers/watchdog/Kconfig       |    1 +
>  drivers/watchdog/davinci_wdt.c |  150 ++++++++++------------------------------
>  2 files changed, 38 insertions(+), 113 deletions(-)
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index d1d53f3..2c954b5 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -271,6 +271,7 @@ config IOP_WATCHDOG
>  config DAVINCI_WATCHDOG
>  	tristate "DaVinci watchdog"
>  	depends on ARCH_DAVINCI
> +	select WATCHDOG_CORE
>  	help
>  	  Say Y here if to include support for the watchdog timer
>  	  in the DaVinci DM644x/DM646x processors.
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index bead774..a6eef71 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -3,7 +3,7 @@
>   *
>   * Watchdog driver for DaVinci DM644x/DM646x processors
>   *
> - * Copyright (C) 2006 Texas Instruments.
> + * Copyright (C) 2013 Texas Instruments.
s/2013/2006-2013

Apart from the minor nit, this is really nice clean-up and
more aligned with wdt coer leayer.

FWIW, Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
