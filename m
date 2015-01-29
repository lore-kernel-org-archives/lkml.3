Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbbA2K3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:29:10 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44229 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762314AbbA2K3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:29:04 -0500
Date: Thu, 29 Jan 2015 10:28:59 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [PATCH 2/3] clocksource: versatile: adapt for Versatile AB and
 PB boards
Message-ID: <20150129102859.GR956@e106497-lin.cambridge.arm.com>
References: <1422467792-2065-1-git-send-email-robh@kernel.org>
 <1422467792-2065-3-git-send-email-robh@kernel.org>
MIME-Version: 1.0
In-Reply-To: <1422467792-2065-3-git-send-email-robh@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 29 Jan 2015 10:28:59.0171 (UTC) FILETIME=[6496FF30:01D03BAE]
X-MC-Unique: 115012910290105701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 05:56:31PM +0000, Rob Herring wrote:
> The same 24MHz counter is also present on Versatile AB and PB boards, so
> add the compatible string for them.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Liviu Dudau <liviu.dudau@arm.com>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/clocksource/versatile.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/versatile.c b/drivers/clocksource/versatile.c
> index 2798e74..0a26d3d 100644
> --- a/drivers/clocksource/versatile.c
> +++ b/drivers/clocksource/versatile.c
> @@ -36,5 +36,7 @@ static void __init versatile_sched_clock_init(struct device_node *node)
>  
>  	sched_clock_register(versatile_sys_24mhz_read, 32, 24000000);
>  }
> -CLOCKSOURCE_OF_DECLARE(versatile, "arm,vexpress-sysreg",
> +CLOCKSOURCE_OF_DECLARE(vexpress, "arm,vexpress-sysreg",
> +		       versatile_sched_clock_init);
> +CLOCKSOURCE_OF_DECLARE(versatile, "arm,versatile-sysreg",
>  		       versatile_sched_clock_init);

Acked-by: Liviu Dudau <Liviu.Dudau@arm.com>

> -- 
> 2.1.0
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

