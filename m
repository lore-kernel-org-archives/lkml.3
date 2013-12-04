Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3LDIyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:54:53 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38617 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3LDIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:54:52 -0500
Date: Wed, 4 Dec 2013 09:54:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, kevin.b.smith@intel.com, hjl.tools@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-64, build: Always pass in -mno-sse
Message-ID: <20131204085448.GA31778@gmail.com>
References: <tip-j21wzqv790q834n7yc6g80j1@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-j21wzqv790q834n7yc6g80j1@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for H. Peter Anvin <tipbot@zytor.com> wrote:

> Commit-ID:  5551a34e5aeab868f8d37f70d8754868921b4ee5
> Gitweb:     http://git.kernel.org/tip/5551a34e5aeab868f8d37f70d8754868921b4ee5
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Wed, 20 Nov 2013 13:31:49 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 3 Dec 2013 17:40:22 -0800
> 
> x86-64, build: Always pass in -mno-sse
> 
> Always pass in the -mno-sse argument, regardless if
> -preferred-stack-boundary is supported.  We never want to generate SSE
> instructions in the kernel unless we *really* know what we're doing.
> 
> According to H. J. Lu, any version of gcc new enough that we support
> it at all should handle the -mno-sse option, so just add it
> unconditionally.
> 
> Reported-by: Kevin B. Smith <kevin.b.smith@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: H. J. Lu <hjl.tools@gmail.com>
> Link: http://lkml.kernel.org/n/tip-j21wzqv790q834n7yc6g80j1@git.kernel.org
> Cc: <stable@vger.kernel.org> # build fix only
> ---
>  arch/x86/Makefile | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 41250fb..eda00f9 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -31,6 +31,9 @@ ifeq ($(CONFIG_X86_32),y)
>  
>          KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
>  
> +        # Don't autogenerate SSE instructions
> +	KBUILD_CFLAGS += -mno-sse
> +
>          # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
>          # with nonstandard options
>          KBUILD_CFLAGS += -fno-pic
> @@ -57,8 +60,11 @@ else
>          KBUILD_AFLAGS += -m64
>          KBUILD_CFLAGS += -m64
>  
> +        # Don't autogenerate SSE instructions
> +	KBUILD_CFLAGS += -mno-sse
> +
>  	# Use -mpreferred-stack-boundary=3 if supported.
> -	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
> +	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
>  
>          # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
>          cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)

Just a detail I noticed: in kbuild we intentionally use 8 spaces for 
tabs in Makefiles and only use tabs for commands where tabs are 
required.

The above code introduces tabs in the middle of 8-space sequences. It 
works but is inconsistent.

Thanks,

	Ingo
