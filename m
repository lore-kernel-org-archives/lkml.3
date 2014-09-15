Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaIOQeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:34:44 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58911 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbaIOQem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:34:42 -0400
Message-ID: <1410798874.31130.57.camel@x220>
Subject: Re: [PATCH v8 6/9] arm: netx: Migrate DEBUG_LL macros to shared
 directory
From: Paul Bolle <pebolle@tiscali.nl>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Date: Mon, 15 Sep 2014 18:34:34 +0200
In-Reply-To: <1408459715-10151-7-git-send-email-daniel.thompson@linaro.org>
References: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
	 <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
	 <1408459715-10151-7-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Sep 2014 16:34:34.0896 (UTC) FILETIME=[EF1F0100:01CFD102]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 15:48 +0100, Daniel Thompson wrote:
> As part of the migration we introduce DEBUG_UART_PHYS/DEBUG_UART_VIRT
> which default to UART1 but allow a user to configure UART2 or UART3.
> We also introduce symbolic names for the registers and flags.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Acked-by: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org

This patch landed in today's linux-next, as 880fa9b6fd73 ("ARM: 8144/1:
netx: Migrate DEBUG_LL macros to shared directory").

> [...]
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -447,6 +447,14 @@ choice
>  		  Say Y here if you want kernel low-level debugging support
>  		  on Vybrid based platforms.
>  
> +	config DEBUG_NETX_UART
> +		bool "Kernel low-level debugging messages via NetX UART"
> +		depends on ARCH_NETX
> +		select DEBUG_UART_NETX

There's no Kconfig symbol DEBUG_UART_NETX in next-20140915. So in
linux-next this is currently a nop. Is this symbol queued somewhere?

> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on Hilscher NetX based platforms.
> +
>  	config DEBUG_NOMADIK_UART
>  		bool "Kernel low-level debugging messages via NOMADIK UART"
>  		depends on ARCH_NOMADIK


Paul Bolle

