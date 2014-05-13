Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaEMTlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:41:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57962 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaEMTlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:41:35 -0400
Date: Tue, 13 May 2014 21:41:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 4/7] acpi, apei, ghes: Factor out NMI error notification
 context.
Message-ID: <20140513194125.GD8760@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-5-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397056476-9183-5-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:14:32PM +0200, Tomasz Nowicki wrote:
> Use CONFIG_ACPI_APEI_NMI to isolate NMI error notification path. NMI related
> data and functions are grouped so they can be wrapped inside one
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  drivers/acpi/apei/ghes.c |   54 +++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index ca8387e..7a0d66e 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -53,7 +53,9 @@
>  #include <asm/mce.h>
>  #endif
>  #include <asm/tlbflush.h>
> +#ifdef CONFIG_ACPI_APEI_NMI
>  #include <asm/nmi.h>
> +#endif

This, again, can be avoided with adding arch-specific versions and empty
default stubs.

>  #include "apei-internal.h"

...
-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
