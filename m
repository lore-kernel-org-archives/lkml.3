Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550Ab3JPRY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:24:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54104 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761005Ab3JPRYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:24:25 -0400
Date: Wed, 16 Oct 2013 19:24:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/9] ACPI, APEI, CPER: Cleanup CPER memory error
 output format
Message-ID: <20131016172410.GM13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-9-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381935366-11731-9-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:56:05AM -0400, Chen, Gong wrote:
> Keep up only the most important fields for memory error
> reporting. The detail information will be moved to perf/trace
> interface.
> 
> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/apei/cper.c | 69 +++++++++++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index b1a8a55..f5bc227 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -33,6 +33,9 @@
>  #include <linux/pci.h>
>  #include <linux/aer.h>
>  
> +#define INDENT_SP	" "
> +#define HW_CE_INFO \
> +	"Above error has been corrected by h/w and no further action required"

Leftover?


> +	if (severity != CPER_SEV_FATAL)
> +		printk("%s%s\n", pfx,
> +		       "Above error has been corrected by h/w "
> +		       "and require no further action");

Let's write it out and correct grammar:

"Above error has been corrected by the hardware and requires no further action."

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
