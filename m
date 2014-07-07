Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaGGKvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:51:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11472 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaGGKvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:51:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+qGrwsHRvLhYOW53l5i5co
Date: Mon, 7 Jul 2014 03:51:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: Guido =?utf-8?B?TWFydMOtbmV6?= <guido@vanguardiasur.com.ar>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        Ezequiel =?utf-8?Q?Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        pekon@ti.com
Subject: Re: [PATCH v2] ARM: OMAP2+: Make GPMC skip disabled devices
Message-ID: <20140707105101.GN28884@atomide.com>
References: <20980858CB6D3A4BAE95CA194937D5E73EAF8D44@DBDE04.ent.ti.com>
 <1404308118-14843-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404308118-14843-1-git-send-email-guido@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Guido Martínez <guido@vanguardiasur.com.ar> [140702 06:34]:
> Currently, child nodes of the gpmc node are iterated and probed
> regardless of their 'status' property. This means adding 'status =
> "disabled";' has no effect.
> 
> This patch changes the iteration to only probe nodes marked as
> available.
> 
> Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
> ---
> v2: Make patch title consistent with previous gpmc patches

Thanks applying into omap-for-v3.16/fixes.

Tony
 
>  arch/arm/mach-omap2/gpmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index 2c0c281..8bc1338 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -1615,7 +1615,7 @@ static int gpmc_probe_dt(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	for_each_child_of_node(pdev->dev.of_node, child) {
> +	for_each_available_child_of_node(pdev->dev.of_node, child) {
>  
>  		if (!child->name)
>  			continue;
> -- 
> 2.0.0
> 
