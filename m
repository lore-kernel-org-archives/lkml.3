Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaGGU6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:58:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62209 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750809AbaGGU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:58:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 4/4] ACPI: Make EC debugfs depend on X86 || IA64 in Kconfig
Date: Mon, 07 Jul 2014 23:16:11 +0200
Message-ID: <200683000.sgUJl2AyWR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404290847-7671-5-git-send-email-hanjun.guo@linaro.org>
References: <1404290847-7671-1-git-send-email-hanjun.guo@linaro.org> <1404290847-7671-5-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 02, 2014 04:47:26 PM Hanjun Guo wrote:
> Since EC (Embedded controller) needs SCI for the interupt which
> is not available on ARM64, make the EC debugfs depend on X86 || IA64
> only in the Kconfig file.
> 
> Reviewed-by: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/acpi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 0e6f72d..7de5e3f 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -69,6 +69,7 @@ config ACPI_PROCFS_POWER
>  
>  config ACPI_EC_DEBUGFS
>  	tristate "EC read/write access through /sys/kernel/debug/ec"
> +	depends on X86 || IA64

This is totally inconsistent with the other patches in the series where you
define per-arch symbols for similar things.  In addition to that, do we need
to build ec.c on ARM at all?

>  	default n
>  	help
>  	  Say N to disable Embedded Controller /sys/kernel/debug interface
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
