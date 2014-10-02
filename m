Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaJBQZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:25:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaJBQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:25:54 -0400
Message-ID: <542D7C06.1070501@redhat.com>
Date: Thu, 02 Oct 2014 12:23:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul McQuade <paulmcquad@gmail.com>
CC: akpm@linux-foundation.org, hughd@google.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fremap use linux header
References: <1412264057-3146-1-git-send-email-paulmcquad@gmail.com>
In-Reply-To: <1412264057-3146-1-git-send-email-paulmcquad@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 11:34 AM, Paul McQuade wrote:
> Use #include <linux/mmu_context.h> instead of <asm/mmu_context.h>

linux/mmu_context.h does not include asm/mmu_context.h

This leads me to believe that either fremap.c does not use
any definitions from either mmu_context.h file, or after
your change the code that fremap.c needs is no longer directly
included (but only imported indirectly due to sheer luck).

Could you verify which of these is the case?

If fremap.c is not using any code from mmu_context.h, we are
better off simply removing that line, instead of replacing it
with an unnecessary include...

> diff --git a/mm/fremap.c b/mm/fremap.c
> index 72b8fa3..d614f1c 100644
> --- a/mm/fremap.c
> +++ b/mm/fremap.c
> @@ -1,6 +1,6 @@
>  /*
>   *   linux/mm/fremap.c
> - * 
> + *
>   * Explicit pagetable population and nonlinear (random) mappings support.
>   *
>   * started by Ingo Molnar, Copyright (C) 2002, 2003
> @@ -16,8 +16,8 @@
>  #include <linux/rmap.h>
>  #include <linux/syscalls.h>
>  #include <linux/mmu_notifier.h>
> +#include <linux/mmu_context.h>
>  
> -#include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>
>  #include <asm/tlbflush.h>
>  
> 

