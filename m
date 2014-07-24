Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaGXCCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 22:02:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:53749 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbaGXCCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 22:02:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,721,1400050800"; 
   d="scan'208";a="566351638"
Message-ID: <53D068BD.6090701@intel.com>
Date: Thu, 24 Jul 2014 10:00:29 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rjw@rjwysocki.net, len.brown@intel.com, peterz@infradead.org,
        toshi.kani@hp.com, mingo@kernel.org, akpm@linux-foundation.org,
        todd.e.brandt@linux.intel.com, fabf@skynet.be,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH] PM/CPU: Parallel enabling nonboot cpus with resume
 devices
References: <1406106694-3306-1-git-send-email-tianyu.lan@intel.com> <20140723105304.GA22675@amd.pavel.ucw.cz>
In-Reply-To: <20140723105304.GA22675@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月23日 18:53, Pavel Machek wrote:
> Hi!
> 
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
> Does this mean that userspace can now run seeing the "offlined" cpus
> still in offline state?

No, the PM event handler of cpu hotplug will reenable cpu hotplug via
cpu_hotplug_enable() at the end of system resume. The function will wait
for currently running cpu hotplug operations to complete.

> 
> 									Pavel
> 


-- 
Best regards
Tianyu Lan
