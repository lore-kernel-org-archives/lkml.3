Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab3BMOoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:44:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:22065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032Ab3BMOoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:44:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="290605921"
Message-ID: <511BA6BC.3060707@intel.com>
Date: Wed, 13 Feb 2013 22:44:12 +0800
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
Subject: Re: [patch v4 02/18] sched: select_task_rq_fair clean up
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-3-git-send-email-alex.shi@intel.com> <1360664089.4485.6.camel@laptop>
In-Reply-To: <1360664089.4485.6.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:14 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> It is impossible to miss a task allowed cpu in a eligible group.
> 
> I suppose your reasoning goes like: tsk->cpus_allowed is protected by
> ->pi_lock, we hold this, therefore it cannot change and
> find_idlest_group() dtrt?

yes.
> 
> We can then state that this is due to adding proper serialization to
> tsk->cpus_allowed.
> 
>> And since find_idlest_group only return a different group which
>> excludes old cpu, it's also impossible to find a new cpu same as old
>> cpu.
> 
> Sounds plausible, but I'm not convinced, do we have hard serialization
> against hotplug?

Any caller of select_task_rq will check if returned dst_cpu is still
working. So there is nothing need worry about.
> 
> 
> 


-- 
Thanks
    Alex
