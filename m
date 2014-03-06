Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbaCFBpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:45:40 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:16322
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbaCFBpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:45:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 6 Mar 2014 09:45:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
CC: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCH] clocksource: vf_pit_timer: use complement for
 sched_clock reading
Message-ID: <20140306014530.GA11366@S2101-09.ap.freescale.net>
References: <d25af915993aec1b486be653eb86f748ddef54fe.1394057313.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d25af915993aec1b486be653eb86f748ddef54fe.1394057313.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:11:08PM +0100, Stefan Agner wrote:
> Vybrids PIT register is monitonic decreasing. However, sched_clock
> reading needs to be monitonic increasing. Use bitwise not to get
> the complement of the clock register. This fixes the clock going
> backward. Also, the clock now starts at 0 since we load the
> register with the maximum value at start.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Looks correct to me, so

Acked-by: Shawn Guo <shawn.guo@linaro.org>

But I also copied the driver author Jingchang to see if he has any
comment.

Shawn

> ---
>  drivers/clocksource/vf_pit_timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
> index 02821b0..a918bc4 100644
> --- a/drivers/clocksource/vf_pit_timer.c
> +++ b/drivers/clocksource/vf_pit_timer.c
> @@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(void)
>  
>  static u64 pit_read_sched_clock(void)
>  {
> -	return __raw_readl(clksrc_base + PITCVAL);
> +	return ~__raw_readl(clksrc_base + PITCVAL);
>  }
>  
>  static int __init pit_clocksource_init(unsigned long rate)
> -- 
> 1.9.0
> 

