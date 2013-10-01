Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3JADLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:11:50 -0400
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44483 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755330Ab3JADLs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:11:48 -0400
X-Greylist: delayed 4426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2013 23:11:48 EDT
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: applesmc oops in 3.10/3.11
From: Chris Murphy <bugzilla@colorremedies.com>
In-Reply-To: <524615B1.6000106@roeck-us.net>
Date: Mon, 30 Sep 2013 19:57:48 -0600
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Henrik Rydberg <rydberg@euromail.se>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com> <20130925195628.GA1532@roeck-us.net> <20130925214807.GA3234@polaris.bitmath.org> <20130925220838.GB4184@roeck-us.net> <20130926063453.GA526@polaris.bitmath.org> <CA+5PVA76tjoR+GNaQps_zQmqz=V_GAcQaZLqKcx1ihgUMQBrQw@mail.gmail.com> <20130927171256.GA6391@roeck-us.net> <71D92187-2092-4975-A707-17452C48EF5A@colorremedies.com> <20130927175926.GA6267@roeck-us.net> <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com> <524615B1.6000106@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.1510)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slmp-550-94.slc.westdc.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - colorremedies.com
X-Get-Message-Sender-Via: slmp-550-94.slc.westdc.net: authenticated_id: whatever@colorremedies.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 27, 2013, at 5:33 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> On 09/27/2013 11:03 AM, Chris Murphy wrote:
>> 
>> On Sep 27, 2013, at 11:59 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> 
>>> On Fri, Sep 27, 2013 at 11:41:42AM -0600, Chris Murphy wrote:
>>>> 
>>>> On Sep 27, 2013, at 11:12 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>> 
>>>>> On Fri, Sep 27, 2013 at 12:21:04PM -0400, Josh Boyer wrote:
>>>>>> On Thu, Sep 26, 2013 at 2:34 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>>>>>>>>> This suggests that initialization may be attempted more than once. The key cache
>>>>>>>>>> is allocated only once, but the number of keys is read for each attempt.
>>>>>>>>>> 
>>>>>>>>>> No idea if that can happen, but if the number of keys can increase after
>>>>>>>>>> the first initialization attempt you would have an explanation for the crash.
>>>>>>>>> 
>>>>>>>>> Good idea, and easy enough to test with the patch below.
>>>>>>>>> 
>>>>>>>> Should we apply this patch even though it may not solve the specific problem ?
>>>>>>> 
>>>>>>> Yes, why not - it certainly won't hurt. I am running it right now, so
>>>>>>> it is at least run-tested.
>>>>>>> 
>>>>>>>> Again, not sure if the key count can change, but the current code is at the very
>>>>>>>> least inconsistent, as it keeps reading the key count without updating or
>>>>>>>> verifying the cache size.
>>>>>>> 
>>>>>>> Yes - I agree that the error state is far-fetched, but it is hard to
>>>>>>> see any other logical explanation. There is of course always the
>>>>>>> possibility that the problem is somewhere else completely.
>>>>>>> 
>>>>>>> Proper patch attached.
>>>>>>> 
>>>>>>> Thanks,
>>>>>>> Henrik
>>>>>>> 
>>>>>>> ---
>>>>>>> 
>>>>>>> From dedefba9167913c46e1896ce0624e68ffe95d532 Mon Sep 17 00:00:00 2001
>>>>>>> From: Henrik Rydberg <rydberg@euromail.se>
>>>>>>> Date: Thu, 26 Sep 2013 08:33:16 +0200
>>>>>>> Subject: [PATCH] hwmon: (applesmc) Check key count before proceeding
>>>>>>> 
>>>>>>> After reports from Chris and Josh Boyer of a rare crash in applesmc,
>>>>>>> Guenter pointed at the initialization problem fixed below. The patch
>>>>>>> has not been verified to fix the crash, but should be applied
>>>>>>> regardless.
>>>>>>> 
>>>>>>> Reported-by: <jwboyer@fedoraproject.org>
>>>>>>> Suggested-by: Guenter Roeck <linux@roeck-us.net>
>>>>>>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>>>>>>> ---
>>>>>>> drivers/hwmon/applesmc.c | 11 ++++++++++-
>>>>>>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>>>>> 
>>>>>> Thanks for the quick reply.  I'll get this rolled into our kernels soon.
>>>>>> 
>>>>> I sent a pull request to Linus, so you should be able to pull it from
>>>>> the upstream kernel shortly. Would be great to get feedback if the patch
>>>>> solves the problem (or doesn't).
>>>> 
>>>> I'll start running it when it appears in koji. It's very transient, maybe one oops per week with lots of (other) testing. I'm not even sure if it happens on warm or cold boots or both.
>>>> 
>>> When you do, can you possibly trigger an event based on the warning added
>>> with the patch ? This might help us to identify if the problem fixed
>>> with the patch actually happens.
>> 
>> I don't understand the question. I'm uncertain how to trigger, and also what event.
>> 
> 
> The patch includes a new warning message.
> 
> 	pr_warn("key count changed from %d to %d\n",
>                        s->key_count, count);
> 
> It would be great if there would be a means to detect if this message is seen
> in a kernel log, because it would show that the potential crash condition
> fixed with the patch was actually encountered. This would help us to determine
> if we actually fixed the problem or not.
> 
> Of course, we'll know if is wasn't fixed if the system still crashes.

Warning message triggered with 3.12.0-0.rc3.git0.1.fc21.x86_64. 

[   10.886016] applesmc: key count changed from 261 to 1174405121

Attaching new full dmesg to the bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=1011719#c11

Chris