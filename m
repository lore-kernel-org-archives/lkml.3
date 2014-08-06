Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaHFHkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:40:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37164 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752963AbaHFHkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:40:32 -0400
Date: Wed, 6 Aug 2014 09:40:29 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/15] pinctrl: pinctrl-at91.c: fix decimal printf format
 specifiers prefixed with 0x
Message-ID: <20140806074028.GZ3214@piout.net>
References: <1407300196-32708-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407300196-32708-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 at 21:43:16 -0700, Hans Wennborg wrote :
> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  drivers/pinctrl/pinctrl-at91.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index af1ba4f..60464a2 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -497,10 +497,10 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
>  static void at91_pin_dbg(const struct device *dev, const struct at91_pmx_pin *pin)
>  {
>  	if (pin->mux) {
> -		dev_dbg(dev, "pio%c%d configured as periph%c with conf = 0x%lu\n",
> +		dev_dbg(dev, "pio%c%d configured as periph%c with conf = 0x%lx\n",
>  			pin->bank + 'A', pin->pin, pin->mux - 1 + 'A', pin->conf);
>  	} else {
> -		dev_dbg(dev, "pio%c%d configured as gpio with conf = 0x%lu\n",
> +		dev_dbg(dev, "pio%c%d configured as gpio with conf = 0x%lx\n",
>  			pin->bank + 'A', pin->pin, pin->conf);
>  	}
>  }
> -- 
> 2.0.0.526.g5318336
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
