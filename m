Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3E1VUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:20:50 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47603 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab3E1VUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:20:49 -0400
Message-ID: <51A51FAC.5090606@gmail.com>
Date: Tue, 28 May 2013 22:20:44 +0100
From: Jon Hunter <jgchunter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: OMAP2+: timer: initialize before using oh_name
References: <1369722288-15592-1-git-send-email-afzal@ti.com>
In-Reply-To: <1369722288-15592-1-git-send-email-afzal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/05/13 07:24, Afzal Mohammed wrote:
> of_property_read_string_index(...,&oh_name) in omap_dm_timer_init_one
> does not alter the value of 'oh_name' even if the relevant function
> fails and as 'oh_name' in stack may have a non-zero value, it would
> be misunderstood by timer code that DT has specified "ti,hwmod"
> property for timer. 'oh_name' in this scenario would be a junk value,
> this would result in module not being enabled by hwmod API's for
> timer, and in turn crash.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>  arch/arm/mach-omap2/timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index f8b23b8..8e0c390 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -220,7 +220,7 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
>  					 int posted)
>  {
>  	char name[10]; /* 10 = sizeof("gptXX_Xck0") */
> -	const char *oh_name;
> +	const char *oh_name = NULL;
>  	struct device_node *np;
>  	struct omap_hwmod *oh;
>  	struct resource irq, mem;

Thanks!

Acked-by: Jon Hunter <jgchunter@gmail.com>

Cheers
Jon

