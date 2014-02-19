Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaBSKYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:24:13 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60750 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaBSKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:24:10 -0500
Message-ID: <53048626.2000803@linaro.org>
Date: Wed, 19 Feb 2014 18:23:34 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/11] remove cpu_load in rq
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org> <20140218120522.GG19029@e103034-lin> <CAKfTPtDtv=hFtprNpAfRVMEAvWZn-55u8fcHTdJT6xT92Qdt-g@mail.gmail.com>
In-Reply-To: <CAKfTPtDtv=hFtprNpAfRVMEAvWZn-55u8fcHTdJT6xT92Qdt-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Removing cpu_load completely certainly makes things simpler, my worry is
>> just how much was lost by doing it. I agree that cpu_load needs a
>> cleanup, but I can't convince myself that just removing it completely
>> and not having any longer term view of cpu load anymore is without any
>> negative side-effects.
> 
> Hi Alex,
> 
> Have you followed this thread about load_idx and the interest of using
> them to use different average period ?
> https://lkml.org/lkml/2014/1/6/499

Yes, I hoped to use blocked load before. But I still can not figure out
the correct usage of it.
Or maybe we need more quick decay for blocked load?
Or, maybe clean cpu_load is helpful to make room to reconsider this.
> 
> Vincent
> 
>>
>> {source, target}_load() are now instantaneous views of the cpu load,
>> which means that they may change very frequently. That could potentially
>> lead to more task migrations at all levels in the domain hierarchy as we
>> no longer have the more conservative cpu_load[] indexes that were used
>> at NUMA level.
>>
>> Maybe some of the NUMA experts have an opinion about this?
>>
>> In the discussions around V1 I think blocked load came up again as a
>> potential replacement for the current cpu_load array. There are some
>> issues that need to be solved around blocked_load first though.
>>
>> Morten


-- 
Thanks
    Alex
