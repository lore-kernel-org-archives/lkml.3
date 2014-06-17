Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaFQBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:25:28 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63349 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaFQBZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:25:27 -0400
Date: Mon, 16 Jun 2014 18:25:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Guenter Roeck <linux@roeck-us.net>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] powerpc: Fix build warning
In-Reply-To: <1402677499-28289-1-git-send-email-linux@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1406161824340.21018@chino.kir.corp.google.com>
References: <1402677499-28289-1-git-send-email-linux@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Guenter Roeck wrote:

> If compiled with W=1, the following warning is seen in powerpc builds.
> 
> arch/powerpc/kernel/smp.c:750:18: warning:
> 	type qualifiers ignored on function return type
> static const int powerpc_smt_flags(void)
>                  ^
> 
> This is caused by a function returning 'const int', which doesn't
> make sense to gcc. Drop 'const' to fix the problem.
> 
> Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: David Rientjes <rientjes@google.com>

Although it's strange you report this happening on line 750 in the 
changelog but the patch shows it differently.

> ---
>  arch/powerpc/kernel/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 10ffffe..49d5d4e 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -768,7 +768,7 @@ int setup_profiling_timer(unsigned int multiplier)
>  
>  #ifdef CONFIG_SCHED_SMT
>  /* cpumask of CPUs with asymetric SMT dependancy */
> -static const int powerpc_smt_flags(void)
> +static int powerpc_smt_flags(void)
>  {
>  	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
>  
