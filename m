Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3LSUOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:14:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35770 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab3LSUOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:14:08 -0500
Message-ID: <52B35369.6070208@zytor.com>
Date: Thu, 19 Dec 2013 12:13:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@kernel.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        peterz@infradead.org, rui.zhang@intel.com, bitbucket@online.de,
        rafael.j.wysocki@intel.com, lenb@kernel.org, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/idle] x86, acpi, idle: Restructure the mwait idle routines
References: <20131212141654.616820819@infradead.org> <tip-16824255394f55adf31b9a96a9965d8c15bdac4c@git.kernel.org>
In-Reply-To: <tip-16824255394f55adf31b9a96a9965d8c15bdac4c@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 12:09 PM, tip-bot for Peter Zijlstra wrote:
> diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
> index 8f181b3..e8275f2 100644
> --- a/drivers/thermal/intel_powerclamp.c
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -438,9 +438,7 @@ static int clamp_thread(void *arg)
>  			 */
>  			local_touch_nmi();
>  			stop_critical_timings();
> -			__monitor((void *)&current_thread_info()->flags, 0, 0);
> -			cpu_relax(); /* allow HT sibling to run */
> -			__mwait(eax, ecx);
> +			mwait_idle_with_hints(eax, ecx);
>  			start_critical_timings();
>  			atomic_inc(&idle_wakeup_counter);
>  		}
> 

Should this cpu_relax() be in the common code as well?

	-hpa

