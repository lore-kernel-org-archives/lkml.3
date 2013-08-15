Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab3HOD1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 23:27:52 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:40236 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab3HOD1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 23:27:51 -0400
Date: Wed, 14 Aug 2013 23:27:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        liwanp@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] memblock cleanup: Remove unnecessary check in
 memblock_find_in_range_node()
Message-ID: <20130815032746.GC4439@htj.dyndns.org>
References: <1376536999-4562-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376536999-4562-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tang.

On Thu, Aug 15, 2013 at 11:23:19AM +0800, Tang Chen wrote:
> Furthermore, we don't need to check "if (this_end < size)" actually. Without
> this confusing check, we only waste some loops. So this patch removes the
> check.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  mm/memblock.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index a847bfe..e0c626e 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -114,9 +114,6 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>  		this_start = clamp(this_start, start, end);
>  		this_end = clamp(this_end, start, end);
>  
> -		if (this_end < size)
> -			continue;
> -
>  		cand = round_down(this_end - size, align);
>  		if (cand >= this_start)
>  			return cand;

Hmmm... maybe I'm missing something but are you sure?  "this_end -
size" can underflow and "cand >= this_start" will be true incorrectly.

Thanks.

-- 
tejun
