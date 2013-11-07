Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3KGD0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:26:19 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43104 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3KGD0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:26:16 -0500
MIME-Version: 1.0
In-Reply-To: <20131106233117.GA24545@www.outflux.net>
References: <20131106233117.GA24545@www.outflux.net>
Date: Wed, 6 Nov 2013 21:26:15 -0600
Message-ID: <CABqD9hYPYei4O5gcOdAQvsSqUCY7=HhAVQ78uPHNwtTz0SbiFQ@mail.gmail.com>
Subject: Re: [PATCH] seccomp: not compatible with ARM OABI
From: Will Drewry <wad@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Eric Paris <eparis@redhat.com>,
        libseccomp-discuss@lists.sourceforge.net,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Reviewed-By: Will Drewry <wad@chromium.org>

On Wed, Nov 6, 2013 at 5:31 PM, Kees Cook <keescook@chromium.org> wrote:
> Make sure that seccomp filter won't be built when ARM OABI is in use,
> since there is work needed to distinguish calling conventions. Until
> that is done (which is likely never since OABI is deprecated), make
> sure seccomp filter is unavailable in the OABI compat world.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/Kconfig |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index af2cc6eabcc7..6eaca7d92399 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -331,12 +331,15 @@ config HAVE_ARCH_SECCOMP_FILTER
>
>  config SECCOMP_FILTER
>         def_bool y
> -       depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
> +       depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET && !OABI_COMPAT
>         help
>           Enable tasks to build secure computing environments defined
>           in terms of Berkeley Packet Filter programs which implement
>           task-defined system call filtering polices.
>
> +         Not available on ARM when built with OABI compatibility due to
> +         lack of a sensible way to distinguish the calling conventions.
> +
>           See Documentation/prctl/seccomp_filter.txt for details.
>
>  config HAVE_CONTEXT_TRACKING
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security
