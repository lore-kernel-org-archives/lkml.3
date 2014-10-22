Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaJVQpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:45:15 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47240 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaJVQpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:45:10 -0400
Date: Wed, 22 Oct 2014 17:44:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Message-ID: <20141022164454.GI15370@e104818-lin.cambridge.arm.com>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 05:06:23PM +0100, mathieu.poirier@linaro.org wrote:
> +#if __LINUX_ARM_ARCH__ >= 5

My old ARMv5 book does not list LDRD/STRD. It looks like they only come
with ARMv5TE. Are there any processors prior to this supported by the
kernel?

> +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
> +{
> +	asm volatile("strd %1, %0"
> +		     : "+Qo" (*(volatile u64 __force *)addr)
> +		     : "r" (val));
> +}
> +
> +static inline u64 __raw_readq(const volatile void __iomem *addr)
> +{
> +	u64 val;
> +	asm volatile("ldrd %1, %0"
> +		     : "+Qo" (*(volatile u64 __force *)addr),
> +		       "=r" (val));
> +	return val;
> +}
> +#endif

I'm curious why you need these. Do you have a device that needs a 64-bit
single access or you are trying to read two consecutive registers?

-- 
Catalin
