Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab3B0OEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:04:14 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60429 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3B0OEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:04:12 -0500
Message-ID: <512E1259.5020903@gmail.com>
Date: Wed, 27 Feb 2013 08:04:09 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: linux-mmc@vger.kernel.org, grant.likely@secretlab.ca, rob@landley.net,
        linux@arm.linux.org.uk, nsekhar@ti.com, hs@denx.de,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, cjb@laptop.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/5] ARM: davinci: da850: override mmc DT node device
 name
References: <1360909322-1858-1-git-send-email-prakash.pm@ti.com> <1360909322-1858-6-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1360909322-1858-6-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 12:22 AM, Manjunathappa, Prakash wrote:
> Populate OF_DEV_AUXDATA with desired device name expected by
> davinci_mmc driver. Without this clk_get of davinci_mmc DT driver
> fails.
> 
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: cjb@laptop.org
> Cc: Sekhar Nori <nsekhar@ti.com>
> ---
> Since v2:
> Rebased on top of v3.9/dt-2 branch of linux_davinci and reordered this patch.
> 
>  arch/arm/mach-davinci/da8xx-dt.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> index 5404e92..2b740a9 100644
> --- a/arch/arm/mach-davinci/da8xx-dt.c
> +++ b/arch/arm/mach-davinci/da8xx-dt.c
> @@ -40,6 +40,8 @@ static void __init da8xx_init_irq(void)
>  struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
>  	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
>  	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
> +	OF_DEV_AUXDATA("ti,davinci-mmc-da830", 0x01c40000, "davinci-mmc-da830.0",
> +			NULL),

If you only need clock lookup, just add a clkdev entry with the new name.

Rob
