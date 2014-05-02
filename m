Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaEBA6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 20:58:24 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61383 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaEBA6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 20:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <1398353407-2345-7-git-send-email-santosh.shilimkar@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<1398353407-2345-7-git-send-email-santosh.shilimkar@ti.com>
Date: Thu, 1 May 2014 19:58:22 -0500
Message-ID: <CAL_JsqLwerrkCeNsADy0Z=HWwEOWw9eUS+tOfbEgdaCce5GtbQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] ARM: dma: implement set_arch_dma_coherent_ops()
From: Rob Herring <robherring2@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:30 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> Implement the set_arch_dma_coherent_ops() for ARM architecture.
>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Reviewed-by: Rob Herring <robh@kernel.org>

> ---
>  arch/arm/include/asm/dma-mapping.h |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 424fda9..1965cd8 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -118,6 +118,13 @@ static inline unsigned long dma_max_pfn(struct device *dev)
>  }
>  #define dma_max_pfn(dev) dma_max_pfn(dev)
>
> +static inline int set_arch_dma_coherent_ops(struct device *dev)
> +{
> +       set_dma_ops(dev, &arm_coherent_dma_ops);
> +       return 0;
> +}
> +#define set_arch_dma_coherent_ops(dev) set_arch_dma_coherent_ops(dev)
> +
>  static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
>  {
>         unsigned int offset = paddr & ~PAGE_MASK;
> --
> 1.7.9.5
>
