Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaCPHJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 03:09:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53667 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbaCPHJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 03:09:37 -0400
Date: Sun, 16 Mar 2014 04:09:17 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Laura Abbott <lauraa@codeaurora.org>, Sricharan R <r.sricharan@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140316070917.GA3094@arch.cereza>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
 <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 05, Sebastian Capella wrote:
[..]
> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 1f8fed9..83707702 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -611,6 +611,11 @@ config CPU_USE_DOMAINS
>  config IO_36
>  	bool
>  
> +config ARCH_HIBERNATION_POSSIBLE
> +	bool
> +	depends on MMU
> +	default y if CPU_ARM920T || CPU_ARM926T || CPU_SA1100 || CPU_XSCALE || CPU_XSC3 || CPU_V6 || CPU_V6K || CPU_V7
> +
>  comment "Processor Features"
>  

Is there any reason why CPU_FEROCEON is not listed here? FWIW, I've just built
(but not really tested) a Kirkwood kernel with CONFIG_HIBERNATION=y.

And is there any reason to put this config in arch/arm/mm/Kconfig, instead of
in arch/arm/Kconfig, below ARCH_SUSPEND_POSSIBLE? 

I'm also puzzled about having two separate options for suspend and hibernate,
maybe someone can explain me why a given CPU would support the former but not
the latter?

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
