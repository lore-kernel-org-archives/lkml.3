Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbaIQRlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbaIQRlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:41:22 -0400
Date: Wed, 17 Sep 2014 19:38:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH 1/1 linux-next] ptrace: remove linux/compat.h inclusion
	under CONFIG_COMPAT
Message-ID: <20140917173840.GB19308@redhat.com>
References: <1410896530-18082-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410896530-18082-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16, Fabian Frederick wrote:
>
> Commit 84c751bd4aeb
> ("ptrace: add ability to retrieve signals without removing from a queue (v4)")
> includes <linux/compat.h> globally in ptrace.c
>
> This patch removes inclusion under if defined CONFIG_COMPAT.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Oleg Nesterov <oleg@redhat.com>

Hopefully Andrew can take this patch.

> ---
>  kernel/ptrace.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 54e7522..d4f8e3e 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1094,7 +1094,6 @@ int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
>  }
>  
>  #if defined CONFIG_COMPAT
> -#include <linux/compat.h>
>  
>  int compat_ptrace_request(struct task_struct *child, compat_long_t request,
>  			  compat_ulong_t addr, compat_ulong_t data)
> -- 
> 2.1.0
> 

