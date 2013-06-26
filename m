Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3FZOIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:08:53 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:43867 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751359Ab3FZOIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:08:52 -0400
Date: Wed, 26 Jun 2013 15:07:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arch: arm64: include: asm: add pci.h to pass compiling
Message-ID: <20130626140730.GB23309@arm.com>
References: <51CA5F71.207@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51CA5F71.207@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 04:26:41AM +0100, Chen Gang wrote:
> Need add pci.h for compiling, the related error (with allmodconfig):
> 
>   drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_exit’:
>   drivers/media/usb/b2c2/flexcop-usb.c:393:3: error: implicit declaration of function ‘pci_free_consistent’ [-Werror=implicit-function-declaration]
>   drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_init’:
>   drivers/media/usb/b2c2/flexcop-usb.c:410:2: error: implicit declaration of function ‘pci_alloc_consistent’ [-Werror=implicit-function-declaration]
>   drivers/media/usb/b2c2/flexcop-usb.c:410:21: warning: assignment makes pointer from integer without a cast [enabled by default]
>   cc1: some warnings being treated as errors
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/include/asm/pci.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm64/include/asm/pci.h
> 
> diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> new file mode 100644
> index 0000000..2ed467f
> --- /dev/null
> +++ b/arch/arm64/include/asm/pci.h
> @@ -0,0 +1,11 @@
> +#ifndef ASMARM64_PCI_H
> +#define ASMARM64_PCI_H
> +
> +#ifdef __KERNEL__
> +
> +#include <asm-generic/pci-dma-compat.h>
> +#include <asm-generic/pci.h>
> +
> +#endif /* __KERNEL__ */
> +
> +#endif

I wonder whether it makes sense to include pci-dma-compat.h in
asm-generic/pci.h, I don't see why one would want the generic pci.h but
not the generic pci-dma-compat.h (cc'ing Arnd).

-- 
Catalin
