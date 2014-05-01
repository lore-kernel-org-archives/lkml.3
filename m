Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaEANT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:19:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33002 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbaEANT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:19:56 -0400
Message-ID: <536249D6.3020008@ti.com>
Date: Thu, 1 May 2014 09:19:18 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob, Russell,

On Thursday 24 April 2014 11:30 AM, Santosh Shilimkar wrote:
> Here is an updated v3 of the series. Series introduces support for setting up
> dma parameters based on device tree properties like 'dma-ranges' and
> 'dma-coherent' and also update to ARM 32 bit port. Earlier version of the
> series can be found here [3], [2] and [1].
> 
> The 'dma-ranges' helps to take care of few DMAable system memory restrictions
> by use of dma_pfn_offset which we maintain now per device. Arch code then
> uses it for dma address translations for such cases. We update the
> dma_pfn_offset accordingly during DT the device creation process.The
> 'dma-coherent' property is used to setup arch's coherent dma_ops.
> 
> Hopefully with acks, tested-by this version can get into 3.16 queue. I will
> post a followup series for Keystone SOC which will use this infrastructure.
> Linus W also wants to use this for ARM integrator platform dma offset issue.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Grygorii Strashko (2):
>   of: introduce of_dma_get_range() helper
>   ARM: dma: Use dma_pfn_offset for dma address translation
> 
> Santosh Shilimkar (5):
>   device: introduce per device dma_pfn_offset
>   of: introduce of_dma_is_coherent() helper
>   of: configure the platform device dma parameters
>   ARM: dma: implement set_arch_dma_coherent_ops()
>   ARM: dma: use phys_addr_t in __dma_page_[cpu_to_dev/dev_to_cpu]
> 
>  arch/arm/include/asm/dma-mapping.h |   28 ++++++++++--
>  arch/arm/mm/dma-mapping.c          |    4 +-
>  drivers/of/address.c               |   87 ++++++++++++++++++++++++++++++++++++
>  drivers/of/platform.c              |   71 +++++++++++++++++++++++++++--
>  include/linux/device.h             |    2 +
>  include/linux/dma-mapping.h        |    7 +++
>  include/linux/of_address.h         |    8 ++++
>  include/linux/of_platform.h        |    6 +++
>  8 files changed, 204 insertions(+), 9 deletions(-)
> 
How do we go about merging this series ? There is a dependency
between the patches and hence the question.

> 
> [1] http://www.spinics.net/lists/arm-kernel/msg311678.html
> [2] https://lkml.org/lkml/2014/3/6/186
> [3] https://lkml.org/lkml/2014/4/19/80
> 

