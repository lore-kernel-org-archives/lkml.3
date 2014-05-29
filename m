Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbaE2Enw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:43:52 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:61010 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbaE2Ent (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:43:49 -0400
Message-ID: <5386BB13.1070908@gmail.com>
Date: Thu, 29 May 2014 00:44:03 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: peterz@infradead.org, paulmck@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/1] rename {before/after}_atomic_{inc/dec} to
 {before/after}_atomic
References: <5386B75A.3010806@gmail.com>
In-Reply-To: <5386B75A.3010806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 12:28 AM, Pranith Kumar wrote:

> diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
> index 3031bac..a5635ad 100644
> --- a/kernel/sched/cpupri.c
> +++ b/kernel/sched/cpupri.c
> @@ -164,7 +164,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
>  		 * do a write memory barrier, and then update the count, to
>  		 * make sure the vector is visible when count is set.
>  		 */
> -		smp_mb__before_atomic_inc();
> +		smp_mb__before_atomic();
>  		atomic_inc(&(vec)->count);
>  		do_mb = 1;
>  	}
> @@ -184,14 +184,14 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
>  		 * the new priority vec.
>  		 */
>  		if (do_mb)
> -			smp_mb__after_atomic_inc();
> +			smp_mb__after_atomic();
>  
>  		/*
>  		 * When removing from the vector, we decrement the counter first
>  		 * do a memory barrier and then clear the mask.
>  		 */
>  		atomic_dec(&(vec)->count);
> -		smp_mb__after_atomic_inc();
> +		smp_mb__after_atomic();
>  		cpumask_clear_cpu(cpu, vec->mask);
>  	}
>  

We should at the least fix this :)



