Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab3EHQDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:03:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34450 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab3EHQDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:53 -0400
Message-ID: <518A7763.4050509@arm.com>
Date: Wed, 08 May 2013 17:03:47 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH v3 3/4] arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING
 and pv_time_ops
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com> <1368027714-14506-3-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1368027714-14506-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 08 May 2013 16:03:47.0843 (UTC) FILETIME=[9FB6D530:01CE4C05]
X-MC-Unique: 113050817035017001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 08/05/13 16:41, Stefano Stabellini wrote:
> Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM.
> 
> The only paravirt interface supported is pv_time_ops.steal_clock, so no
> runtime pvops patching needed.
> 
> This allows us to make use of steal_account_process_tick for stolen
> ticks accounting.
> 
> Changes in v3:
> - improve commit description and Kconfig help text;
> - no need to initialize pv_time_ops;
> - add PARAVIRT_TIME_ACCOUNTING.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: linux@arm.linux.org.uk
> CC: will.deacon@arm.com
> CC: nico@linaro.org
> CC: marc.zyngier@arm.com
> CC: cov@codeaurora.org
> CC: arnd@arndb.de
> CC: olof@lixom.net
> ---
>  arch/arm/Kconfig                |   20 ++++++++++++++++++++
>  arch/arm/include/asm/paravirt.h |   19 +++++++++++++++++++
>  arch/arm/kernel/Makefile        |    1 +
>  arch/arm/kernel/paravirt.c      |   25 +++++++++++++++++++++++++
>  4 files changed, 65 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/include/asm/paravirt.h
>  create mode 100644 arch/arm/kernel/paravirt.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 344e299..89ee2f1 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1887,12 +1887,32 @@ config XEN_DOM0
>  	def_bool y
>  	depends on XEN
>  
> +config PARAVIRT
> +	bool "Enable paravirtualization code"
> +	---help---
> +	  This changes the kernel so it can modify itself when it is run
> +	  under a hypervisor, potentially improving performance significantly
> +	  over full virtualization.
> +
> +config PARAVIRT_TIME_ACCOUNTING
> +	bool "Paravirtual steal time accounting"
> +	select PARAVIRT

Surely you meant "depends on" instead of "select" here? Otherwise I
don't really see the point of PARAVIRT...

> +	default n
> +	---help---
> +	  Select this option to enable fine granularity task steal time
> +	  accounting. Time spent executing other tasks in parallel with
> +	  the current vCPU is discounted from the vCPU power. To account for
> +	  that, there can be a small performance impact.
> +
> +	  If in doubt, say N here.
> +
>  config XEN
>  	bool "Xen guest support on ARM (EXPERIMENTAL)"
>  	depends on ARM && AEABI && OF
>  	depends on CPU_V7 && !CPU_V6
>  	depends on !GENERIC_ATOMIC64
>  	select ARM_PSCI
> +	select PARAVIRT
>  	help
>  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
>  
-- 
Jazz is not dead. It just smells funny...

