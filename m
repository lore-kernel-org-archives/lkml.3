Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3BVKIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:08:40 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55200 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3BVKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:08:38 -0500
Message-ID: <5127438E.1060404@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 18:08:14 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361442055.26780.3.camel@laptop> <5126D9E0.7040108@linux.vnet.ibm.com> <1361522197.26780.39.camel@laptop> <51273636.6080907@linux.vnet.ibm.com> <1361527056.26780.55.camel@laptop>
In-Reply-To: <1361527056.26780.55.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022210-3864-0000-0000-000006F10D53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 05:57 PM, Peter Zijlstra wrote:
> On Fri, 2013-02-22 at 17:11 +0800, Michael Wang wrote:
> 
>> Ok, it do looks like wake_affine() lost it's value...
> 
> I'm not sure we can say that on this one benchmark, there's a
> preemption advantage to running on a single cpu for pipe-test as well.
> We'd need to create a better benchmark to test this, one that has some
> actual data payload and control over the initial spread of the tasks or
> so.
> 
>>> Now as far as I can see there's two options, either we find there's
>>> absolutely no benefit in wake_affine() as it stands today and we simply
>>> disable/remove it, or we go fix it. What we don't do is completely
>>> wreck it at atrocious cost.
>>
>> I get your point, we should replace wake_affine() with some feature
>> which could really achieve the goal to make client and server on same cpu.
>>
>> But is the logical that the waker/wakee are server/client(or reversed)
>> still works now? that sounds a little arbitrary to me...
> 
> Ah, its never really been about server/client per-se. Its just a
> specific example -- one that breaks down with the 1:n pgbench
> situation.
> 
> Wakeups in general can be considered to be a relation, suppose a
> hardware interrupt that received some data from a device and issues a
> wakeup to a task to consume this data. What CPU would be better suited
> to process this data then the one where its already cache hot.

I see, honestly, I realized that I have underestimated the benefit we
gain from it when saw your testing results...

We do need some better approach to replace wake_affine(), hmm...I need a
draft board now...

Regards,
Michael Wang

> 

