Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937743Ab3DIKir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:38:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:41188 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935228Ab3DIKip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:38:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="283598867"
Message-ID: <5163EF9E.4030005@intel.com>
Date: Tue, 09 Apr 2013 18:38:22 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, rafael.j.wysocki@intel.com,
        jkosina@suse.cz, clark.williams@gmail.com,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 6/8] sched: consider runnable load average in move_tasks
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <1364873008-3169-7-git-send-email-alex.shi@intel.com> <CAKfTPtBoV3KoSHuTnZVrvPdCM+5ckFGXfM11oCB1Le_Zmy1hYQ@mail.gmail.com> <5163CBE6.4070209@intel.com> <CAKfTPtDbiv2ACgem7k7YxcxgwGA4-JY1LcAg0B_XOVaOeE8aeQ@mail.gmail.com>
In-Reply-To: <CAKfTPtDbiv2ACgem7k7YxcxgwGA4-JY1LcAg0B_XOVaOeE8aeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 04:58 PM, Vincent Guittot wrote:
>>> >> How do you ensure that runnable_avg_period and runnable_avg_sum are
>>> >> coherent ? an update of the statistic can occur in the middle of your
>>> >> sequence.
>> >
>> > Thanks for your question, Vincent!
>> > the runnable_avg_period and runnable_avg_sum, only updated in
>> > __update_entity_runnable_avg().
>> > Yes, I didn't see some locks to ensure the coherent of them. but they
>> > are updated closely, and it is not big deal even a little incorrect to
>> > their value. These data are collected periodically, don't need very very
>> > precise at every time.
>> > Am I right? :)
> The problem mainly appears during starting phase (the 1st 345ms) when
> runnable_avg_period has not reached the max value yet so you can have
> avg.runnable_avg_sum greater than avg.runnable_avg_period. In a worst
> case, runnable_avg_sum could be twice runnable_avg_period

Oh, That's a serious problem. Do you catch it in real word or in code?
Could you explain more for details?

-- 
Thanks
    Alex
