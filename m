Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3H2SLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab3H2SLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:11:01 -0400
Date: Thu, 29 Aug 2013 14:10:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        jwboyer@redhat.com, keescook@chromium.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH V2 08/10] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Message-ID: <20130829181052.GA8697@redhat.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
 <1376933171-9854-9-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376933171-9854-9-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 01:26:09PM -0400, Matthew Garrett wrote:
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that module signing enforcement is meant to prevent. It makes
> sense to disable kexec in this situation.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  kernel/kexec.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f7b55..1a7690f 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -32,6 +32,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/swap.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/module.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -1645,6 +1646,9 @@ int kernel_kexec(void)
>  		goto Unlock;
>  	}
>  
> +	if (secure_modules())
> +		return -EPERM;
> +

Hi Matthew, 

Why do disallow this at run time. To me denying this at kexec_load() time
sounds better. Otherwise a user will think that I loaded crash kernel
successfully and when crash actually happens, we never capture the
crash dump.

Thanks
Vivek
