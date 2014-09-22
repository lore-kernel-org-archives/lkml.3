Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaIVSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:25:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60006 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaIVSZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:25:57 -0400
X-Originating-IP: 75.92.167.159
Date: Mon, 22 Sep 2014 11:25:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Mark D Rustad <mark.d.rustad@intel.com>
Cc: sparse@chrisli.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        richard.weinberger@gmail.com, linux-sparse@vger.kernel.org,
        mingo@redhat.com, jeffrey.t.kirsher@intel.com,
        computersforpeace@gmail.com
Subject: Re: [PATCH] sched: Remove nested extern
Message-ID: <20140922182544.GA27107@thin>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:55:11AM -0700, Mark D Rustad wrote:
> Avoid W=2 nested-externs warning by moving the nested extern to
> a normal extern. This eliminates that warning which is generated
> for every inclusion of sched.h in a kernel build when W=2 is used.
> This also removes a point of maintenance if the definition of
> delayacct_on were ever to change.
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>

This seems sensible, and makes much more sense than wrapping the extern
in a directive to disable warnings.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/delayacct.h |    1 -
>  include/linux/sched.h     |    3 ++-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/delayacct.h b/include/linux/delayacct.h
> index 6cee17c22313..51229790af00 100644
> --- a/include/linux/delayacct.h
> +++ b/include/linux/delayacct.h
> @@ -30,7 +30,6 @@
>  
>  #ifdef CONFIG_TASK_DELAY_ACCT
>  
> -extern int delayacct_on;	/* Delay accounting turned on/off */
>  extern struct kmem_cache *delayacct_cache;
>  extern void delayacct_init(void);
>  extern void __delayacct_tsk_init(struct task_struct *);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5c2c885ee52b..1f1dcfdcd92c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -825,6 +825,8 @@ struct task_delay_info {
>  	u64 freepages_delay;	/* wait for memory reclaim */
>  	u32 freepages_count;	/* total count of memory reclaim */
>  };
> +
> +extern int delayacct_on;	/* Delay accounting turned on/off */
>  #endif	/* CONFIG_TASK_DELAY_ACCT */
>  
>  static inline int sched_info_on(void)
> @@ -832,7 +834,6 @@ static inline int sched_info_on(void)
>  #ifdef CONFIG_SCHEDSTATS
>  	return 1;
>  #elif defined(CONFIG_TASK_DELAY_ACCT)
> -	extern int delayacct_on;
>  	return delayacct_on;
>  #else
>  	return 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
