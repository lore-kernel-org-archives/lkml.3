Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3AaQ0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:26:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3AaQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:26:15 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Enu2MCaJwL4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=btI-LddxRSIA:10 a=VnNF1IyMAAAA:8 a=aETXrrACFlTiOAtM_XkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359649573.17639.109.camel@gandalf.local.home>
Subject: Re: [PATCH] lockdep: Rename print_unlock_inbalance_bug() to
 print_unlock_imbalance_bug()
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mingo@kernel.org, peterz@infradead.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Date: Thu, 31 Jan 2013 11:26:13 -0500
In-Reply-To: <20130108130547.32733.79507.stgit@srivatsabhat.in.ibm.com>
References: <20130108130547.32733.79507.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 18:35 +0530, Srivatsa S. Bhat wrote:
> Fix the typo in the function name (s/inbalance/imbalance)
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  kernel/lockdep.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 7981e5b..5cf12e7 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3203,7 +3203,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>  }
>  
>  static int
> -print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
> +print_unlock_imbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
>  			   unsigned long ip)
>  {
>  	if (!debug_locks_off())
> @@ -3246,7 +3246,7 @@ static int check_unlock(struct task_struct *curr, struct lockdep_map *lock,
>  		return 0;
>  
>  	if (curr->lockdep_depth <= 0)
> -		return print_unlock_inbalance_bug(curr, lock, ip);
> +		return print_unlock_imbalance_bug(curr, lock, ip);
>  
>  	return 1;
>  }
> @@ -3317,7 +3317,7 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
>  			goto found_it;
>  		prev_hlock = hlock;
>  	}
> -	return print_unlock_inbalance_bug(curr, lock, ip);
> +	return print_unlock_imbalance_bug(curr, lock, ip);
>  
>  found_it:
>  	lockdep_init_map(lock, name, key, 0);
> @@ -3384,7 +3384,7 @@ lock_release_non_nested(struct task_struct *curr,
>  			goto found_it;
>  		prev_hlock = hlock;
>  	}
> -	return print_unlock_inbalance_bug(curr, lock, ip);
> +	return print_unlock_imbalance_bug(curr, lock, ip);
>  
>  found_it:
>  	if (hlock->instance == lock)


