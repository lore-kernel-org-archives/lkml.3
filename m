Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3FQPVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:21:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:8702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3FQPVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="330934321"
Message-ID: <51BF297B.7090409@intel.com>
Date: Mon, 17 Jun 2013 23:21:31 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com> <CAPM31RKwNUh+nNcsEftD4pyP+gdwXhRK7wCRNWa8Y0sE0hf-DQ@mail.gmail.com> <51BF23E9.5090906@intel.com>
In-Reply-To: <51BF23E9.5090906@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 10:57 PM, Alex Shi wrote:
>> > 
>> > Did you try including blocked_load_avg in only get_rq_runnable_load()
>> > [ and not weighted_cpuload() which is called by new-idle ]?
>> > 
> No, but blocked_load_avg also impact periodic balance much. The ideal
> scenario is a sleeping task will be waken up on same cpu. But like
> kbuild benchmark, the quick cc/ld task are forked, and then finished and

a bit more explain, cc/ld finished cpu task then wait IO to write object
files into disk.
> disappeared quickly. blocked_load_avg cause trouble in kbuild.


-- 
Thanks
    Alex
