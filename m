Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3D2Wwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:52:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:28140 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190Ab3D2Ww3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:52:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,576,1363158000"; 
   d="scan'208";a="326227441"
Message-ID: <517EF9AB.8080508@linux.intel.com>
Date: Mon, 29 Apr 2013 15:52:27 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 07/10] futex: use freezable blocking call
References: <1367271946-7239-1-git-send-email-ccross@android.com> <1367271946-7239-8-git-send-email-ccross@android.com>
In-Reply-To: <1367271946-7239-8-git-send-email-ccross@android.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin,

I don't know anything about when or when not to use freezable*, and I
suspect that may be true for others as well. A more complete
description of why it's acceptable here in the commit log might help
expedite acceptance.


Matt,

I have a vague memory of discussing something similar to this with you.
Do you see any potential problems here?

--
Darren

On 04/29/2013 02:45 PM, Colin Cross wrote:
> Avoid waking up every thread sleeping in a futex_wait call during
> suspend and resume by calling a freezable blocking call.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  kernel/futex.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index b26dcfc..d710fae 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -61,6 +61,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/ptrace.h>
>  #include <linux/sched/rt.h>
> +#include <linux/freezer.h>
>  
>  #include <asm/futex.h>
>  
> @@ -1807,7 +1808,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
>  		 * is no timeout, or if it has yet to expire.
>  		 */
>  		if (!timeout || timeout->task)
> -			schedule();
> +			freezable_schedule();
>  	}
>  	__set_current_state(TASK_RUNNING);
>  }
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
