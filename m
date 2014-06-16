Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaFPOwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:52:51 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58420 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaFPOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:52:49 -0400
Date: Mon, 16 Jun 2014 15:52:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH RESEND] mfd: Fix cs5535 dependencies
Message-ID: <20140616145237.GA14323@lee--X1>
References: <20140616135415.7f879f1e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140616135415.7f879f1e@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Jean Delvare wrote:

> As far as I know, the CS5535 and CS5536 chipsets are companions of the
> Geode series of processors, which are 32-bit only. So the CS5535
> drivers are not needed on x86-64, except for build testing purpose.
> 
> This aligns the dependencies to what FB_GEODE already uses.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
> Patch already sent on: 2014-03-07

Applied, thanks.

>  drivers/mfd/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-3.14-rc5.orig/drivers/mfd/Kconfig	2014-03-07 21:43:13.739818995 +0100
> +++ linux-3.14-rc5/drivers/mfd/Kconfig	2014-03-07 21:43:59.262786389 +0100
> @@ -13,7 +13,7 @@ config MFD_CORE
>  config MFD_CS5535
>  	tristate "AMD CS5535 and CS5536 southbridge core functions"
>  	select MFD_CORE
> -	depends on PCI && X86
> +	depends on PCI && (X86_32 || (X86 && COMPILE_TEST))
>  	---help---
>  	  This is the core driver for CS5535/CS5536 MFD functions.  This is
>            necessary for using the board's GPIO and MFGPT functionality.
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
