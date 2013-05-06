Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3EFI4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:56:05 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43327 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3EFI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <51876E92.3010300@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-2-git-send-email-alex.shi@intel.com> <CAPM31R+4Ar5FFGSgfts76qNiQ5GMpPk7wkuj1fwsFrugVwnLfQ@mail.gmail.com>
 <51876E92.3010300@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 01:55:31 -0700
Message-ID: <CAPM31RLOHcDGJy6bpXeMN90+NpGNkKS=32Wyq5r0LkdGb=SKkQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] Revert "sched: Introduce temporary
 FAIR_GROUP_SCHED dependency for load-tracking"
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 1:49 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/06/2013 04:24 PM, Paul Turner wrote:
>>> >         /*
>>> >          * CFS Load tracking
>>> >          * Under CFS, load is tracked on a per-entity basis and aggregated up.
>>> > @@ -242,8 +236,7 @@ struct cfs_rq {
>>> >         u64 runnable_load_avg, blocked_load_avg;
>>> >         atomic64_t decay_counter, removed_load;
>>> >         u64 last_decay;
>>> > -#endif /* CONFIG_FAIR_GROUP_SCHED */
>>> > -/* These always depend on CONFIG_FAIR_GROUP_SCHED */
>> We should perhaps replace this with a comment that these are only
>> needed to aggregate the point-wise representation in the
>> FAIR_GROUP_SCHED case.
>>
>
> Is the comments ok? :)
>
> /* runnable related variables only used in FAIR_GROUP_SCHED */

Perhaps:

 -/* These always depend on CONFIG_FAIR_GROUP_SCHED */
#ifdef ...
+/* Required to track per-cpu representation of a task_group */


>
> --
> Thanks
>     Alex
