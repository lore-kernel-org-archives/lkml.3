Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3HEK40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:56:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33216 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089Ab3HEK4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:56:24 -0400
Date: Mon, 5 Aug 2013 11:56:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com,
        tony.luck@gmail.com, patches@linaro.org
Subject: Re: [PATCH v2 1/5] ia64: add early_memremap() alias for
 early_ioremap()
Message-ID: <20130805105620.GO2515@console-pimps.org>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
 <1375462582-16423-2-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375462582-16423-2-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug, at 05:56:18PM, Leif Lindholm wrote:
> early_ioremap() on IA64 chooses its mapping type based on the EFI
> memory map. This patch adds an alias "early_memremap()" to be used
> where the targeted location is memory rather than an i/o device.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/ia64/include/asm/io.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
> index 74a7cc3..0d2bcb3 100644
> --- a/arch/ia64/include/asm/io.h
> +++ b/arch/ia64/include/asm/io.h
> @@ -424,6 +424,7 @@ extern void __iomem * ioremap(unsigned long offset, unsigned long size);
>  extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
>  extern void iounmap (volatile void __iomem *addr);
>  extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
> +#define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
>  extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
>  static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)

Tony, can I get your Acked-by for this?

-- 
Matt Fleming, Intel Open Source Technology Center
