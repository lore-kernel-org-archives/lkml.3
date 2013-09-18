Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3IRS4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:56:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63827 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3IRS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:56:35 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+184TPJv6NjYTcQa9VQNR6c3dvurDyxjE=
Date: Wed, 18 Sep 2013 14:56:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jean Pihet <jean.pihet@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, john.stultz@linaro.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        patches@linaro.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] arm: mvebu: use the main timer as clock source from DT
Message-ID: <20130918185611.GP19937@titan.lakedaemon.net>
References: <1379530168-9359-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379530168-9359-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding clocksource maintainers to the Cc: ...

On Wed, Sep 18, 2013 at 08:49:28PM +0200, Jean Pihet wrote:
> This commit:
>   573145f08c2b92c45498468afbbba909f6ce6135
>   clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE
> 
> replaced a call to the driver's timer initialization by a call to
> clocksource_of_init(). However, it failed to select CONFIG_CLKSRC_OF.
> 
> Fix this by selecting CONFIG_CLKSRC_OF for Armada370/XP machines.
> Without this change the kernel is stuck at: 'Calibrating delay loop...'.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  drivers/clocksource/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Jason Cooper <jason@lakedaemon.net>

Daniel, John, Thomas,

Can you queue this up for v3.12-rc2?  It fixes a boot breakage.

thx,

Jason.

> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 41c6946..971d796 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -26,6 +26,7 @@ config DW_APB_TIMER_OF
>  
>  config ARMADA_370_XP_TIMER
>  	bool
> +	select CLKSRC_OF
>  
>  config ORION_TIMER
>  	select CLKSRC_OF
> -- 
> 1.7.11.7
> 
