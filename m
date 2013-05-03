Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870Ab3ECIz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:55:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:39475 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762761Ab3ECIzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:55:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,602,1363158000"; 
   d="scan'208";a="307393941"
Message-ID: <51837B43.1020804@intel.com>
Date: Fri, 03 May 2013 16:54:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 0/6] sched: use runnable load based balance
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com> <20130501121421.GA19602@dyad.programming.kicks-ass.net> <5181B579.9000808@intel.com> <20130502103508.GA13196@dyad.programming.kicks-ass.net> <51836D74.2030409@intel.com>
In-Reply-To: <51836D74.2030409@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 03:55 PM, Alex Shi wrote:
> Just find a benchmark named as pthread_cond_broadcast. 
> http://kristiannielsen.livejournal.com/13577.html. will play with it. :)
>> > 

I tried the pthread_cond_broadcast with/without my latest patchset,
seems no clear performance change.
 without the patch, finished 30000 threads need 0.39 ~ 0.49 seconds in
ten times testing,
 with the patch, finished 30000 thread need 0.38 ~ 0.47 seconds in ten
times testing.

I try to give more threads in testing, but when thread number increased
to 40000, the testing become extremely slow and gdb find it busy on
thread creating.


[New Thread 0x7fe470411700 (LWP 24629)]
[New Thread 0x7fe470512700 (LWP 24628)]
[New Thread 0x7fe470613700 (LWP 24627)]
[New Thread 0x7fe470714700 (LWP 24626)]



-- 
Thanks
    Alex
