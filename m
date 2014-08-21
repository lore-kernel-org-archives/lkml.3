Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaHUBkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:40:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37054 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbaHUBkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:40:41 -0400
X-IronPort-AV: E=Sophos;i="5.04,370,1406563200"; 
   d="scan'208";a="34871589"
Message-ID: <53F54D40.5090707@cn.fujitsu.com>
Date: Thu, 21 Aug 2014 09:37:04 +0800
From: Chai Wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>
CC: <akpm@linux-foundation.org>, <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] softlockup: make detector be aware of task switch
 of processes hogging cpu
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com> <1407768567-171794-3-git-send-email-dzickus@redhat.com> <20140818090319.GA25495@gmail.com> <20140818150658.GQ49576@redhat.com> <20140818180158.GA4540@gmail.com> <20140818184339.GB49576@redhat.com> <20140818190200.GB5074@gmail.com> <20140818203801.GE49576@redhat.com> <53F2AA05.1020509@cn.fujitsu.com>
In-Reply-To: <53F2AA05.1020509@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 09:36 AM, Chai Wen wrote:

> On 08/19/2014 04:38 AM, Don Zickus wrote:
> 
>> On Mon, Aug 18, 2014 at 09:02:00PM +0200, Ingo Molnar wrote:
>>>
>>> * Don Zickus <dzickus@redhat.com> wrote:
>>>
>>>>>>> So I agree with the motivation of this improvement, but 
>>>>>>> is this implementation namespace-safe?
>>>>>>
>>>>>> What namespace are you worried about colliding with?  I 
>>>>>> thought softlockup_ would provide the safety??  Maybe I 
>>>>>> am missing something obvious. :-(
>>>>>
>>>>> I meant PID namespaces - a PID in itself isn't guaranteed 
>>>>> to be unique across the system.
>>>>
>>>> Ah, I don't think we thought about that.  Is there a better 
>>>> way to do this?  Is there a domain id or something that can 
>>>> be OR'd with the pid?
>>>
>>> What is always unique is the task pointer itself. We use pids 
>>> when we interface with user-space - but we don't really do that 
>>> here, right?
>>
>> No, I don't believe so.  Ok, so saving 'current' and comparing that should
>> be enough, correct?
>>
> 
> 
> I am not sure of the safety about using pid here with namespace.
> But as to the pointer of process, is there a chance that we got a 'historical'
> address saved in the 'softlockup_warn_pid(or address)_saved' and the current
> hogging process happened to get the same task pointer address?
> If it never happens, I think the comparing of address is ok.
> 


Hi Ingo

what do you think of Don's solution- 'comparing of task pointer' ?
Anyway this is just an additional check about some very special cases,
so I think the issue that I am concerned above is not a problem at all.
And after learning some concepts about PID namespace, I think comparing
of task pointer is reliable dealing with PID namespace here.

And Don, If you want me to re-post this patch, please let me know that.

thanks
chai wen

> thanks
> chai wen
> 
>> Cheers,
>> Don
>> .
>>
> 
> 
> 



-- 
Regards

Chai Wen
