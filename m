Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3GJNLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:11:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:6275 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3GJNLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="363122043"
Message-ID: <51DD5D63.7000602@linux.intel.com>
Date: Wed, 10 Jul 2013 06:10:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 8/9] sched: power: Add initial frequency scaling
 support to power scheduler
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <1373385338-12983-9-git-send-email-morten.rasmussen@arm.com>
In-Reply-To: <1373385338-12983-9-git-send-email-morten.rasmussen@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> Extends the power scheduler capacity management algorithm to handle
> frequency scaling and provide basic frequency/P-state selection hints
> to the power driver.
>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> ---
>   kernel/sched/power.c |   33 ++++++++++++++++++++++++++++-----
>   1 file changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/sched/power.c b/kernel/sched/power.c
> index 9e44c0e..5fc32b0 100644
> --- a/kernel/sched/power.c
> +++ b/kernel/sched/power.c
> @@ -21,6 +21,8 @@
>
>   #define INTERVAL 5 /* ms */
>   #define CPU_FULL 90 /* Busy %-age - TODO: Make tunable */
> +#define CPU_TARGET 80 /* Target busy %-age - TODO: Make tunable */
> +#define CPU_EMPTY 5 /* Idle noise %-age - TODO: Make tunable */
>

to be honest, this is the policy part that really should be in the hardware specific driver
and not in the scheduler.
(even if said driver is sort of a "generic library" kind of thing)



