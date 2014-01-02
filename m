Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaABXUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:20:16 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:44727 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaABXUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:20:14 -0500
Message-ID: <52C5F42A.6010803@felipetonello.com>
Date: Thu, 02 Jan 2014 15:20:10 -0800
From: Felipe Ferreri Tonello <eu@felipetonello.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] input: mt: Add helper function to send end events
References: <1388455601-17033-1-git-send-email-eu@felipetonello.com> <52C28DC7.9020003@euromail.se> <20131231185035.GD6897@core.coreip.homeip.net> <52C43FFE.3010005@euromail.se> <20140101191838.GA30798@core.coreip.homeip.net>
In-Reply-To: <20140101191838.GA30798@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry and Henrik,

On 01/01/2014 11:18 AM, Dmitry Torokhov wrote:
> On Wed, Jan 01, 2014 at 05:19:10PM +0100, Henrik Rydberg wrote:
>> Hi Dmitry,
>>
>>>> What problematic scenario is this supposed to solve?
>>>>
>>>> The 'release on suspend' is only an approximation to the 'close
>>>> laptop' scenario, it is certainly not correct in the coffee table
>>>> case,
>>>
>>> Why would it not be correct for coffee table? Do we expect the touches
>>> to remain valid while the device is asleep?
>>
>> In some scenarios with placed objects (like a cup or a marker), that would be
>> the case, yes.
>>
>>>> for instance. Instead of
>>>> hardcoding this in the kernel, userland can easily detect long intervals
>>>> directly using the event time.
>>>
>>> But with slots it is not only problem with old events being sent out
>>> later, it is that we have mix of old (pre-sleep) and new state.
>>
>> The new state is not really a problem, it will look exactly the same regardless
>> of how 'old' releases are handled.
>>
>>> We do that for keys (release them when we transition to system sleep)
>>> and I think it might be worthwhile to do the same for touch data.
>>
>> I agree that keyboard applications seldom look at time intervals and hence are
>> well helped by such a strategy, even though it is not strictly 'correct'.
>> However, touch interfaces are quite dependent on time intervals, and it
>> therefore makes a lot of sense to resolve touch timeouts directly in the
>> application. It also puts less restrictions on what can be done.
>>
>> Regarding notifications in general, perhaps it would be interesting to be able
>> to send a notification event via the input interface when a device comes back
>> from sleep. It could help resolve other complex issues, if there were any.
>>
>
> OK, fair enough. If there is a demand we could send SYN_SYSTEM_RESUME
> event though the interfaces to allow clients "flush" the state or
> otherwise decide if new touch data is actually old touches that were
> there pre-suspend.
>
> Felipe, will that help in your case?

Yes, I guess. But why notificate only when it comes back from sleep?

Because the way it is today, if a user touches a device and suddenly the 
device sleeps, the user-space will not know that that device went sleep. 
Then when the device wakes up (resumes) the end touch event will never 
be sent even if the user releases his finger from it (because the actual 
hardware is in "sleep" mode or something), thus the user-space will 
continue to think the finger was not released from the touch screen.

Felipe
