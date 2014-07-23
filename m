Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbaGWJvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:51:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:12102 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022AbaGWJvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,716,1400050800"; 
   d="scan'208";a="577489916"
Message-ID: <53CF8504.6030806@intel.com>
Date: Wed, 23 Jul 2014 17:48:52 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, toshi.kani@hp.com,
        mingo@kernel.org, akpm@linux-foundation.org,
        todd.e.brandt@linux.intel.com, fabf@skynet.be,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] PM/CPU: Parallel enabling nonboot cpus with resume
 devices
References: <1406106694-3306-1-git-send-email-tianyu.lan@intel.com> <20140723092154.GH20603@laptop.programming.kicks-ass.net>
In-Reply-To: <20140723092154.GH20603@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月23日 17:21, Peter Zijlstra wrote:
> On Wed, Jul 23, 2014 at 05:11:34PM +0800, Lan Tianyu wrote:
>> In the current world, all nonboot cpus are enabled serially during system
>> resume. System resume sequence is that boot cpu enables nonboot cpu one by
>> one and then resume devices. Before resuming devices, there are few tasks
>> assigned to nonboot cpus after they are brought up. This waste cpu usage.
>>
>> To accelerate S3, this patches adds a new kernel configure
>> PM_PARALLEL_CPU_UP_FOR_SUSPEND to allow boot cpu to go forward to resume
>> devices after bringing up one nonboot cpu. The nonboot cpu will be in charge
>> of bringing up other cpus. This makes enabling cpu2~x parallel with resuming
>> devices. From the test result on 4 logical core laptop, the time of resume
>> device almost wasn't affected by enabling nonboot cpus lately while the start
>> point is almost 30ms earlier than before.
> 
> Why is this a CONFIG and why do we want to add more warts to the cpu
> hotplug instead of fixing it 'proper'?
> 

Hi Peter:
	Thank you for your review. Because I just tested this patch on x86
platform and didn't want to cause some regressions on the other
platforms. So I made it as a new CONFIG. In theory, this should not
cause some problems. If none objects, it can be the default behavior.

-- 
Best regards
Tianyu Lan
