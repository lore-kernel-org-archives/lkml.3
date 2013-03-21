Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab3CUJ1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:27:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:26285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab3CUJ1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:27:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="274002934"
Message-ID: <514AD26F.9010905@intel.com>
Date: Thu, 21 Mar 2013 17:27:11 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com>
In-Reply-To: <514AC7B2.7030400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 04:41 PM, Preeti U Murthy wrote:
>> > 
> Yes, I did find this behaviour on a 2 socket, 8 core machine very
> consistently.
> 
> rq->util cannot go to 0, after it has begun accumulating load right?
> 
> Say a load was running on a runqueue which had its rq->util to be at
> 100%. After the load finishes, the runqueue goes idle. For every
> scheduler tick, its utilisation decays. But can never become 0.
> 
> rq->util = rq->avg.runnable_avg_sum/rq->avg.runnable_avg_period


did you close all of background system services?
In theory the rq->avg.runnable_avg_sum should be zero if there is no
task a bit long, otherwise there are some bugs in kernel. Could you
check the value under /proc/sched_debug?


-- 
Thanks
    Alex
