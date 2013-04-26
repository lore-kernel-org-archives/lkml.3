Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3DZWNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:13:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46993 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab3DZWNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:13:09 -0400
Date: Sat, 27 Apr 2013 00:13:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 6/6] x86: kaslr: report kernel offset on panic
Message-ID: <20130426221301.GA26059@pd.tnic>
References: <1367003005-5560-7-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1367003005-5560-7-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 12:03:25PM -0700, Kees Cook wrote:
> When the system panics, include the kernel offset in the report to assist
> in debugging.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/kernel/setup.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index fae9134..95a33b1 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -830,6 +830,18 @@ static void __init trim_low_memory_range(void)
>  }
>  	
>  /*
> + * Dump out kernel offset information on panic.
> + */
> +static int
> +dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
> +{
> +	pr_emerg("Kernel Offset: 0x%lx\n",
> +		 (unsigned long)&_text - __START_KERNEL);

So what's wrong with subtracting the offset from the function addresses
on the stack so that traces can show the addresses as they are in
vmlinux, completely agnostic of any randomization?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
