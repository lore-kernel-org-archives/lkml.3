Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaH2Sv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:51:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbaH2Sv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:51:57 -0400
Date: Fri, 29 Aug 2014 14:51:42 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        khlebnikov@openvz.org, riel@redhat.com, mgorman@suse.de,
        mhocko@suse.cz, hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] Introduce VM_BUG_ON_VMA
Message-ID: <20140829185142.GB12774@nhori.bos.redhat.com>
References: <1409324059-28692-1-git-send-email-sasha.levin@oracle.com>
 <1409324059-28692-2-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409324059-28692-2-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:54:18AM -0400, Sasha Levin wrote:
> Very similar to VM_BUG_ON_PAGE but dumps VMA information instead.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  include/linux/mmdebug.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index dfb9333..569e4c8 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -20,12 +20,20 @@ void dump_vma(const struct vm_area_struct *vma);
>  			BUG();						\
>  		}							\
>  	} while (0)
> +#define VM_BUG_ON_VMA(cond, vma)					\
> +	do {								\
> +		if (unlikely(cond)) {					\
> +			dump_vma(vma);					\
> +			BUG();						\
> +		}							\
> +	} while (0)
>  #define VM_WARN_ON(cond) WARN_ON(cond)
>  #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
>  #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
>  #else
>  #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
>  #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
> +#define VM_BUG_ON_VMA(cond, vma) VM_BUG_ON(cond)
>  #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
