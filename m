Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaESUuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:50:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28559 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaESUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:50:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19yX4vEr7PhqpBEN2LTD8EH
Date: Mon, 19 May 2014 13:49:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCHv2 resend 04/11] ARM: OMAP3: Beagle: initialize all the
 struct pwm_lookup members
Message-ID: <20140519204954.GD11945@atomide.com>
References: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1400532162-29483-5-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400532162-29483-5-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexandre Belloni <alexandre.belloni@free-electrons.com> [140519 13:44]:
> This will allow to get rid of the .pwm_period_ns member of struct led_pwm as the
> period will be set by the PWM core.

This should not conflict with anything I have:

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-omap2/board-omap3beagle.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
> index d6ed819ff15c..f27e1ec90b5e 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@ -61,7 +61,14 @@
>  
>  static struct pwm_lookup pwm_lookup[] = {
>  	/* LEDB -> PMU_STAT */
> -	PWM_LOOKUP("twl-pwmled", 1, "leds_pwm", "beagleboard::pmu_stat"),
> +	{
> +		.provider = "twl-pwmled",
> +		.index = 1,
> +		.dev_id = "leds_pwm",
> +		.con_id = "beagleboard::pmu_stat",
> +		.period = 7812500,
> +		.polarity = PWM_POLARITY_NORMAL,
> +	},
>  };
>  
>  static struct led_pwm pwm_leds[] = {
> -- 
> 1.9.1
> 
