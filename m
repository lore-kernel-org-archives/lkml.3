Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaAOEbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:31:33 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55636 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAOEbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:31:24 -0500
Message-ID: <52D60F11.3070005@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 12:31:13 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011504-9264-0000-0000-000005479AF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alex

On 01/15/2014 12:07 PM, Alex Shi wrote:
[snip] 		}
> +#ifdef CONFIG_NO_HZ_COMMON
> +		/*
> +		 * Coarsely to get the latest idle cpu for shorter latency and
> +		 * possible power benefit.
> +		 */
> +		if (!min_load) {
> +			struct tick_sched *ts = &per_cpu(tick_cpu_sched, i);
> +
> +			s64 latest_wake = 0;

I guess we missed some code for latest_wake here?

Regards,
Michael Wang

> +			/* idle cpu doing irq */
> +			if (ts->inidle && !ts->idle_active)
> +				idlest = i;
> +			/* the cpu resched */
> +			else if (!ts->inidle)
> +				idlest = i;
> +			/* find latest idle cpu */
> +			else if (ktime_to_us(ts->idle_entrytime) > latest_wake)
> +				idlest = i;
> +		}
> +#endif
>  	}
> 
>  	return idlest;
> 

