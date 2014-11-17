Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaKQG30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:29:26 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38130 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaKQG3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:29:24 -0500
Date: Mon, 17 Nov 2014 01:29:20 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net, pavel@ucw.cz,
        len.brown@intel.com, linux@arm.linux.org.uk, ccross@android.com
Subject: Re: [PATCH v2] cpu_pm: fix unmet dependency for CPU_PM
In-Reply-To: <1416204764-8912-1-git-send-email-pankaj.dubey@samsung.com>
Message-ID: <alpine.LFD.2.11.1411170128560.11690@knanqh.ubzr>
References: <1416204764-8912-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Pankaj Dubey wrote:

> If BL_SWITCHER is enabled but SUSPEND and CPU_IDLE is not enabled
> we are getting following config warning.
> 
> warning: (BL_SWITCHER) selects CPU_PM which has unmet direct
> dependencies (SUSPEND || CPU_IDLE)
> 
> It has been noticed that CPU_PM dependencies in this file are not really
> required so let's remove these dependencies from CPU_PM.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
> This patch is second attempt to fix this config issue. Patch v1 and related
> discussion can be found here [1]
> 1: https://lkml.org/lkml/2014/11/14/673
> 
>  kernel/power/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index bbef57f..1eb7da7 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -308,4 +308,3 @@ config PM_GENERIC_DOMAINS_OF
>  
>  config CPU_PM
>  	bool
> -	depends on SUSPEND || CPU_IDLE
> -- 
> 1.7.9.5
> 
> 
