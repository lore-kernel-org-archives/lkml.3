Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbbA0HMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:12:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:25113 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbbA0HMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:12:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,473,1418112000"; 
   d="scan'208";a="643047440"
Message-ID: <54C73A72.7030005@linux.intel.com>
Date: Tue, 27 Jan 2015 15:12:50 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
References: <54866625.8010406@linux.intel.com> <7916564.nnH80uMtkt@vostro.rjw.lan> <alpine.DEB.2.11.1501261513040.5526@nanos> <2433846.5N8KuFRAKW@vostro.rjw.lan>
In-Reply-To: <2433846.5N8KuFRAKW@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/26 22:45, Rafael J. Wysocki wrote:
> On Monday, January 26, 2015 03:15:43 PM Thomas Gleixner wrote:
>> On Mon, 26 Jan 2015, Rafael J. Wysocki wrote:
>>
>>> On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
>>>> On Mon, 26 Jan 2015, Li, Aubrey wrote:
>>>>> On 2015/1/22 18:15, Thomas Gleixner wrote:
>>>>>> Can we please stop adding more crap to that notifier thing? I rather
>>>>>> see that go away than being expanded.
>>>>>
>>>>> Are you referring to FREEZE_PREPARE or remove all of FREEZE staff at all?
>>>>>
>>>>> What's the disadvantage of adding more notifier?
>>>>
>>>> clockevents_notify() is not a notifier. Its a multiplex call and I
>>>> want to get rid of it and replace it with explicit functions.
>>>
>>> OK, so perhaps we need to move _SUSPEND/_RESUME out of there to start with?
>>>
>>> As far as I can say, clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL) and
>>> clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL) are each only called from
>>> one place and moreover, since they are in syscore_ops, we don't need any
>>> locking around them.
>>>
>>> So what about the patch below?
>>
>> I'm cleaning up the whole replacement of notify. The stuff below is
>> part of it.
>>
>>>  
>>> -	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
>>> +	tick_suspend();
>>> +	tick_suspend_broadcast();
>>
>> That's exactly the stuff I don't want to see. Blind code
>> move.
> 
> At least it's clear what the patch does. :-)
> 
>> tick_suspend_broadcast() wants to be called from tick_suspend().
> 
> OK
> 
>> Still compiling and testing a gazillion of combinations.
> 
> OK, so it looks like we need to wait with the suspend to idle changes until
> this lands.

Please cc the patches to me when you post. I'll refine the patch after that.

Thanks,
-Aubrey
