Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3LLBHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:07:20 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51404 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3LLBHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:07:16 -0500
Date: Wed, 11 Dec 2013 17:05:03 -0800
From: Olof Johansson <olof@lixom.net>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, khilman@linaro.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, daniel.lezcano@linaro.org,
        horms@verge.net.au, john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH v4 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
Message-ID: <20131212010503.GI21531@quad.lixom.net>
References: <20131211235616.12661.19702.sendpatchset@w520>
 <20131211235626.12661.8865.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211235626.12661.8865.sendpatchset@w520>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A couple of small comments below.

On Thu, Dec 12, 2013 at 08:56:26AM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add Kconfig entries for CMT, MTU2, TMU and STI to
> drivers/clocksource/Kconfig. This will allow us to
> get rid of duplicated entires in architecture code
> such as arch/sh and arch/arm/mach-shmobile.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/clocksource/Kconfig |   44 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> --- 0001/drivers/clocksource/Kconfig
> +++ work/drivers/clocksource/Kconfig	2013-12-12 08:41:55.000000000 +0900
> @@ -134,3 +134,47 @@ config VF_PIT_TIMER
>  	bool
>  	help
>  	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> +
> +config SYS_SUPPORTS_CMT
> +        bool
> +
> +config SYS_SUPPORTS_TMU
> +        bool
> +
> +config SYS_SUPPORTS_MTU2
> +        bool
> +
> +config SYS_SUPPORTS_STI
> +        bool

Maybe a prefix to avoid namespace collissions here?

> +
> +config SH_TIMER_CMT
> +	bool "Renesas CMT timer driver" if COMPILE_TEST
> +	default SYS_SUPPORTS_CMT

It might be useful to have an explicit depends on ARCH_SH || ARCH_SHMOBILE
|| COMPILE_TEST on these, just to make it easier for someone reading
the code later on.


-Olof
