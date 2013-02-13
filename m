Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120Ab3BMPIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:08:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:60481 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934032Ab3BMPH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:07:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="256421516"
Message-ID: <511BAC40.6080009@intel.com>
Date: Wed, 13 Feb 2013 23:07:44 +0800
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
Subject: Re: [patch v4 03/18] sched: fix find_idlest_group mess logical
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-4-git-send-email-alex.shi@intel.com> <1360664208.4485.8.camel@laptop>
In-Reply-To: <1360664208.4485.8.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:16 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> There is 4 situations in the function:
>> 1, no task allowed group;
>> 	so min_load = ULONG_MAX, this_load = 0, idlest = NULL
>> 2, only local group task allowed;
>> 	so min_load = ULONG_MAX, this_load assigned, idlest = NULL
>> 3, only non-local task group allowed;
>> 	so min_load assigned, this_load = 0, idlest != NULL
>> 4, local group + another group are task allowed.
>> 	so min_load assigned, this_load assigned, idlest != NULL
>>
>> Current logical will return NULL in first 3 kinds of scenarios.
>> And still return NULL, if idlest group is heavier then the
>> local group in the 4th situation.
>>
>> Actually, I thought groups in situation 2,3 are also eligible to host
>> the task. And in 4th situation, agree to bias toward local group.
> 
> I'm not convinced this is actually a cleanup.. taken together with patch
> 4 (which is a direct consequence of this patch afaict) you replace one
> conditional with 2.
> 

The current logical will always miss the eligible CPU in the 3rd
situation.  'sd = sd->child' still skip the non-local group eligible CPU.


-- 
Thanks
    Alex
