Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3GXROV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:14:21 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54830 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3GXROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:14:19 -0400
Date: Wed, 24 Jul 2013 22:43:47 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
Message-ID: <20130724171347.GB29756@naverao1-tp.watson.ibm.com>
References: <1374526866-6813-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374526866-6813-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072417-5490-0000-0000-000003E0DF85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/07/22 11:01PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> [    5.525861] ERST: Can not request iomem region <0x        c7eff000-0x        c7f00000> for ERST.
> 
> This needs to have leading zeroes. Make it so.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/acpi/apei/erst.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index 88d0b0f9f92b..1126afeb7e22 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -1168,7 +1168,7 @@ static int __init erst_init(void)
>  	r = request_mem_region(erst_erange.base, erst_erange.size, "APEI ERST");
>  	if (!r) {
>  		pr_err(ERST_PFX
> -		"Can not request iomem region <0x%16llx-0x%16llx> for ERST.\n",
> +		"Can not request iomem region <0x%016llx-0x%016llx> for ERST.\n",
>  		(unsigned long long)erst_erange.base,
>  		(unsigned long long)erst_erange.base + erst_erange.size);
>  		rc = -EIO;

Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

While looking at this, I noticed that we seem to be using varying field
widths in our APEI code:
- einj.c has two instances using %#010llx.
- apei-base.c uses widths of 10 (4 bytes) and 6 (2 bytes).

Not sure if these are intentional and those fields truly aren't 64-bit
(as suggested by the usage of long long int).


Regards,
Naveen

> -- 
> 1.8.3
> 

