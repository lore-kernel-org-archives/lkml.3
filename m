Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaIVRap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:30:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50066 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaIVRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:30:43 -0400
Date: Mon, 22 Sep 2014 10:30:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Cartwright <joshc@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] power: reset: use restart_notifier mechanism for
 msm-poweroff
Message-ID: <20140922173041.GE10233@codeaurora.org>
References: <1411371774-6834-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411371774-6834-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22, Pramod Gurav wrote:
> diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
> index 774f9a3..db73238 100644
> --- a/drivers/power/reset/msm-poweroff.c
> +++ b/drivers/power/reset/msm-poweroff.c
> @@ -24,17 +24,24 @@
>  #include <asm/system_misc.h>

We can remove this include now too?

>  
>  static void __iomem *msm_ps_hold;
> -
[...]
> @@ -47,8 +54,10 @@ static int msm_restart_probe(struct platform_device *pdev)
>  	if (IS_ERR(msm_ps_hold))
>  		return PTR_ERR(msm_ps_hold);
>  
> +	register_restart_handler(&restart_nb);
> +
>  	pm_power_off = do_msm_poweroff;
> -	arm_pm_restart = do_msm_restart;
> +

And it looks like we should be including <linux/pm.h> for the
pm_power_off hook?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
