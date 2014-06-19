Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbaFSOSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:18:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60437 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073AbaFSOSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:18:05 -0400
Date: Thu, 19 Jun 2014 16:17:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org
Subject: Re: [PATCH v3 1/5] apei, mce: Factor out APEI architecture specific
 MCE calls.
Message-ID: <20140619141758.GD22025@pd.tnic>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
 <1402657380-18539-2-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402657380-18539-2-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 01:02:56PM +0200, Tomasz Nowicki wrote:
> This commit abstracts MCE calls and provides weak corresponding default
> implementation for those architectures which do not need arch specific
> actions. Each platform willing to do additional architectural actions
> should provides desired function definition. It allows us to avoid wrap
> code into #ifdef in generic code and prevent new platform from introducing
> dummy stub function too.
> 
> Initially, there are two APEI arch-specific calls:
> - apei_arch_enable_cmcff()
> - apei_arch_report_mem_error()
> Both interact with MCE driver for X86 architecture.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>

...

> diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
> new file mode 100644
> index 0000000..dca2852
> --- /dev/null
> +++ b/arch/x86/kernel/acpi/apei.c
> @@ -0,0 +1,56 @@
> +/*
> + * Arch-specific APEI-related functions.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <acpi/apei.h>
> +
> +#include <asm/mce.h>
> +
> +int apei_arch_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data)

Arch-specific function names usually use the "arch_" prefix. Otherwise
it looks ok.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
