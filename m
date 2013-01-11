Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3AKCfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:35:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:35537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab3AKCfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:35:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,447,1355126400"; 
   d="scan'208";a="242551018"
Message-ID: <50EF7A9F.8070700@intel.com>
Date: Fri, 11 Jan 2013 10:36:15 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org> <50ED1D54.70208@intel.com> <876236rdum.fsf@sejong.aot.lge.com> <50ED2B9F.3080800@intel.com> <87k3rlpou5.fsf@sejong.aot.lge.com>
In-Reply-To: <87k3rlpou5.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 01:52 PM, Namhyung Kim wrote:
> On Wed, 09 Jan 2013 16:34:39 +0800, Alex Shi wrote:
>> On 01/09/2013 03:54 PM, Namhyung Kim wrote:
>>> Hi Alex,
>>>
>>> On Wed, 09 Jan 2013 15:33:40 +0800, Alex Shi wrote:
>>>> On 01/09/2013 02:50 PM, Namhyung Kim wrote:
>>>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>>>
>>>>> AFAICS @target cpu of select_idle_sibling() is always either prev_cpu
>>>>> or this_cpu.  So no need to check it again and the conditionals can be
>>>>> consolidated.
>>> [snip]
>>>> Uh, we don't know if the target is this_cpu or previous cpu, If we just
>>>> check the target idle status, we may miss another idle cpu. So this
>>>> patch change the logical in this function.
>>>
>>> select_idle_sibling() is called only in select_task_rq_fair() if it
>>> found a suitable affine_sd.  The default target is the 'prev_cpu' of the
>>> task but if wake_affine() returns true it'd be (this) 'cpu'.
>>>
>>> I cannot see where the prev_cpu or the cpu is set to another one before
>>> calling select_idle_sibling.
>>
>> The old logical will return directly whenever prev_cpu or this cpu idle,
>> but your new logical just has one chance.
> 
> Sorry, I can't get your point.  Could you elaborate on it a bit more?

Sorry. I misunderstand this.

Acked-by: Alex Shi

> 
> Thanks,
> Namhyung
> 


-- 
Thanks Alex
