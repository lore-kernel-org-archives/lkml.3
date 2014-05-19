Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaESUuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:50:44 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29826 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaESUul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:50:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dOph2wWdvbPq10B/1yN6N
Date: Mon, 19 May 2014 13:50:33 -0700
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
Subject: Re: [PATCHv2 resend 07/11] ARM: OMAP3: Beagle: use PWM_LOOKUP to
 initialize struct pwm_lookup
Message-ID: <20140519205033.GE11945@atomide.com>
References: <1400532162-29483-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1400532162-29483-8-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400532162-29483-8-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexandre Belloni <alexandre.belloni@free-electrons.com> [140519 13:44]:

Missing description?

Presumably you'll fix that so:

Acked-by: Tony Lindgren <tony@atomide.com>

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-omap2/board-omap3beagle.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
> index f27e1ec90b5e..54c135a5b4f7 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@ -61,14 +61,8 @@
>  
>  static struct pwm_lookup pwm_lookup[] = {
>  	/* LEDB -> PMU_STAT */
> -	{
> -		.provider = "twl-pwmled",
> -		.index = 1,
> -		.dev_id = "leds_pwm",
> -		.con_id = "beagleboard::pmu_stat",
> -		.period = 7812500,
> -		.polarity = PWM_POLARITY_NORMAL,
> -	},
> +	PWM_LOOKUP("twl-pwmled", 1, "leds_pwm", "beagleboard::pmu_stat",
> +		   7812500, PWM_POLARITY_NORMAL),
>  };
>  
>  static struct led_pwm pwm_leds[] = {
> -- 
> 1.9.1
> 
