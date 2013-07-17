Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3GQNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:25:56 -0400
Received: from smtp.citrix.com ([66.165.176.89]:26964 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab3GQNZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:25:55 -0400
X-IronPort-AV: E=Sophos;i="4.89,684,1367971200"; 
   d="scan'208";a="37502964"
Date: Wed, 17 Jul 2013 14:25:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: <linux@arm.linux.org.uk>, <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <patches@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
 debug is disabled
In-Reply-To: <1373897706-15331-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Julien Grall wrote:
> Even if uncompress debug is disabled, some board will continue to print
> information during uncompress step.

Are you talking about DEBUG_UNCOMPRESS?
Should I read the sentence as "even if DEBUG_UNCOMPRESS is not selected,
some board will continue to print information during the uncompress step"?

Isn't this a bug in the platform specific code that should be fixed anyway?


> By using debug/uncompress.h include, all debug output will be disabled.

I am not sure if this is the right solution to the problem.
I think it might be better to add the appropriate ifdefs into the
platform specific code.

Arnd, what do you think?


> This is usefull in Xen environment for DOM0 because the UART is stolen by
> Xen.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>
>
>  arch/arm/Kconfig.debug |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 21cc8a7..86c023d 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -679,7 +679,7 @@ config DEBUG_UNCOMPRESS
>  
>  config UNCOMPRESS_INCLUDE
>  	string
> -	default "debug/uncompress.h" if ARCH_MULTIPLATFORM
> +	default "debug/uncompress.h" if ARCH_MULTIPLATFORM || !DEBUG_UNCOMPRESS
>  	default "mach/uncompress.h"
>  
>  config EARLY_PRINTK
> -- 
> 1.7.10.4
> 
