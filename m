Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaJVGLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:11:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:63041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaJVGLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:11:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,766,1406617200"; 
   d="scan'208";a="593550077"
Message-ID: <5447495A.1060102@intel.com>
Date: Wed, 22 Oct 2014 14:06:18 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, rafael.j.wysocki@intel.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, fabf@skynet.be,
        laijs@cn.fujitsu.com, srivatsa.bhat@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, srivatsa@mit.edu, viresh.kumar@linaro.org,
        todd.e.brandt@linux.intel.com, tipbot@zytor.com,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH V3 0/3] PM/CPU: Parallel enalbing nonboot cpus with
 resume devices
References: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com> <20141008205441.GJ4750@worktop.programming.kicks-ass.net> <5435E275.3030307@intel.com>
In-Reply-To: <5435E275.3030307@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年10月09日 09:18, Lan Tianyu wrote:
> On 2014年10月09日 04:54, Peter Zijlstra wrote:
>> On Thu, Sep 25, 2014 at 04:32:02PM +0800, Lan Tianyu wrote:
>>> This patchset is to parallel enabling nonboot cpus with resuming devices
>>> during system resume in order to accelerate S2RAM. From test result on
>>> a 8 logical core Haswell machine, system resume time reduces from 347ms
>>> to 217ms with this patchset.
>>>
>>> In the current world, all nonboot cpus are enabled serially during system
>>> resume. System resume sequence is that boot cpu enables nonboot cpu one by
>>> one and then resume devices. Before resuming devices, there are few tasks
>>> assigned to nonboot cpus after they are brought up. This wastes cpu usage.
>>>
>>> This patchset is to allow boot cpu to go forward to resume devices after
>>> bringing up one nonboot cpu and starting a thread. The thread will be in
>>> charge of bringing up other frozen cpus. The thread will be scheduled to
>>> the first online cpu to run . This makes enabling cpu2~x parallel with
>>> resuming devices.
>>
>> So I feel we should really clean up hotplug before doing anything like
>> this. Its a trainwreck and just piling more and more hacks ontop isn't
>> going to help any.
>>
> 
> Hi Peter:
> 	Sorry, I don't know the gap of hotplug clearly. Could you elaborate it?
> 

Hi Peter:
	Could you elaborate the gap of hotplug? Thanks.

-- 
Best regards
Tianyu Lan
