Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaDWFpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:45:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:61381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbaDWFpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="525347113"
Message-ID: <53575360.3010702@linux.intel.com>
Date: Wed, 23 Apr 2014 13:45:04 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com> <20140422081515.GF11182@twins.programming.kicks-ass.net> <53572939.7020509@linux.intel.com> <20140423053213.GV26782@laptop.programming.kicks-ass.net>
In-Reply-To: <20140423053213.GV26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/23 13:32, Peter Zijlstra wrote:
> On Wed, Apr 23, 2014 at 10:45:13AM +0800, Jiang Liu wrote:
>> Hi Peter,
>> 	It's not for memoryless node, but to solve a race window
>> in CPU hot-addition. The related CPU hot-addition flow is:
>> 1) Handle CPU hot-addition event
>> 1.a) gather platform specific information
>> 1.b) associate hot-added CPU with a node
>> 1.c) create CPU device
>> 2) User online hot-added CPUs through sysfs:
>> 2.a)	cpu_up()
>> 2.b)		->try_online_node()
>> 2.c)			->hotadd_new_pgdat()
>> 2.d)			->node_set_online()
>>
>> So between 1.b and 2.c, kmalloc_node(nid) may cause invalid
>> memory access without the node_online(nid) check.
> 
> Any why was all this not in the Changelog?
Sorry, will add above message into changelog.
Thanks!
Gerry
