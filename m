Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3ILO7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:59:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34330 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab3ILO73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:59:29 -0400
Date: Thu, 12 Sep 2013 15:57:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fan Rong <cinifr@gmail.com>
Cc: "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 4/4] Add arch count timer node in dts for Allwinner
 A20(sunxi 7i).
Message-ID: <20130912145756.GD22013@e106331-lin.cambridge.arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
 <1378968687-8200-5-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378968687-8200-5-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 07:51:27AM +0100, Fan Rong wrote:
> Signed-off-by: Fan Rong <cinifr@gmail.com>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
> index bfedcb2..ce138f7 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -312,5 +312,14 @@
>  			#interrupt-cells = <3>;
>  			interrupts = <1 9 0xf04>;
>  		};
> +
> +		timer {
> +			compatible ="arm,armv7-timer";

Space after the '=' please.

> +			interrupts = <1 13 0x308>,
> +				     <1 14 0x308>,
> +				     <1 11 0x308>,
> +				     <1 10 0x308>;
> +			clock-frequency = <24000000>;

If at all possible, your bootloader should set CNTFREQ, and
clock-frequency should only be used as a last resort when it's
impossible to get it to set CNTFREQ. It's not possible to set CNTFREQ
from the non-secure side, so guests (which might not be Linux, and might
not handle DT in the same way) may see a completely wrong frequency
value.

Thanks,
Mark.

> +		};
>  	};
>  };
> -- 
> 1.7.9.5
> 
> 
