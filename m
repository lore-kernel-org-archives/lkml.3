Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaJWLGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:06:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58428 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbaJWLGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:06:35 -0400
Message-ID: <5448E134.50006@arm.com>
Date: Thu, 23 Oct 2014 13:06:28 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yuyang Du <yuyang.du@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com> <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
In-Reply-To: <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
X-OriginalArrivalTime: 23 Oct 2014 11:06:30.0430 (UTC) FILETIME=[65F65BE0:01CFEEB1]
X-MC-Unique: 114102312063210601
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/14 04:21, Yuyang Du wrote:

[...]

> @@ -331,21 +330,16 @@ struct cfs_rq {
>
>   #ifdef CONFIG_SMP
>          /*
> -        * CFS Load tracking
> -        * Under CFS, load is tracked on a per-entity basis and aggregated up.
> -        * This allows for the description of both thread and group usage (in
> -        * the FAIR_GROUP_SCHED case).
> +        * CFS load tracking
>           */
> -       unsigned long runnable_load_avg, blocked_load_avg;
> -       atomic64_t decay_counter;
> -       u64 last_decay;
> -       atomic_long_t removed_load;
> +       struct sched_avg avg;
> +       unsigned long tg_load_avg_contrib;

IMHO, unsigned long tg_load_avg_contrib (former unsigned long 
tg_load_contrib) can stay under #ifdef CONFIG_FAIR_GROUP_SCHED.

> +       atomic_long_t removed_load_avg;
> +#ifndef CONFIG_64BIT
> +       u64 load_last_update_time_copy;
> +#endif
>
>   #ifdef CONFIG_FAIR_GROUP_SCHED
> -       /* Required to track per-cpu representation of a task_group */
> -       u32 tg_runnable_contrib;
> -       unsigned long tg_load_contrib;
> -
>          /*
>           *   h_load = weight * f(tg)
>           *

[...]

