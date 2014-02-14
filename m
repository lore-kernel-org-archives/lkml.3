Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaBNJLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:11:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41418 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaBNJKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:10:33 -0500
Date: Fri, 14 Feb 2014 10:10:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [tip:x86/asmlinkage] lto: Make asmlinkage __visible
Message-ID: <20140214091024.GA26664@pd.tnic>
References: <1391846481-31491-3-git-send-email-ak@linux.intel.com>
 <tip-128ea04a9885af9629059e631ddf0cab4815b589@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-128ea04a9885af9629059e631ddf0cab4815b589@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 08:30:37PM -0800, tip-bot for Andi Kleen wrote:
> Commit-ID:  128ea04a9885af9629059e631ddf0cab4815b589
> Gitweb:     http://git.kernel.org/tip/128ea04a9885af9629059e631ddf0cab4815b589
> Author:     Andi Kleen <ak@linux.intel.com>
> AuthorDate: Sat, 8 Feb 2014 09:01:07 +0100
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 13 Feb 2014 20:21:59 -0800
> 
> lto: Make asmlinkage __visible
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Link: http://lkml.kernel.org/r/1391846481-31491-3-git-send-email-ak@linux.intel.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  include/linux/linkage.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
> index a6a42dd..34a513a 100644
> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -12,9 +12,9 @@
>  #endif
>  
>  #ifdef __cplusplus
> -#define CPP_ASMLINKAGE extern "C"
> +#define CPP_ASMLINKAGE extern "C" __visible
>  #else
> -#define CPP_ASMLINKAGE
> +#define CPP_ASMLINKAGE __visible
>  #endif
>  
>  #ifndef asmlinkage
> --

arch/x86/crypto/sha256_ssse3_glue.c:56:1: warning: ‘externally_visible’ attribute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
 ^
arch/x86/crypto/sha512_ssse3_glue.c:55:1: warning: ‘externally_visible’ attribute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);


I guess it is trying to tell me that static function pointers cannot be
__visible:

static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);

and

static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
