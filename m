Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648Ab3EGVjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:39:39 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40933 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421Ab3EGVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:39:38 -0400
Message-ID: <51897497.7040806@linaro.org>
Date: Tue, 07 May 2013 14:39:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@kernel.org>, Feng Tang <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
References: <20130430074322.GA20110@gmail.com> <20130506230137.GA16801@amd.pavel.ucw.cz> <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com> <20130507023853.GA2945@feng-snb> <20130507065348.GF17705@gmail.com> <51892560.7090202@linaro.org> <20130507213142.GA10061@amd.pavel.ucw.cz>
In-Reply-To: <20130507213142.GA10061@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 02:31 PM, Pavel Machek wrote:
> On Tue 2013-05-07 09:01:36, John Stultz wrote:
>> On 05/06/2013 11:53 PM, Ingo Molnar wrote:
>>> * Feng Tang <feng.tang@intel.com> wrote:
>>>
>>>>> is even worse than that. Machine can stay is s2ram for weeks (for a
>>>>> lot more if it is desktop and you do s2ram for powersaving). Also
>>>>> temperature of CPU varies a lot between active and s2ram states. Is
>>>>> TSC good enough?
>>>> Yes, I think it is relatively precise. Per our test, system time backed
>>>> by the S3 non stop TSC only has 1 second drift after 4 days running
>>>> (with mixed running and S3 states). And before using this feature, we've
>>>> seen many time drift problems due to the RTC HW or system FW with our
>>>> platforms.
>>> Nice result ...
>>>
>>> Is that with NTP running?
>>>
>>> Without NTP, the TSC fast-calibration on bootup is not (expected to be)
>>> nearly as precise as the 1:345600 precision you've measured.
>> We also do refined calibration now on the TSC asynchronously over a
>> period of seconds at boot up that gives us much better accuracy then
>> the fast calibration. This helps provide much more consistent
>> boot-to-boot TSC frequencies.
> On android (and this is targetted at android, right?) system is going
> to suspend basically as soon as it boots. Will refined calibration
> have enough time to do its job?
I don't *think* this is a concern. The refined calibration only takes a 
few seconds while the system is booting and has always completed before 
userspace starts on the systems I have. Even so, I don't believe on boot 
Android will trigger the autosleep code until its userland is up and 
running, which takes more then a few seconds on the devices I've seen.


> And... reason for all this is that RTC has one second granularity when
> accessed naively. But surely we could poll RTC X times a second,
> getting error down by factor of X?
Well, we can poll the RTC trying to get closer to the second edge, but 
that's somewhat expensive, and for suspend/resume would delay things 
more then whats acceptable.

Sorry. You seem to not like the merged change, but I guess I'm not quite 
sure what exactly your objection is here.

thanks
-john

