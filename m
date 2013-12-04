Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3LDXwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:52:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55508 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3LDXwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:52:35 -0500
Message-ID: <529F797A.6010107@jp.fujitsu.com>
Date: Wed, 04 Dec 2013 13:50:34 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: fweisbec@gmail.com, tglx@linutronix.de, mingo@kernel.org
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 02/10] posix-timers: Remove dead process posix cpu timers
 caching
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com> <1385221040-24731-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1385221040-24731-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1090,13 +1063,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
>  			timer->it.cpu.expires = 0;
>  			goto out_unlock;
>  		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
> -			/*
> -			 * We've noticed that the thread is dead, but
> -			 * not yet reaped.  Take this opportunity to
> -			 * drop our task ref.
> -			 */
> +			/* Optimizations: if the process is dying, no need to rearm */
>  			cpu_timer_sample_group(timer->it_clock, p, &now);

Why do we still need to call cpu_timer_sample_group? You removed to below line which uses
"now".

> -			clear_dead_task(timer, now);
>  			goto out_unlock;
>  		}
>  		spin_lock(&p->sighand->siglock);
> 

