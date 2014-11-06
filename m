Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaKFCH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:07:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:45359 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaKFCH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:07:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484928043"
Date: Thu, 6 Nov 2014 09:46:34 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wanpeng Li <kernellwp@gmail.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] sched/deadline: support dl task migration during
 cpu hotplug
Message-ID: <20141106014634.GA25640@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com>
 <20141105105058.GQ3337@twins.programming.kicks-ass.net>
 <545A0317.4090406@gmail.com>
 <20141105125254.GT3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141105125254.GT3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
On Wed, Nov 05, 2014 at 01:52:54PM +0100, Peter Zijlstra wrote:
>On Wed, Nov 05, 2014 at 06:59:35PM +0800, Wanpeng Li wrote:
>> Hi Peter,
>> On 14/11/5 下午6:50, Peter Zijlstra wrote:
>> >On Wed, Nov 05, 2014 at 04:51:57PM +0800, Wanpeng Li wrote:
>> >>Note: dl task can be migrated successfully if rq is offline currently, however,
>> >>I'm still not sure why task_rq(task)->rd->span just include the cpu which the dl
>> >>task previous running on, so cpu_active_mask is used in the patch.
>> >>
>> >>Peterz, Juri?
>> >So the root domain span is for exclusive cpusets
>> >(Documentation/cgroups/cpusets.txt) where we fully separate sets of CPUs
>> >and have no load-balancing between the sets.
>> >
>> >For 'normal' setups the rd->span is the entire machine, but using
>> >cpusets you can create more (smaller) domains.
>> 
>> I don't setup any cpusets related stuff, however, task_rq(task)->rd->span
>> just include the cpu which the dl task previous running on instead of the
>> entire machine in find_later_rq().
>
>Ah, it could be that for offline cpus we have a singleton rd. Lemme try

I still cannot find where build the singleton rd in the codes, could you
point out?

Regards,
Wanpeng Li

>and remember wth we did there.

