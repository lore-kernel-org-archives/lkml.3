Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3GHMAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:00:52 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59545 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3GHMAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:00:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18tNlz5PUcxHAmctAFA4q3h
Date: Mon, 8 Jul 2013 05:00:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@infradead.org,
        arm@kernel.org
Subject: Re: [PATCH 4/8] ARM: OMAP: build mach-omap code only if needed
Message-ID: <20130708120048.GW5523@atomide.com>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
 <1373041417-217728-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373041417-217728-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130705 09:28]:
> If we build a kernel with CONFIG_ARCH_OMAP2PLUS enabled but all of the
> individual SoCs disabled, we run into a large number of link errors
> because if incorrect dependencies:
> 
> arch/arm/mach-omap2/built-in.o: In function `_add_initiator_dep':
> arch/arm/mach-omap2/omap_hwmod.c:691: undefined reference to `clkdm_add_sleepdep' arch/arm/mach-omap2/built-in.o: In function `_del_initiator_dep':
> arch/arm/mach-omap2/omap_hwmod.c:720: undefined reference to `clkdm_del_sleepdep' arch/arm/mach-omap2/built-in.o: In function `_enable':
> arch/arm/mach-omap2/omap_hwmod.c:2145: undefined reference to `clkdm_in_hwsup'
> arch/arm/mach-omap2/omap_hwmod.c:2147: undefined reference to `clkdm_hwmod_enable'
> arch/arm/mach-omap2/omap_hwmod.c:2191: undefined reference to `clkdm_hwmod_disable'
> arch/arm/mach-omap2/omap_hwmod.c:2146: undefined reference to `clkdm_missing_idle_reporting' arch/arm/mach-omap2/built-in.o: In function `_idle':
> arch/arm/mach-omap2/omap_hwmod.c:2235: undefined reference to `clkdm_hwmod_disable' arch/arm/mach-omap2/built-in.o: In function `_shutdown':
> arch/arm/mach-omap2/omap_hwmod.c:2338: undefined reference to `clkdm_hwmod_disable' arch/arm/mach-omap2/built-in.o: In function `omap_hwmod_get_context_loss_count':
> arch/arm/mach-omap2/omap_hwmod.c:4071: undefined reference to `pwrdm_get_context_loss_count' arch/arm/mach-omap2/built-in.o: In function `omap_pm_clkdms_setup':
> arch/arm/mach-omap2/pm.c:114: undefined reference to `clkdm_allow_idle'
> arch/arm/mach-omap2/pm.c:117: undefined reference to `clkdm_sleep' arch/arm/mach-omap2/built-in.o: In function `omap2_common_pm_late_init':
> arch/arm/mach-omap2/pm.c:294: undefined reference to `omap_voltage_late_init' arch/arm/mach-omap2/built-in.o: In function `omap2_gpio_dev_init':
> arch/arm/mach-omap2/gpio.c:133: undefined reference to `pwrdm_can_ever_lose_context'
> 
> We can avoid this if we make CONFIG_ARCH_OMAP2PLUS a silent option that
> gets enabled any time that one of the SoC versions is enabled.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Sounds like there's some issue as noted by Olof, but the
patch is good in general:

Acked-by: Tony Lindgren <tony@atomide.com>
