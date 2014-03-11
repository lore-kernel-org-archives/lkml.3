Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaCKVpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:45:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43259 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbaCKVpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:45:53 -0400
Message-ID: <531F83D4.1000500@zytor.com>
Date: Tue, 11 Mar 2014 14:44:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
CC: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Dynamically relocate the compat vdso
References: <7708c7e74155af17548b3737de81495888685760.1394573523.git.luto@amacapital.net>
In-Reply-To: <7708c7e74155af17548b3737de81495888685760.1394573523.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 02:33 PM, Andy Lutomirski wrote:
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 1aa9ccd..943f166 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -214,13 +214,8 @@
>  #ifdef CONFIG_X86_64
>  #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
>  #else
> -/*
> - * For PDE_IDENT_ATTR include USER bit. As the PDE and PTE protection
> - * bits are combined, this will alow user to access the high address mapped
> - * VDSO in the presence of CONFIG_COMPAT_VDSO
> - */
>  #define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
> -#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
> +#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+USER+DIRTY+ACCESSED */
>  #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
>  #endif
>  

Please make this hunk a separate patch for bisecting reasons.

	-hpa

