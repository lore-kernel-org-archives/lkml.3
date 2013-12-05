Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3LESc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:32:59 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39401 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab3LESc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:32:57 -0500
Message-ID: <52A0C6D5.5010603@linaro.org>
Date: Thu, 05 Dec 2013 10:32:53 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
CC: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, olof@lixom.net,
        tglx@linutronix.de
Subject: Re: [PATCH v3 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131204203818.19090.92396.sendpatchset@w520> <20131204203827.19090.98268.sendpatchset@w520>
In-Reply-To: <20131204203827.19090.98268.sendpatchset@w520>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 12:38 PM, Magnus Damm wrote:
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
>  drivers/clocksource/Kconfig |   36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> --- 0001/drivers/clocksource/Kconfig
> +++ work/drivers/clocksource/Kconfig	2013-12-04 22:14:29.000000000 +0900
> @@ -134,3 +134,39 @@ config VF_PIT_TIMER
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
> +
> +config SH_TIMER_CMT
> +	bool "Renesas CMT timer driver" if COMPILE_TEST
> +	default SYS_SUPPORTS_CMT
> +	help
> +	  This enables build of the CMT timer driver.
> +

So again, I'd say if this is a non-conflicting COMPILE_TEST option (ie,
enabling it doesn't for anything else to be disabled), you might as well
enable it without a prompt on COMPILE_TEST. But that's just me. :)

If folks really disagree, and there is to be a user prompt, can we get
just a little more detail in the help text?
So what is the CMT hardware? Maybe what does CMT stand for? What
hardware is it frequently found on?

thanks
-john

