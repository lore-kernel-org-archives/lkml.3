Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab3IFQPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:15:32 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54056 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753028Ab3IFQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:15:31 -0400
Date: Fri, 6 Sep 2013 17:14:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] arm: add early_ioremap support
Message-ID: <20130906161448.GI1946@arm.com>
References: <1378459158-2145-1-git-send-email-leif.lindholm@linaro.org>
 <1378459158-2145-3-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378459158-2145-3-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:19:18AM +0100, Leif Lindholm wrote:
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -877,6 +878,10 @@ void __init setup_arch(char **cmdline_p)
> 
>         parse_early_param();
> 
> +#ifdef CONFIG_EARLY_IOREMAP
> +       early_ioremap_init();
> +#endif

Better with a dummy early_ioremap_init() in the header when
!CONFIG_EARLY_IOREMAP to avoid the #ifdef here.

> --- /dev/null
> +++ b/arch/arm/mm/early_ioremap.c
> @@ -0,0 +1,271 @@
> +/*
> + * early_ioremap() support for ARM
> + *
> + * Based on existing support in arch/x86/mm/ioremap.c

At a very quick look, this looks really close to the x86 implementation.
Any reason why this cannot be made generic and avoid duplication?

-- 
Catalin
