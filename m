Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaCaSXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:23:24 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41157 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaCaSXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:23:19 -0400
Date: Mon, 31 Mar 2014 11:23:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Input: pmic8xxx-pwrkey - Set sane default for debounce
 time
Message-ID: <20140331182315.GA9198@core.coreip.homeip.net>
References: <1396289664-31893-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396289664-31893-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:14:24AM -0700, Stephen Boyd wrote:
> If the debounce time is 0 our usage of ilog2() later on in this
> driver will cause undefined behavior. If CONFIG_OF=n this fact is
> evident to the compiler, and it emits a call to ____ilog2_NaN()
> which doesn't exist. Fix this by setting a sane default for
> debounce.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/input/misc/pmic8xxx-pwrkey.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
> index 1cb8fda7a166..27add04676e1 100644
> --- a/drivers/input/misc/pmic8xxx-pwrkey.c
> +++ b/drivers/input/misc/pmic8xxx-pwrkey.c
> @@ -92,7 +92,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
>  	bool pull_up;
>  
>  	if (of_property_read_u32(pdev->dev.of_node, "debounce", &kpd_delay))
> -		kpd_delay = 0;
> +		kpd_delay = 15625;

What if somebody supplied 0 via DT? Can we check and return -EINVAL?

>  
>  	pull_up = of_property_read_bool(pdev->dev.of_node, "pull-up");
>  
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

-- 
Dmitry
