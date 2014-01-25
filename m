Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaAYHrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 02:47:43 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46357 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaAYHrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 02:47:42 -0500
Date: Sat, 25 Jan 2014 08:47:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>, Adrian Hunter <adrian.hunter@intel.com>
Cc: crash-utility@redhat.com, linux-kernel@vger.kernel.org,
        Dave Anderson <anderson@redhat.com>, Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] x86, kaslr: export offset in VMCOREINFO ELF notes
Message-ID: <20140125074738.GB10565@gmail.com>
References: <20140123173120.GA25474@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123173120.GA25474@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> From: Eugene Surovegin <surovegin@google.com>
> 
> Include kASLR offset in VMCOREINFO ELF notes to assist in debugging.
> 
> Signed-off-by: Eugene Surovegin <surovegin@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - make sure "From:" got sent correctly
> ---
>  arch/x86/kernel/machine_kexec_64.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 4eabc160696f..679cef0791cd 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -279,5 +279,7 @@ void arch_crash_save_vmcoreinfo(void)
>  	VMCOREINFO_SYMBOL(node_data);
>  	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
>  #endif
> +	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
> +			      (unsigned long)&_text - __START_KERNEL);
>  }

I've Cc:-ed Adrian Hunter, who has sent the following kaslr fixes for 
perf yesterday:

  http://lkml.org/lkml/2014/1/24/220

Adrian, is this patch the right solution from the perf tooling 
perspective?

Thanks,

	Ingo
