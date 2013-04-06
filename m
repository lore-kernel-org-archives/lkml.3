Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163299Ab3DFLtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 07:49:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:25940 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163272Ab3DFLti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 07:49:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,420,1363158000"; 
   d="scan'208";a="223605402"
Message-ID: <51600BBE.7060506@intel.com>
Date: Sat, 06 Apr 2013 19:49:18 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch v7 15/21] sched: pull all tasks from source group
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <1365040862-8390-16-git-send-email-alex.shi@intel.com> <87a9peesz7.fsf@sejong.aot.lge.com>
In-Reply-To: <87a9peesz7.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 01:59 PM, Namhyung Kim wrote:
>> > -		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
>> > +		if (rq->nr_running == 0 ||
>> > +			(!(env->flags & LBF_POWER_BAL) && capacity &&
>> > +				rq->nr_running == 1 && wl > env->imbalance))
> Just out of curious.
> 
> In load_balance(), we only move normal tasks, right?
> 
> Then shouldn't it check rq->cfs.h_nr_running rather than rq->nr_running?

Yes, it seems so.
What's your opinion of this, Peter?

-- 
Thanks
    Alex
