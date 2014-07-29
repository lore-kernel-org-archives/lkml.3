Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaG2QVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:21:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44005 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaG2QVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:21:02 -0400
Message-ID: <53D7C9EE.60503@wwwdotorg.org>
Date: Tue, 29 Jul 2014 10:21:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Move AHB Kconfig to drivers/amba
References: <1406643934-16301-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1406643934-16301-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 08:25 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> This will allow the Kconfig option to be shared among 32-bit and 64-bit
> ARM.

This seems fine to me. I'd expect to apply it for 3.18, provided I get 
an ack from Russell as drivers/amba maintainer (hence CCing him without 
trimming the quote).

> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>   arch/arm/mach-tegra/Kconfig |  8 --------
>   drivers/amba/Kconfig        | 11 +++++++++++
>   2 files changed, 11 insertions(+), 8 deletions(-)
>   create mode 100644 drivers/amba/Kconfig
>
> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> index 052fba07a3cb..fae2eb2f52ea 100644
> --- a/arch/arm/mach-tegra/Kconfig
> +++ b/arch/arm/mach-tegra/Kconfig
> @@ -64,12 +64,4 @@ config ARCH_TEGRA_124_SOC
>   	  Support for NVIDIA Tegra T124 processor family, based on the
>   	  ARM CortexA15MP CPU
>
> -config TEGRA_AHB
> -	bool "Enable AHB driver for NVIDIA Tegra SoCs"
> -	default y
> -	help
> -	  Adds AHB configuration functionality for NVIDIA Tegra SoCs,
> -	  which controls AHB bus master arbitration and some
> -	  performance parameters(priority, prefech size).
> -
>   endif
> diff --git a/drivers/amba/Kconfig b/drivers/amba/Kconfig
> new file mode 100644
> index 000000000000..3f7350a03708
> --- /dev/null
> +++ b/drivers/amba/Kconfig
> @@ -0,0 +1,11 @@
> +if ARM_AMBA
> +
> +config TEGRA_AHB
> +	bool "Enable AHB driver for NVIDIA Tegra SoCs"
> +	default y if ARCH_TEGRA
> +	help
> +	  Adds AHB configuration functionality for NVIDIA Tegra SoCs,
> +	  which controls AHB bus master arbitration and some performance
> +	  parameters (priority, prefetch size).
> +
> +endif
>

