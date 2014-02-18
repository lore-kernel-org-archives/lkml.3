Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaBRM2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:28:47 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63499 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaBRM2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:28:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140218120522.GG19029@e103034-lin>
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org> <20140218120522.GG19029@e103034-lin>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 18 Feb 2014 13:28:25 +0100
Message-ID: <CAKfTPtDtv=hFtprNpAfRVMEAvWZn-55u8fcHTdJT6xT92Qdt-g@mail.gmail.com>
Subject: Re: [PATCH v2 0/11] remove cpu_load in rq
To: Alex Shi <alex.shi@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 February 2014 13:05, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Mon, Feb 17, 2014 at 01:55:06AM +0000, Alex Shi wrote:
>> The cpu_load decays on time according past cpu load of rq. The sched_avg also decays tasks' load on time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load by decay calculation. This patch try to remove the cpu_load decay.
>>
>> There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change.
>>
>> V2,
>> 1, This version do some tuning on load bias of target load, to maximum match current code logical.
>> 2, Got further to remove the cpu_load in rq.
>> 3, Revert the patch 'Limit sd->*_idx range on sysctl' since no needs
>>
>> Any testing/comments are appreciated.
>
> Removing cpu_load completely certainly makes things simpler, my worry is
> just how much was lost by doing it. I agree that cpu_load needs a
> cleanup, but I can't convince myself that just removing it completely
> and not having any longer term view of cpu load anymore is without any
> negative side-effects.

Hi Alex,

Have you followed this thread about load_idx and the interest of using
them to use different average period ?
https://lkml.org/lkml/2014/1/6/499

Vincent

>
> {source, target}_load() are now instantaneous views of the cpu load,
> which means that they may change very frequently. That could potentially
> lead to more task migrations at all levels in the domain hierarchy as we
> no longer have the more conservative cpu_load[] indexes that were used
> at NUMA level.
>
> Maybe some of the NUMA experts have an opinion about this?
>
> In the discussions around V1 I think blocked load came up again as a
> potential replacement for the current cpu_load array. There are some
> issues that need to be solved around blocked_load first though.
>
> Morten
