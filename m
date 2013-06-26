Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3FZNa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:30:56 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:45214 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3FZNay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 14:30:34 +0100
X-Google-Sender-Auth: QHh3GkEnXIqFAorBNNEar4R4V88
Message-ID: <CACxGe6u+8ac2a2EzAvTvo53xOHNU=14ve+8oMYe3_a4vO38VEQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86: efi: break efi_lookup_mapped_addr out to generic code
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 7:11 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> efi_lookup_mapped_addr is a handy helper function for translating
> a physical address to the corresponding virtual one by scanning
> through memmap.map.
>
> This patch breaks it out into a new file for use elsewhere.
>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/x86/platform/efi/efi.c       |   28 ----------------------------
>  drivers/firmware/efi/Makefile     |    2 +-
>  drivers/firmware/efi/efi-helper.c |   33 +++++++++++++++++++++++++++++++++
>  3 files changed, 34 insertions(+), 29 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-helper.c

I /think/ you should be able to put this directly into
drivers/firmware/efi/efi.c

> diff --git a/drivers/firmware/efi/efi-helper.c b/drivers/firmware/efi/efi-helper.c
> new file mode 100644
> index 0000000..c5c2c72
> --- /dev/null
> +++ b/drivers/firmware/efi/efi-helper.c
> @@ -0,0 +1,33 @@
> +/*
> + * Common [U]EFI support helper functions across architectures.
> + */
> +
> +#include <linux/efi.h>
> +
> +/*
> + * We can't ioremap data in EFI boot services RAM, because we've already mapped
> + * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
> + * callable after efi_enter_virtual_mode and before efi_free_boot_services.
> + */
> +void __iomem *efi_lookup_mapped_addr(u64 phys_addr)

Can be __init annotated. Although it's a good idea to do that in a
separate patch.

Otherwise looks good to me.

Reviewed-by: Grant Likely <grant.likely@linaro.org>
