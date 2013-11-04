Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3KDJPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:15:44 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33056 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592Ab3KDJPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:15:42 -0500
Message-ID: <527765BC.5010904@free-electrons.com>
Date: Mon, 04 Nov 2013 10:15:40 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: ben-linux@fluff.org, kgene.kim@samsung.com, linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] ARM: S3C24XX: remove unused Kconfig parameter
References: <1383463529-3113-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1383463529-3113-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 08:25 AM, Michael Opdenacker wrote:
> This removes the MACH_S3C2413 Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/arm/mach-s3c24xx/Kconfig | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index dba2173e70f3..9d90dd06cf2f 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -415,13 +415,6 @@ config MACH_JIVE_SHOW_BOOTLOADER
>  	bool "Allow access to bootloader partitions in MTD"
>  	depends on MACH_JIVE
>  
> -config MACH_S3C2413
> -	bool
> -	help
> -	  Internal node for S3C2413 version of SMDK2413, so that
> -	  machine_is_s3c2413() will work when MACH_SMDK2413 is
> -	  selected
> -
>  config MACH_SMDK2412
>  	bool "SMDK2412"
>  	select MACH_SMDK2413

Actually, in another thread, Sascha Hauer made me realize that this
symbol is actually used to make machine_is_s3c2413() become true when
the kernel is started with the corresponding machine id.

However, this patch doesn't hurt as machine_is_s3c2413() isn't used in
the code.

You can either keep it or wait for s3c2413 support to be removed or to
be converted to the device tree.

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

