Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab3FLWZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:25:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42070 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3FLWZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:25:08 -0400
Message-ID: <51B8F4AF.2070801@zytor.com>
Date: Wed, 12 Jun 2013 15:22:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, pageexec@freemail.hu, tglx@linutronix.de,
        hpa@linux.intel.com
Subject: Re: [tip:x86/urgent] x86: Fix typo in kexec register clearing
References: <20130605184718.GA8396@www.outflux.net> <tip-c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1@git.kernel.org>
In-Reply-To: <tip-c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1@git.kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 03:21 PM, tip-bot for Kees Cook wrote:
> Commit-ID:  c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1
> Gitweb:     http://git.kernel.org/tip/c8a22d19dd238ede87aa0ac4f7dbea8da039b9c1
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Wed, 5 Jun 2013 11:47:18 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 12 Jun 2013 15:16:18 -0700
> 
> x86: Fix typo in kexec register clearing
> 
> Fixes a typo in register clearing code. Thanks to PaX Team for fixing
> this originally, and James Troup for pointing it out.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: http://lkml.kernel.org/r/20130605184718.GA8396@www.outflux.net
> Cc: <stable@vger.kernel.org> v2.6.30+
> Cc: PaX Team <pageexec@freemail.hu>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/kernel/relocate_kernel_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
> index 7a6f3b3..f2bb9c9 100644
> --- a/arch/x86/kernel/relocate_kernel_64.S
> +++ b/arch/x86/kernel/relocate_kernel_64.S
> @@ -160,7 +160,7 @@ identity_mapped:
>  	xorq    %rbp, %rbp
>  	xorq	%r8,  %r8
>  	xorq	%r9,  %r9
> -	xorq	%r10, %r9
> +	xorq	%r10, %r10
>  	xorq	%r11, %r11
>  	xorq	%r12, %r12
>  	xorq	%r13, %r13
> 

As an aside: using xorq here is totally pointless; xorl would work just
fine.

	-hpa

