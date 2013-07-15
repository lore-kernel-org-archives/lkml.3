Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3GOOvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:51:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39887 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757742Ab3GOOvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:51:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX180LKWLyLu5YVH0iHgtVkZ0
Date: Mon, 15 Jul 2013 07:51:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: pinctrl-single: fix compile warning when no
 CONFIG_PM
Message-ID: <20130715145109.GQ7656@atomide.com>
References: <20130715101426.4e4301b3@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715101426.4e4301b3@armhf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jean-Francois Moine <moinejf@free.fr> [130715 01:19]:
> This warning has been introduced by the commit
>  0f9bc4bcdf4f pinctrl: single: adopt pinctrl sleep mode management
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/pinctrl/pinctrl-single.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 6866548..7323cca 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -1483,6 +1483,7 @@ static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_PM
>  static int pinctrl_single_suspend(struct platform_device *pdev,
>  					pm_message_t state)
>  {
> @@ -1505,6 +1506,7 @@ static int pinctrl_single_resume(struct platform_device *pdev)
>  
>  	return pinctrl_force_default(pcs->pctl);
>  }
> +#endif
>  
>  static int pcs_probe(struct platform_device *pdev)
>  {
> 
