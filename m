Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab3H2P5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:57:41 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:35833 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3H2P5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:57:39 -0400
Date: Thu, 29 Aug 2013 11:57:36 -0400 (EDT)
From: Lenny Szubowicz <lszubowi@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
Message-ID: <410604531.9664777.1377791856786.JavaMail.root@redhat.com>
In-Reply-To: <1376933171-9854-9-git-send-email-matthew.garrett@nebula.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com> <1376933171-9854-9-git-send-email-matthew.garrett@nebula.com>
Subject: Re: [PATCH V2 08/10] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF17 (Linux)/8.0.3_GA_5664)
Thread-Topic: kexec: Disable at runtime if the kernel enforces module loading restrictions
Thread-Index: pJyVwwZQoT2C3MBBHAN0lKUWpEp8CQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Matthew Garrett" <matthew.garrett@nebula.com>
> To: linux-kernel@vger.kernel.org
> Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org, "Matthew Garrett"
> <matthew.garrett@nebula.com>
> Sent: Monday, August 19, 2013 1:26:09 PM
> Subject: [PATCH V2 08/10] kexec: Disable at runtime if the kernel enforces module loading restrictions
> 
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
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (kexec_image->preserve_context) {
>  		lock_system_sleep();
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Shouldn't that be:

+	if (secure_modules()) {
+		error = -EPERM;
+		goto Unlock;
+	}

-Lenny.
