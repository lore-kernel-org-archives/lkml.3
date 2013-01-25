Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3AYPyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:54:32 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:60820 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3AYPya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:54:30 -0500
Date: Fri, 25 Jan 2013 16:42:19 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 18/19] ARM: at91: suspend both memory controllers on
 at91sam9263
Message-ID: <20130125154219.GM7360@game.jcrosoft.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-19-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359123276-15833-19-git-send-email-arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12121719872285158148
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrkedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrkedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:14 Fri 25 Jan     , Arnd Bergmann wrote:
> For the past three years, we have had a #warning in
> mach-at91 about the sdram_selfrefresh_enable or
> at91sam9_standby functions possibly not working on
> at91sam9263. In the meantime a function was added
> to do the right thing on at91sam9g45, which looks like
> it should also work on '9263.
> 
> This patch blindly removes the warning and changes the
> at91sam9263 to use the same code at at91sam9g45, which
> may or may not be the right solution. If it is not,
> maybe someone could provide a better fix.
it's not

the 9g45 use DDR Controler where the 9263 use a SDRAM controler

Best Regards,
J.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  arch/arm/mach-at91/cpuidle.c | 2 +-
>  arch/arm/mach-at91/pm.c      | 2 +-
>  arch/arm/mach-at91/pm.h      | 8 --------
>  3 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
> index 0c63815..208d486 100644
> --- a/arch/arm/mach-at91/cpuidle.c
> +++ b/arch/arm/mach-at91/cpuidle.c
> @@ -36,7 +36,7 @@ static int at91_enter_idle(struct cpuidle_device *dev,
>  {
>  	if (cpu_is_at91rm9200())
>  		at91rm9200_standby();
> -	else if (cpu_is_at91sam9g45())
> +	else if (cpu_is_at91sam9g45() || cpu_is_at91sam9263())
>  		at91sam9g45_standby();
>  	else
>  		at91sam9_standby();
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index adb6db8..f6bd4fa 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -265,7 +265,7 @@ static int at91_pm_enter(suspend_state_t state)
>  			 */
>  			if (cpu_is_at91rm9200())
>  				at91rm9200_standby();
> -			else if (cpu_is_at91sam9g45())
> +			else if (cpu_is_at91sam9g45() || cpu_is_at91sam9263())
>  				at91sam9g45_standby();
>  			else
>  				at91sam9_standby();
> diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
> index 38f467c..5252216 100644
> --- a/arch/arm/mach-at91/pm.h
> +++ b/arch/arm/mach-at91/pm.h
> @@ -70,14 +70,6 @@ static inline void at91sam9g45_standby(void)
>  	at91_ramc_write(1, AT91_DDRSDRC_LPR, saved_lpr1);
>  }
>  
> -#ifdef CONFIG_SOC_AT91SAM9263
> -/*
> - * FIXME either or both the SDRAM controllers (EB0, EB1) might be in use;
> - * handle those cases both here and in the Suspend-To-RAM support.
> - */
> -#warning Assuming EB1 SDRAM controller is *NOT* used
> -#endif
> -
>  static inline void at91sam9_standby(void)
>  {
>  	u32 saved_lpr, lpr;
> -- 
> 1.8.0
> 
