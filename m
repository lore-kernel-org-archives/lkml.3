Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaBUUZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:25:30 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57678 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaBUUZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:25:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140123173120.GA25474@www.outflux.net>
References: <20140123173120.GA25474@www.outflux.net>
Date: Fri, 21 Feb 2014 12:25:27 -0800
X-Google-Sender-Auth: Gxj0XV4li9rHH_g_UZP57oZF5ww
Message-ID: <CAGXu5jK0UK5Aj4henG2uZevrjj576JQp13ZRKGkgNMDV8BeQsw@mail.gmail.com>
Subject: Re: [PATCH v2] x86, kaslr: export offset in VMCOREINFO ELF notes
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Anderson <anderson@redhat.com>, Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 9:31 AM, Kees Cook <keescook@chromium.org> wrote:
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
>         VMCOREINFO_SYMBOL(node_data);
>         VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
>  #endif
> +       vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
> +                             (unsigned long)&_text - __START_KERNEL);
>  }
>
> --
> 1.7.9.5

Ping on this patch. The crash-utils folks would like to be using this feature.

-Kees

-- 
Kees Cook
Chrome OS Security
