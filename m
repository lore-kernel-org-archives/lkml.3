Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaGaHCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:02:42 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34112 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaGaHCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:02:40 -0400
Date: Thu, 31 Jul 2014 00:02:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Chintan Pandya <cpandya@codeaurora.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: BUG when __kmap_atomic_idx equals KM_TYPE_NR
In-Reply-To: <1406787871-2951-1-git-send-email-cpandya@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1407310001360.18238@chino.kir.corp.google.com>
References: <1406787871-2951-1-git-send-email-cpandya@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Chintan Pandya wrote:

> __kmap_atomic_idx is per_cpu variable. Each CPU can
> use KM_TYPE_NR entries from FIXMAP i.e. from 0 to
> KM_TYPE_NR - 1. Allowing __kmap_atomic_idx to over-
> shoot to KM_TYPE_NR can mess up with next CPU's 0th
> entry which is a bug. Hence BUG_ON if
> __kmap_atomic_idx >= KM_TYPE_NR.
> 

This appears to be a completely different patch, not a v2.  Why is this 
check only done for CONFIG_DEBUG_HIGHMEM?

I think Andrew's comment earlier was referring to the changelog only and 
not the patch, which looked correct.

> Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
> ---
> Changes:
> 
> V1 --> V2
> 
> 	Not touching CONFIG_DEBUG_HIGHMEM.
> 
>  include/linux/highmem.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 7fb31da..9286a46 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -93,7 +93,7 @@ static inline int kmap_atomic_idx_push(void)
>  
>  #ifdef CONFIG_DEBUG_HIGHMEM
>  	WARN_ON_ONCE(in_irq() && !irqs_disabled());
> -	BUG_ON(idx > KM_TYPE_NR);
> +	BUG_ON(idx >= KM_TYPE_NR);
>  #endif
>  	return idx;
>  }
