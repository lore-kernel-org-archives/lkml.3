Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3AVBG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:06:57 -0500
Received: from mail.openrapids.net ([64.15.138.104]:33639 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751531Ab3AVBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:06:56 -0500
Date: Mon, 21 Jan 2013 20:06:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Simon Marchi <simon.marchi@polymtl.ca>
Cc: cmetcalf@tilera.com, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lttng-dev] [PATCH 2/4] tile: Add definition of NR_syscalls
Message-ID: <20130122010653.GA27148@Krystal>
References: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca> <1358816098-13070-2-git-send-email-simon.marchi@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358816098-13070-2-git-send-email-simon.marchi@polymtl.ca>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Simon Marchi (simon.marchi@polymtl.ca) wrote:
> It is required by the syscall tracepoint mechanism.
> 
> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
> ---
>  arch/tile/include/uapi/asm/unistd.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/tile/include/uapi/asm/unistd.h b/arch/tile/include/uapi/asm/unistd.h
> index cd7b6dd..c763c86 100644
> --- a/arch/tile/include/uapi/asm/unistd.h
> +++ b/arch/tile/include/uapi/asm/unistd.h
> @@ -20,6 +20,8 @@
>  /* Use the standard ABI for syscalls. */
>  #include <asm-generic/unistd.h>
>  
> +#define NR_syscalls (__NR_syscalls)

The parenthesis around __NR_syscalls seems unnecessary. (unless
parenthesis would happen to be missing around a __NR_syscalls definition
with multiple identifiers, but clearly, the parenthesis don't belong
here).

Thanks,

Mathieu

> +
>  /* Additional Tilera-specific syscalls. */
>  #define __NR_cacheflush	(__NR_arch_specific_syscall + 1)
>  __SYSCALL(__NR_cacheflush, sys_cacheflush)
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
