Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaDHX5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:57:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55499 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbaDHX5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:57:13 -0400
Message-ID: <53448CB4.6050705@infradead.org>
Date: Tue, 08 Apr 2014 16:56:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, Eric Ernst <eric.ernst@intel.com>
Subject: Re: [PATCH 1/2] watchdog: add Intel MID watchdog driver support
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com> <1396990744-10695-2-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1396990744-10695-2-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 01:59 PM, David Cohen wrote:
> Add initial Intel MID watchdog driver support.
> 
> This driver is an initial implementation of generic Intel MID watchdog
> driver. Currently it supports Intel Merrifield platform.
> 
> Signed-off-by: Eric Ernst <eric.ernst@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/watchdog/Kconfig         |  12 +++
>  drivers/watchdog/Makefile        |   1 +
>  drivers/watchdog/intel-mid_wdt.c | 209 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 222 insertions(+)
>  create mode 100644 drivers/watchdog/intel-mid_wdt.c
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 79d25894343a..4da09b8b2f11 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -643,6 +643,18 @@ config INTEL_SCU_WATCHDOG
>  
>  	  To compile this driver as a module, choose M here.
>  
> +config INTEL_MID_WATCHDOG
> +	bool "Intel MID SCU Watchdog Mobile Platforms"
> +	depends on X86_INTEL_MID && WATCHDOG_CORE
> +	---help---
> +	  Watchdog timer driver built into the Intel SCU for Intel MID
> +	  Platforms.
> +
> +	  This driver currently supports only the watchdog evolution
> +	  implementation in SCU, available for Merrifield generation.
> +
> +	  To compile this driver as a module, choose M here.

Does choosing M work when INTEL_MID_WATCHDOG is a bool?
and why is INTEL_MID_WATCHDOG a bool?

> +
>  config ITCO_WDT
>  	tristate "Intel TCO Timer/Watchdog"
>  	depends on (X86 || IA64) && PCI


-- 
~Randy
