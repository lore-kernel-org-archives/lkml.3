Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaIWKog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:44:36 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40464 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaIWKof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:44:35 -0400
Date: Tue, 23 Sep 2014 12:44:31 +0200
From: Robert Richter <rric@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Robert Richter <rrichter@cavium.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64, defconfig: Increase NR_CPUS default to 64
Message-ID: <20140923104431.GF20170@rric.localhost>
References: <1410176689-20020-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410176689-20020-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.09.14 13:44:48, Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> Raising the current maximum limit to 64. This is needed for Cavium's
> Thunder systems that will have at least 48 cores per die.
> 
> The change keeps the current memory footprint in cpu mask structures.
> It does not break existing code. Setting the maximum to 64 cpus still
> boots systems with less cpus.
> 
> Mark's Juno happily booted with a NR_CPUS=64 kernel.
> 
> Tested on our Thunder system with 48 cores. We could see interrupts to
> all cores.

Catalin, Will,

please consider applying this patch.

Thanks,

-Robert

> 
> Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
>  arch/arm64/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fd4e81a4e1ce..67fca2ea81a7 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -252,11 +252,11 @@ config SCHED_SMT
>  	  places. If unsure say N here.
>  
>  config NR_CPUS
> -	int "Maximum number of CPUs (2-32)"
> -	range 2 32
> +	int "Maximum number of CPUs (2-64)"
> +	range 2 64
>  	depends on SMP
>  	# These have to remain sorted largest to smallest
> -	default "8"
> +	default "64"
>  
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
> -- 
> 2.0.1
> 
