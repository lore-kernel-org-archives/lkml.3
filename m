Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3CUK2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:28:39 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59758 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3CUK2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:28:38 -0400
Message-ID: <514AE07A.10100@linux.vnet.ibm.com>
Date: Thu, 21 Mar 2013 15:57:06 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com>
In-Reply-To: <514AD26F.9010905@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032110-5564-0000-0000-0000072A0BF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 02:57 PM, Alex Shi wrote:
> On 03/21/2013 04:41 PM, Preeti U Murthy wrote:
>>>>
>> Yes, I did find this behaviour on a 2 socket, 8 core machine very
>> consistently.
>>
>> rq->util cannot go to 0, after it has begun accumulating load right?
>>
>> Say a load was running on a runqueue which had its rq->util to be at
>> 100%. After the load finishes, the runqueue goes idle. For every
>> scheduler tick, its utilisation decays. But can never become 0.
>>
>> rq->util = rq->avg.runnable_avg_sum/rq->avg.runnable_avg_period
> 
> 
> did you close all of background system services?
> In theory the rq->avg.runnable_avg_sum should be zero if there is no
> task a bit long, otherwise there are some bugs in kernel.

Could you explain why rq->avg.runnable_avg_sum should be zero? What if
some kernel thread ran on this run queue and is now finished? Its
utilisation would be say x.How would that ever drop to 0,even if nothing
ran on it later?

Regards
Preeti U Murthy

 Could you
> check the value under /proc/sched_debug?
> 
> 

