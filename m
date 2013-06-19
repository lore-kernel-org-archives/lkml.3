Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab3FSJuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:50:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:1233 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab3FSJuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:50:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="352248025"
Message-ID: <51C17EA4.3030401@intel.com>
Date: Wed, 19 Jun 2013 17:49:24 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [patch v8 9/9] sched/tg: remove blocked_load_avg in balance
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-10-git-send-email-alex.shi@intel.com> <CAPM31RJ_0xgymfN+5FzQCSrv-qgpT+42EOmWke1rOGy7GfHcYg@mail.gmail.com> <20130617140100.GZ3204@twins.programming.kicks-ass.net>
In-Reply-To: <20130617140100.GZ3204@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 10:01 PM, Peter Zijlstra wrote:
> On Mon, Jun 17, 2013 at 05:20:46AM -0700, Paul Turner wrote:
>> > On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
>>> > > blocked_load_avg sometime is too heavy and far bigger than runnable load
>>> > > avg, that make balance make wrong decision. So remove it.
>> > 
>> > Ok so this is  going to have terrible effects on the correctness of
>> > shares distribution; I'm fairly opposed to it in its present form.
> Should someone take a look at the LTP cgroup tests to make sure they
> cover this properly?

Seems I have no time on this in near future. :(

But I were you, I would picked up this patch, since
1, it is simple and easy revert.
2, it wins in testing.
3, it will motivate Paul to look into this problem. ;)

-- 
Thanks
    Alex
