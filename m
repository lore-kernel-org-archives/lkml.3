Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab3BFVPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:15:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039Ab3BFVPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:15:32 -0500
Message-ID: <5112C7CC.6040803@redhat.com>
Date: Wed, 06 Feb 2013 16:14:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 2/4] Expand the steal time msr to also contain the consigned
 time.
References: <20130205214818.4615.12937.stgit@lambeau> <20130205214920.4615.29831.stgit@lambeau>
In-Reply-To: <20130205214920.4615.29831.stgit@lambeau>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 04:49 PM, Michael Wolf wrote:
> Expand the steal time msr to also contain the consigned time.
>
> Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
> ---
>   arch/x86/include/asm/paravirt.h       |    4 ++--
>   arch/x86/include/asm/paravirt_types.h |    2 +-
>   arch/x86/kernel/kvm.c                 |    7 ++-----
>   kernel/sched/core.c                   |   10 +++++++++-
>   kernel/sched/cputime.c                |    2 +-
>   5 files changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 5edd174..9b753ea 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -196,9 +196,9 @@ struct static_key;
>   extern struct static_key paravirt_steal_enabled;
>   extern struct static_key paravirt_steal_rq_enabled;
>
> -static inline u64 paravirt_steal_clock(int cpu)
> +static inline void paravirt_steal_clock(int cpu, u64 *steal)
>   {
> -	return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
> +	PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
>   }

This may be a stupid question, but what happens if a KVM
guest with this change, runs on a kernel that still has
the old steal time interface?

What happens if the host has the new steal time interface,
but the guest uses the old interface?

Will both cases continue to work as expected with your
patch series?

If so, could you document (in the source code) why things
continue to work?

