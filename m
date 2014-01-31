Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaAaXF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:05:56 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:39910 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaAaXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:05:55 -0500
MIME-Version: 1.0
In-Reply-To: <d7d5035ad3b10befcd45476a4677f16fde5d1744.1391209433.git.luto@amacapital.net>
References: <d7d5035ad3b10befcd45476a4677f16fde5d1744.1391209433.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Jan 2014 15:05:34 -0800
Message-ID: <CALCETrWa2dzLNChxVO83-OHFmxn74tAxdAjAqG3B_33nHaCAZQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Zero-pad the VVAR page with zeros
To: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*sigh*.  Feel free to make the subject less dumb if you apply this.

--Andy

On Fri, Jan 31, 2014 at 3:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> This has probably been broken since the VVAR page was introduced.
> The symptom is that BIOS crud can be left behind where userspace can
> see it.  (I saw this with QEMU.)
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/kernel/vmlinux.lds.S | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index da6b35a..331a66f 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -165,6 +165,11 @@ SECTIONS
>  #undef __VVAR_KERNEL_LDS
>  #undef EMIT_VVAR
>
> +               /*
> +                * Pad the rest of the page with zeros.  Otherwise the loader
> +                * can leave garbage here.
> +                */
> +               . = __vvar_beginning_hack + PAGE_SIZE;
>         } :data
>
>         . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
> --
> 1.8.5.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
