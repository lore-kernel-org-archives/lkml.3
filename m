Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaDVGFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:05:53 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:57029 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaDVGFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:05:48 -0400
Date: Tue, 22 Apr 2014 08:05:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: behanw@converseincode.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu
Subject: Re: [PATCH] x86: LLVMLinux: Wrap -mno-80387 with cc-option
Message-ID: <20140422060544.GA9133@gmail.com>
References: <1398145227-25053-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398145227-25053-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* behanw@converseincode.com <behanw@converseincode.com> wrote:

> From: Behan Webster <behanw@converseincode.com>
> 
> Wrap -mno-80387 gcc options with cc-option so they don't break clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  arch/x86/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index d1b7c37..ce6ad7e 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -83,7 +83,9 @@ else
>          KBUILD_CFLAGS += -m64
>  
>          # Don't autogenerate traditional x87, MMX or SSE instructions
> -        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
> +        KBUILD_CFLAGS += -mno-mmx -mno-sse
> +        KBUILD_CFLAGS += $(call cc-option,-mno-80387)
> +        KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)

Is there a clang equivalent option that inhibits all things FPU opcode 
generation by the compiler?

That's the general purpose of -no-80387.

Thanks,

	Ingo
