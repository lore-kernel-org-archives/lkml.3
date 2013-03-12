Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3CLJl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:41:59 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41441 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab3CLJl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:41:57 -0400
Message-ID: <513EF856.7060200@linux.vnet.ibm.com>
Date: Tue, 12 Mar 2013 17:41:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362645372.2606.11.camel@laptop> <20130311082105.GB12742@gmail.com> <513DA076.80009@linux.vnet.ibm.com> <20130311094031.GA14221@gmail.com> <513EC47E.9040602@linux.vnet.ibm.com> <20130312084857.GA4859@gmail.com>
In-Reply-To: <20130312084857.GA4859@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031209-5564-0000-0000-000006FC85F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 04:48 PM, Ingo Molnar wrote:
[snip]
>>>
>>> Instrumentation/stats/profiling will also double check the correctness of 
>>> this data: if developers/users start relying on the work metric as a 
>>> substitute benchmark number, then app writers will have an additional 
>>> incentive to make them correct.
>>
>> I see, I could not figure out how to wisely using the info currently, 
>> but I have the feeling that it will make scheduler very different ;-)
>>
>> May be we could implement the API and get those info ready firstly 
>> (along with the new sched-pipe which provide work tick info), then think 
>> about the way to use them in scheduler, is there any patches on the way?
> 
> Absolutely.
> 
> Beyond the new prctl no new API is needed: a perf soft event could be 
> added, and/or a tracepoint. Then perf stat and perf record could be used 
> with it. 'perf bench' could be extended to generate the work tick in its 
> 'perf bench sched ...' workloads - and for 'perf bench mem numa' as well.

Nice :)

> 
> vsyscall-accelerating it could be a separate, more complex step: it needs 
> a per thread writable vsyscall data area to make the overhead to 
> applications near zero. Performance critical apps won't call an extra 
> syscall.

If it's really bring benefit, I think they will consider about it,
whatever, that's the developer/users decision, what we need to do is
just make the stuff attractively.

Regards,
Michael Wang

> 
> Thanks,
> 
> 	Ingo
> 

