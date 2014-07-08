Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaGHDEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:04:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58182 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaGHDEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:04:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BB5F9A.2060105@roeck-us.net>
Date: Mon, 07 Jul 2014 20:03:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Nick <xerofoify@gmail.com>
Subject: Re: [PATCH] powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
References: <1404153930-26568-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1404153930-26568-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ...

Ben, I know this is not perfect, but on the other side it is simple
and would be easy to backport. With this in place, a complete/clean
fix would not be as urgent. Any chance to get it applied ?

Nick, this doesn't fix the allyesconfig build - it still fails with
relocation errors. But it does fix the allmodconfig build.

Thanks,
Guenter

On 06/30/2014 11:45 AM, Guenter Roeck wrote:
> powerpc:allmodconfig has been failing for some time with the following
> error.
>
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards
> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
>
> A number of attempts to fix the problem by moving around code have been
> unsuccessful and resulted in failed builds for some configurations and
> the discovery of toolchain bugs.
>
> Fix the problem by disabling RELOCATABLE for COMPILE_TEST builds instead.
> While this is less than perfect, it avoids substantial code changes
> which would otherwise be necessary just to make COMPILE_TEST builds
> happy and might have undesired side effects.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   arch/powerpc/Kconfig | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index bd6dd6e..fefe7c8 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -414,7 +414,7 @@ config KEXEC
>   config CRASH_DUMP
>   	bool "Build a kdump crash kernel"
>   	depends on PPC64 || 6xx || FSL_BOOKE || (44x && !SMP)
> -	select RELOCATABLE if PPC64 || 44x || FSL_BOOKE
> +	select RELOCATABLE if (PPC64 && !COMPILE_TEST) || 44x || FSL_BOOKE
>   	help
>   	  Build a kernel suitable for use as a kdump capture kernel.
>   	  The same kernel binary can be used as production kernel and dump
> @@ -1017,6 +1017,7 @@ endmenu
>   if PPC64
>   config RELOCATABLE
>   	bool "Build a relocatable kernel"
> +	depends on !COMPILE_TEST
>   	select NONSTATIC_KERNEL
>   	help
>   	  This builds a kernel image that is capable of running anywhere
>

