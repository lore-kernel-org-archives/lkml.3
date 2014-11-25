Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKYO7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:59:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19867 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaKYO7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:59:00 -0500
Message-ID: <547498B6.1040108@oracle.com>
Date: Tue, 25 Nov 2014 07:56:54 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com,
        peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org,
        rientjes@google.com, ak@linux.intel.com, mgorman@suse.de,
        raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com,
        avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com,
        athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com,
        daeseok.youn@gmail.com, keescook@chromium.org,
        yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com,
        axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com> <20141125101238.GA19795@linux.vnet.ibm.com>
In-Reply-To: <20141125101238.GA19795@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 03:12 AM, Srikar Dronamraju wrote:
>>
>> - Request to borrow timeslice is not guranteed to be honored.
>> - If the task is allowed to borrow, kernel will inform the task
>>    of this. When this happens, task must yield the processor as soon
>>    as it completes its critical section.
>> - If the task fails to yield processor after being allowed to
>>    borrow, it is penalized by forcing it to skip its next time slot
>>    by the scheduler.
>> - Task is charged additional time for the borrowed timeslice as
>>    accumulated run time. This pushes it further down in consideration
>>    for the next task to run.
>>
>
> Is there a way for us to identify if the lock is contended?
> Because it may not be prudent to allow a task to borrow timeslice for a
> lock which isnt contended.
>

Userspace knows that. It is hard to determine this from kernel. Darren 
Hart had worked on a solution to solving similar issue and I spent fair 
amount of time looking through that code. Darren's solution comes into 
play after contention has already happened and does reduce the cost of 
contention. Database folks think the cost is already too high once 
contention has happened because of the resulting context switches and 
post-contention solutions do not help. This solution helps reduce 
contention on locks and userspace code designer is in best position to 
determine which locks are subject to such contention.

--
Khalid
