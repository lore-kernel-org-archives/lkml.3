Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3BRNrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:47:37 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:65179 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3BRNrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:47:35 -0500
Message-ID: <512230F1.8020208@gmail.com>
Date: Mon, 18 Feb 2013 07:47:29 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [RFC 2/8] ARM: twd: register clock event for 1 core SMP
References: <cover.1361166003.git.afzal@ti.com> <a7f62b8580aa4b33d5658f4f03371a453adaea9b.1361166003.git.afzal@ti.com>
In-Reply-To: <a7f62b8580aa4b33d5658f4f03371a453adaea9b.1361166003.git.afzal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 12:30 AM, Afzal Mohammed wrote:
> Register percpu local timer for scheduler tick in the case of one core
> SMP configuration. In other cases - secondary cpu's as well as boot
> cpu's having more than one core, this is being registered as per
> existing boot flow, with a difference that they happens after delay
> calibration. Registering the clock for tick in case of one core should
> be done before Kernel calibrates delay (this is required to boot,
> unless local timer is the only one registered for tick). Registering
> twd local timer at init_time (which platforms are doing now) helps
> achieve that with the proposed change.
> 
> This helps in an almost booting Kernel (minimal) by only relying on
> ARM parts for an A9 one core SMP.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>  arch/arm/kernel/smp_twd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
> index 616268c..118f4f2 100644
> --- a/arch/arm/kernel/smp_twd.c
> +++ b/arch/arm/kernel/smp_twd.c
> @@ -335,6 +335,9 @@ static int __init twd_local_timer_common_register(struct device_node *np)
>  
>  	twd_get_clock(np);
>  
> +	if (num_possible_cpus() == 1)
> +		twd_timer_setup(evt);
> +

Shouldn't this be fixed in the core code, so the same issue is fixed for
all timers?

Rob

>  	return 0;
>  
>  out_irq:
> 

