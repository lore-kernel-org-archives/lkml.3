Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaAXQpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:45:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50784 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbaAXQo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:44:59 -0500
Date: Fri, 24 Jan 2014 16:43:43 +0000
From: Will Deacon <will.deacon@arm.com>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/6] ARM: Make PID_IN_CONTEXTIDR incompatible with
 PID_NS
Message-ID: <20140124164343.GJ31040@mudshark.cambridge.arm.com>
References: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
 <1390581656-16372-5-git-send-email-adrienverge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390581656-16372-5-git-send-email-adrienverge@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 04:40:54PM +0000, Adrien Vergé wrote:
> When using namespaces, different processes can have the same PID.
> It makes no sense to store a PID value in the Context ID register
> to track a specific process, when others share the same value.
> 
> Consequently, PID_IN_CONTEXTIDR (which is used for tracing and
> debugging processes) should not be compatible with PID_NS.
> 
> Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
> ---
>  arch/arm/Kconfig.debug   | 2 +-
>  arch/arm64/Kconfig.debug | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 5765abf..ed46748 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -1143,7 +1143,7 @@ config ARM_KPROBES_TEST
>  
>  config PID_IN_CONTEXTIDR
>  	bool "Write the current PID to the CONTEXTIDR register"
> -	depends on CPU_COPY_V6
> +	depends on CPU_COPY_V6 && !PID_NS
>  	help
>  	  Enabling this option causes the kernel to write the current PID to
>  	  the PROCID field of the CONTEXTIDR register, at the expense of some
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 835c559..06b2633b 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -17,6 +17,7 @@ config EARLY_PRINTK
>  
>  config PID_IN_CONTEXTIDR
>  	bool "Write the current PID to the CONTEXTIDR register"
> +	depends on !PID_NS
>  	help
>  	  Enabling this option causes the kernel to write the current PID to
>  	  the CONTEXTIDR register, at the expense of some additional

Are you sure about this? The value we write is actually task_pid_nr, which I
believe to be globally unique.

Will
