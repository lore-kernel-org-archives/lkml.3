Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbaDXPPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:15:51 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40435 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbaDXPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:15:48 -0400
Date: Thu, 24 Apr 2014 08:15:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: gundberg <per.gundberg@icomera.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>
Subject: Re: [PATCH] watchdog: kempld-wdt: Use the correct value when
 configuring the prescaler with the watchdog
Message-ID: <20140424151540.GA6767@roeck-us.net>
References: <5359165F.5040102@icomera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5359165F.5040102@icomera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 03:49:19PM +0200, gundberg wrote:
> Use the prescaler index, rather than its value, to configure the watchdog.
> This will prevent a mismatch with the prescaler used to calculate the cycles.
> 
> Signed-off-by: Per Gundberg <per.gundberg@icomera.com>

Good catch. Looks correct to me. Michael, any comments ?

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/kempld_wdt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- src/drivers/watchdog/kempld_wdt.c.orig	2014-04-24 07:32:08.463745055 +0000
> +++ src/drivers/watchdog/kempld_wdt.c	2014-04-24 07:34:09.839739808 +0000
> @@ -163,7 +163,7 @@ static int kempld_wdt_set_stage_timeout(
>  	kempld_get_mutex(pld);
>  	stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->id));
>  	stage_cfg &= ~STAGE_CFG_PRESCALER_MASK;
> -	stage_cfg |= STAGE_CFG_SET_PRESCALER(prescaler);
> +	stage_cfg |= STAGE_CFG_SET_PRESCALER(PRESCALER_21);
>  	kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->id), stage_cfg);
>  	kempld_write32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->id),
>  			stage_timeout);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
