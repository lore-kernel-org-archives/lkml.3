Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab3HNSX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab3HNSXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:23:55 -0400
Date: Wed, 14 Aug 2013 21:24:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 07/13] Add might_fault_debug_only()
Message-ID: <20130814182438.GA19640@redhat.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <1376089460-5459-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376089460-5459-8-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 04:04:14PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a might_fault_debug_only() that only does something in the PROVE_LOCKING
> case, but does not cond_resched for PREEMPT_VOLUNTARY. This is for
> cases when the cond_resched is done elsewhere
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/sched.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 773f21d..bb7a08a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2473,11 +2473,13 @@ static inline void cond_resched_rcu(void)
>  
>  #ifdef CONFIG_PROVE_LOCKING
>  void might_fault(void);
> +#define might_fault_debug_only() might_fault()
>  #else
>  static inline void might_fault(void)
>  {
>  	might_sleep();
>  }
> +#define might_fault_debug_only() do {} while(0)

Hi Andy, this is against which kernel version?
In 3.11-rc3 I see:

#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
void might_fault(void);
#else
static inline void might_fault(void) { }
#endif

So it's not clear to me how it's different from your might_fault_debug_only ..


>  #endif
>  
>  /*
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
