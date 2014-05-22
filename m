Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaEVHK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:10:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:19937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbaEVHKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:10:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,885,1392192000"; 
   d="scan'208";a="515861842"
Message-ID: <537DA2CC.10306@intel.com>
Date: Thu, 22 May 2014 10:10:04 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
References: <20140521150613.GA28702@redhat.com> <20140521151655.GG2485@laptop.programming.kicks-ass.net> <20140521153013.GG5226@laptop.programming.kicks-ass.net> <20140521153219.GH5226@laptop.programming.kicks-ass.net> <537D9EBE.7030806@intel.com> <20140522070414.GN30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140522070414.GN30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 10:04 AM, Peter Zijlstra wrote:
> On Thu, May 22, 2014 at 09:52:46AM +0300, Adrian Hunter wrote:
>>> diff --git a/fs/exec.c b/fs/exec.c
>>> index 476f3ebf437e..8d51d7ce3dcf 100644
>>> --- a/fs/exec.c
>>> +++ b/fs/exec.c
>>> @@ -1111,6 +1111,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>>>  		set_dumpable(current->mm, suid_dumpable);
>>>  
>>>  	set_task_comm(current, kbasename(bprm->filename));
>>> +	perf_event_exec();
>>
>> Shouldn't that be the other way around i.e.
>>
>> +	perf_event_exec();
>> 	set_task_comm(current, kbasename(bprm->filename));
> 
> I suppose so indeed.
> 
>> Also what about flagging the comm event that corresponds to an exec e.g.
> 
> I think it was a mistake to conflate the two concepts, and separating
> them into different functions makes things clearer.

My patch was not related to that.  It was to get effectively an "exec"
event, by piggybacking the comm event.

