Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaC3GeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 02:34:15 -0400
Received: from www84.your-server.de ([213.133.104.84]:41039 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaC3GeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 02:34:13 -0400
Message-ID: <1396161217.32686.1.camel@vger.seibold.net>
Subject: Re: [PATCH] x86: Fix the symbol versions on the 32-bit vDSO
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 30 Mar 2014 08:33:37 +0200
In-Reply-To: <0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net>
References: <0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 29.03.2014, 13:15 -0700 schrieb Andy Lutomirski:
> The new symbols provide the same API as the 64-bit variants, so they
> should have the same symbol version name.  This can't break
> userspace, since these symbols are new for 32-bit Linux.
> 

This breaks my glibc patch... What is the benefit for doing this in that
way?

> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/vdso/vdso32/vdso32.lds.S | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
> index 28c4607..aadb8b9 100644
> --- a/arch/x86/vdso/vdso32/vdso32.lds.S
> +++ b/arch/x86/vdso/vdso32/vdso32.lds.S
> @@ -23,14 +23,18 @@ ENTRY(__kernel_vsyscall);
>   */
>  VERSION
>  {
> +	LINUX_2.6 {
> +	global:
> +		__vdso_clock_gettime;
> +		__vdso_gettimeofday;
> +		__vdso_time;
> +	};
> +
>  	LINUX_2.5 {
>  	global:
>  		__kernel_vsyscall;
>  		__kernel_sigreturn;
>  		__kernel_rt_sigreturn;
> -		__vdso_clock_gettime;
> -		__vdso_gettimeofday;
> -		__vdso_time;
>  	local: *;
>  	};
>  }


