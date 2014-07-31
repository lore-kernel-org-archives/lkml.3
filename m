Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaGaFbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:31:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaGaFbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:31:35 -0400
Message-ID: <53D9D4B2.8070008@suse.de>
Date: Thu, 31 Jul 2014 07:31:30 +0200
From: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: behanw@converseincode.com, ard.biesheuvel@linaro.org,
        catalin.marinas@arm.com, k.khlebnikov@samsung.com, olof@lixom.net,
        peterz@infradead.org, takahiro.akashi@linaro.org, tglx@linutronix.de,
        will.deacon@arm.com
CC: linux-kernel@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>,
        dwmw2@infradead.org, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] arm64: LLVMLinux: Calculate current_thread_info from
 current_stack_pointer
References: <1406764649-20326-1-git-send-email-behanw@converseincode.com> <1406764649-20326-4-git-send-email-behanw@converseincode.com>
In-Reply-To: <1406764649-20326-4-git-send-email-behanw@converseincode.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 31.07.2014 01:57, schrieb behanw@converseincode.com:
> From: Behan Webster <behanw@converseincode.com>
> 
> Use the global current_stack_pointer to get the value of the stack pointer.
> This change supports being able to compile the kernel with both gcc and clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Reviewed-by: Jan-Simon M??ller <dl9pf@gmx.de>

Something went wrong with ö encoding here and in 2/4.

> ---
>  arch/arm64/include/asm/thread_info.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index e6b6094..c2432d2 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -80,8 +80,8 @@ static inline struct thread_info *current_thread_info(void) __attribute_const__;
>  
>  static inline struct thread_info *current_thread_info(void)
>  {
> -	register unsigned long sp asm ("sp");
> -	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
> +	return (struct thread_info *) \

This is not a macro, so \ seems superfluous.

Looks okay otherwise.

Regards,
Andreas

> +		(current_stack_pointer & ~(THREAD_SIZE - 1));
>  }
>  
>  #define thread_saved_pc(tsk)	\

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
