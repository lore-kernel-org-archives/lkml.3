Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab3CYNu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:50:29 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54905 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3CYNu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:50:28 -0400
Message-ID: <5150561E.2070103@gmail.com>
Date: Mon, 25 Mar 2013 08:50:22 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com
Subject: Re: [PATCH 03/10] clocksource: sunxi: make use of CLKSRC_OF
References: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com> <1364218233-29636-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364218233-29636-4-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 08:30 AM, Maxime Ripard wrote:
> Using CLKSRC_OF allows to remove the SoC specific sunxi_timer.h header,
> and instead of using a custom init function in the machine definition
> use the standard clocksource_of_init function.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

[...]

> @@ -158,3 +157,5 @@ void __init sunxi_timer_init(void)
>  	clockevents_config_and_register(&sunxi_clockevent, rate / TIMER_SCAL,
>  					0x1, 0xff);
>  }
> +CLOCKSOURCE_OF_DECLARE(sunxi, "allwinner,sun4i-timer",
> +		       sunxi_timer_init);

You should base this on clocksource clean-up branch "clksrc/cleanup" in
arm-soc. That will get rid of double matching and match table.

Also, sunxi_timer_init can be static now.

Rob

