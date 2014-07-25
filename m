Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaGYX2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:28:15 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:63680 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaGYX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:28:14 -0400
MIME-Version: 1.0
In-Reply-To: <e4c8bf4bc2725bda22c4a4b7d0c82adcd8f8d9b8.1406330779.git.luto@amacapital.net>
References: <e4c8bf4bc2725bda22c4a4b7d0c82adcd8f8d9b8.1406330779.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 25 Jul 2014 16:27:52 -0700
Message-ID: <CALCETrXiv4JX6_V72D=3zpD0ozpnZWwEQnSQapQ_zNrWSbhz6A@mail.gmail.com>
Subject: Re: [PATCH] x86,vdso: Set VM_MAYREAD for the vvar vma
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 4:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> AFAIK this has no effect whatsoever unless x86 suddenly turns into a
> nommu architecture.  Nonetheless, not setting it is suspicious.

Sorry, forgot to mention: this is based on tip/x86/vdso.

--Andy

>
> Reported-by: Nathan Lynch <Nathan_Lynch@mentor.com>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/vdso/vma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index dbef622..970463b 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -138,7 +138,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
>         vma = _install_special_mapping(mm,
>                                        addr,
>                                        -image->sym_vvar_start,
> -                                      VM_READ,
> +                                      VM_READ|VM_MAYREAD,
>                                        &vvar_mapping);
>
>         if (IS_ERR(vma)) {
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
