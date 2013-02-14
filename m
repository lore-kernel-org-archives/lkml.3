Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3BNDNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:13:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:31176 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab3BNDNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:13:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,660,1355126400"; 
   d="scan'208";a="285501284"
Message-ID: <511C566C.9070307@intel.com>
Date: Thu, 14 Feb 2013 11:13:48 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 05/18] sched: quicker balancing on fork/exec/wake
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-6-git-send-email-alex.shi@intel.com> <1360664565.4485.13.camel@laptop>
In-Reply-To: <1360664565.4485.13.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:22 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> Guess the search cpu from bottom to up in domain tree come from
>> commit 3dbd5342074a1e sched: multilevel sbe sbf, the purpose is
>> balancing over tasks on all level domains.
>>
>> This balancing cost too much if there has many domain/groups in a
>> large system.
>>
>> If we remove this code, we will get quick fork/exec/wake with a
>> similar
>> balancing result amony whole system.
>>
>> This patch increases 10+% performance of hackbench on my 4 sockets
>> SNB machines and about 3% increasing on 2 sockets servers.
>>
>>
> Numbers be groovy.. still I'd like a little more on the behavioural
> change. Expand on what exactly is lost by this change so that if we
> later find a regression we have a better idea of what and how.
> 
> For instance, note how find_idlest_group() isn't symmetric wrt
> local_group. So by not doing the domain iteration we change things.
> 
> Now, it might well be that all this is somewhat overkill as it is, but
> should we then not replace all of it with a simple min search over all
> eligible cpus; that would be a real clean up.
>  

Um, will think this again..
> 


-- 
Thanks
    Alex
