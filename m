Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289Ab3DCCgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:36:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:1618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760863Ab3DCCgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:36:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="222152734"
Message-ID: <515B958B.8000809@intel.com>
Date: Wed, 03 Apr 2013 10:35:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch v6 10/21] sched: get rq potential maximum utilization
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-11-git-send-email-alex.shi@intel.com> <87a9phfgox.fsf@sejong.aot.lge.com> <515B90A5.7080403@intel.com> <CAPM31RKj0SJB6eCDSpH29OdfeNGDXqzoQQWhQP7t3gdxYx+wrQ@mail.gmail.com>
In-Reply-To: <CAPM31RKj0SJB6eCDSpH29OdfeNGDXqzoQQWhQP7t3gdxYx+wrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 10:22 AM, Paul Turner wrote:
> On Tue, Apr 2, 2013 at 7:15 PM, Alex Shi <alex.shi@intel.com> wrote:
>> On 04/02/2013 05:02 PM, Namhyung Kim wrote:
>>>>> +  cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
>>>>> +                  : (FULL_UTIL - rt_util);
>>>>> +  nr_running = rq->nr_running ? rq->nr_running : 1;
>>> This can be cleaned up with proper min/max().
>>>
>>>>> +
>>>>> +  return rt_util + cfs_util * nr_running;
>>> Should this nr_running consider tasks in cfs_rq only?
>>
>> use nr_running of cfs_rq seems better, but when use sched autogroup,
>> only cfs->nr_running just the active group number, not the total active
>> task number. :(
> 
> Why not just use cfs_rq->h_nr_running?  This is always the total
> *tasks* in he hierarchy parented that cfs_rq.  (This also has the nice property
> of not including group_entities.)

oh, yes, Thanks for the reminder! :)
> 
>>
>>   Also it seems
>>> there's no upper bound so that it can possibly exceed FULL_UTIL.
>>
>>
>> --
>> Thanks Alex


-- 
Thanks Alex
