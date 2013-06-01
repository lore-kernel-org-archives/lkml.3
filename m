Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3FAJav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:30:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49406 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3FAJao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:30:44 -0400
Date: Sat, 1 Jun 2013 11:30:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Fix warnings and errors
 on with CONFIG_MICROCODE=m
Message-ID: <20130601093034.GA18886@nazgul.tnic>
References: <20130531150241.GA12006@jshin-Toonie>
 <tip-6b3389ac21b5e557b957f1497d0ff22bf733e8c3@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-6b3389ac21b5e557b957f1497d0ff22bf733e8c3@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 02:59:20PM -0700, tip-bot for Jacob Shin wrote:
> Commit-ID:  6b3389ac21b5e557b957f1497d0ff22bf733e8c3
> Gitweb:     http://git.kernel.org/tip/6b3389ac21b5e557b957f1497d0ff22bf733e8c3
> Author:     Jacob Shin <jacob.shin@amd.com>
> AuthorDate: Fri, 31 May 2013 01:53:24 -0500
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 31 May 2013 13:56:58 -0700
> 
> x86, microcode, amd: Fix warnings and errors on with CONFIG_MICROCODE=m
> 
> Fix section mismatch warnings on microcode_amd_early.
> Compile error occurs when CONFIG_MICROCODE=m, change so that early
> loading depends on microcode_core.
> 
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> Link: http://lkml.kernel.org/r/20130531150241.GA12006@jshin-Toonie
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/Kconfig                      | 2 +-
>  arch/x86/include/asm/microcode_amd.h  | 2 +-
>  arch/x86/kernel/microcode_amd_early.c | 8 ++++----
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 28dba52..2705532 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1065,7 +1065,7 @@ config MICROCODE_AMD_EARLY
>  
>  config MICROCODE_EARLY
>  	bool "Early load microcode"
> -	depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
> +	depends on MICROCODE=y && BLK_DEV_INITRD

This means now though, distros will have to build in microcode support
(not a module anymore) in order to get early ucode loading support.

I'm not saying this is necessarily a bad thing - actually, I even think
we want to make the microcode glue in the kernel not be a module anymore
because it doesn't hurt and modern CPUs will definitely rather need
microcode than not, so we'd need that functionality unconditionally...

Thanks.
