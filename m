Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbbA2Nhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:37:40 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:57465 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757922AbbA2Nhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:37:38 -0500
Message-ID: <1422538656.32520.4.camel@x220>
Subject: Re: [PATCH 6/9] clocksource: Driver for Conexant Digicolor SoC timer
From: Paul Bolle <pebolle@tiscali.nl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry.Song@csr.com,
        baruch@tkos.co.il, linux@rempel-privat.de, rob.herring@linaro.org,
        thierry.reding@gmail.com
Date: Thu, 29 Jan 2015 14:37:36 +0100
In-Reply-To: <1422536899-16609-6-git-send-email-daniel.lezcano@linaro.org>
References: <54CA3044.6070501@linaro.org>
	 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
	 <1422536899-16609-6-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2015 13:37:37.0067 (UTC) FILETIME=[BE94DFB0:01D03BC8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-29 at 14:08 +0100, Daniel Lezcano wrote:
> From: Baruch Siach <baruch@tkos.co.il>
> 
> Add clocksource driver to the Conexant CX92755 SoC, part of the Digicolor SoCs
> series. Hardware provides 8 timers, A to H. Timer A is dedicated to a future
> watchdog driver so we don't use it here. Use timer B for sched_clock, and timer
> C for clock_event.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/clocksource/Kconfig           |   3 +
>  drivers/clocksource/Makefile          |   1 +
>  drivers/clocksource/timer-digicolor.c | 199 ++++++++++++++++++++++++++++++++++
>  3 files changed, 203 insertions(+)
>  create mode 100644 drivers/clocksource/timer-digicolor.c
> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index a89120b..72a3827 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -18,6 +18,9 @@ config CLKBLD_I8253
>  config CLKSRC_MMIO
>  	bool
>  
> +config DIGICOLOR_TIMER
> +	bool
> +

And the select for this symbol (see https://lkml.org/lkml/2015/1/26/360)
will be provided in a separate patch? Because this patch, by itself,
won't allow DIGICOLOR_TIMER to be set, will it?
 
>  config DW_APB_TIMER
>  	bool
>  


Paul Bolle

