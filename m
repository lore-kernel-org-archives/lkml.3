Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3HPSAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:00:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3HPSA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:00:27 -0400
Message-ID: <520E68A9.1020406@infradead.org>
Date: Fri, 16 Aug 2013 11:00:09 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: phy: am335x-control: make it compile with
References: <20130815165829.6a401f104ee2a98dd48bcb58@canb.auug.org.au> <520D0AD7.6050002@infradead.org> <520E0304.5050906@ti.com> <20130816153249.GA3570@breakpoint.cc>
In-Reply-To: <20130816153249.GA3570@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/13 08:32, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Randy reported this
> |drivers/usb/phy/phy-am335x-control.c:45:3: error: implicit declaration
> |of function '__WARN' [-Werror=implicit-function-declaration]
> 
> and left it as an excercice to figure out that this happens only with
> CONFIG_BUG=n. As a fix I replace it with WARN_ON(). And there is a space
> before return so fix this, too.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/usb/phy/phy-am335x-control.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-am335x-control.c
> index 7597545..22cf07d 100644
> --- a/drivers/usb/phy/phy-am335x-control.c
> +++ b/drivers/usb/phy/phy-am335x-control.c
> @@ -42,8 +42,8 @@ static void am335x_phy_power(struct phy_control *phy_ctrl, u32 id, bool on)
>  		reg = AM335X_USB1_CTRL;
>  		break;
>  	default:
> -		__WARN();
> -		 return;
> +		WARN_ON(1);
> +		return;
>  	}
>  
>  	val = readl(usb_ctrl->phy_reg + reg);
> 


-- 
~Randy
