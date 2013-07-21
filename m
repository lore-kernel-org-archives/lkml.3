Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3GURfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 13:35:07 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36487 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3GURfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 13:35:05 -0400
Message-ID: <51EC1B38.8000708@linux.vnet.ibm.com>
Date: Sun, 21 Jul 2013 23:02:40 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
References: <1374220211.5447.9.camel@j-VirtualBox> <51E921EC.5040501@linux.vnet.ibm.com> <1374262090.1830.16.camel@j-VirtualBox>
In-Reply-To: <1374262090.1830.16.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072117-8256-0000-0000-0000086FBFE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Json,

With V2 of your patch here are the results for the ebizzy run on
3.11-rc1 + patch on  a 1 socket, 16 core powerpc machine. Each ebizzy
run was for 30 seconds.

Number_of_threads         %improvement_with_patch
    4                        8.63
    8                        1.29
    12                       9.98
    16                      20.46

Let me know if you want me to profile any of these runs for specific
statistics.

Regards
Preeti U Murthy


On 07/20/2013 12:58 AM, Jason Low wrote:
> On Fri, 2013-07-19 at 16:54 +0530, Preeti U Murthy wrote:
>> Hi Json,
>>
>> I ran ebizzy and kernbench benchmarks on your 3.11-rc1 + your        "V1
>> patch" on a 1 socket, 16 core powerpc machine. I thought I would let you
>> know the results before I try your V2.
>>
>> Ebizzy: 30 seconds run. The table below shows the improvement in the
>> number of records completed. I have not spent enough time on the patch
>> to explain such a big improvement.
>>
>> Number_of_threads   %improvement_with_patch
>>     4                          41.86%
>>     8                          9.8%
>>    12                          34.77%
>>    16                          28.37%
>>
>> While on kernbench there was no significant change in the observation.
>>
>> I will try patch V2 and let you know the results.
> 
> Great to see those improvements so far. Thank you for testing this.
> 
> Jason
> 

