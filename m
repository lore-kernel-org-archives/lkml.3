Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3FZNYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:24:34 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60197 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3FZNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <1372183863-11333-5-git-send-email-leif.lindholm@linaro.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-5-git-send-email-leif.lindholm@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 14:24:11 +0100
X-Google-Sender-Auth: p8YEOJjS6Xmrllkgwy_umFILum4
Message-ID: <CACxGe6tRBQdxN=5SrO7ES0N3R+nPeVpJDkBx5WHtKQSxPHb01Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] init: efi: arm: enable (U)EFI runtime services on arm
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 7:11 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> Since the efi_set_virtual_address_map call has strict init ordering
> requirements, add an explicit hook in the required place.
>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  init/main.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/init/main.c b/init/main.c
> index 9484f4b..c61706e 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -872,6 +872,12 @@ static noinline void __init kernel_init_freeable(void)
>         smp_prepare_cpus(setup_max_cpus);
>
>         do_pre_smp_initcalls();
> +
> +#ifdef CONFIG_ARM
> +       if (efi_enabled(EFI_RUNTIME_SERVICES))
> +               efi_enter_virtual_mode();
> +#endif

Nitpick:  Alternately you could use:

        if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_RUNTIME_SERVICES))
                efi_enter_virtual_mode();

That would get away from the #ifdef

g.
