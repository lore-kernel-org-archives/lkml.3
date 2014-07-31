Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaGaS0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:26:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaGaS0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:26:19 -0400
Message-ID: <53DA8A41.2030601@redhat.com>
Date: Thu, 31 Jul 2014 14:26:09 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lenny Szubowicz <lszubowi@redhat.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan>
In-Reply-To: <1917362.abr2Y4p7vh@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/31/2014 02:38 PM, Rafael J. Wysocki wrote:
> On Thursday, July 31, 2014 01:57:29 PM Prarit Bhargava wrote:
>>
>> On 07/31/2014 12:36 PM, Rafael J. Wysocki wrote:
>>> On Thursday, July 31, 2014 06:23:18 AM Prarit Bhargava wrote:
>>>>
>>>> On 07/30/2014 10:16 PM, Rafael J. Wysocki wrote:
>>>>> On Wednesday, July 30, 2014 06:36:00 PM Saravana Kannan wrote:
>>>>>> On 07/30/2014 02:40 PM, Rafael J. Wysocki wrote:
>>>>>>> On Wednesday, July 30, 2014 10:18:25 AM Prarit Bhargava wrote:
>>>>>>>>
>>>>>>>> On 07/29/2014 08:03 PM, Rafael J. Wysocki wrote:
>>>>>>>>> On Tuesday, July 29, 2014 07:46:02 AM Prarit Bhargava wrote:
>>>>>>>
>>>>>>> [cut]
>>>>>>>
>>>>>>>>>> This patch effectively reverts commit 955ef483.
>>>>>>
>>>>>> The issue reported in this patch is valid. We are seeing that internally 
>>>>>> too. I believe I reported it in another thread (within the past month).
>>>>>>
>>>>>> However, the original patch fixes a real deadlock issue (I'm too tired 
>>>>>> to look it up now). We can revet the original, but it's going to bring 
>>>>>> back the original issue. I just want to make sure Prarit and Raphael 
>>>>>> realize this before proceeding.
>>>>>>
>>>>>> I do have plans for a proper fix for the mainline (not stable branches), 
>>>>>> but plan to do that after the current set of suspend/hotplug patches go 
>>>>>> through. The fix would be easier to make after that.
>>>>>>
>>>>>>>>>
>>>>>>>>> OK, I'm convinced by this.
>>>>>>>>>
>>>>>>>>> I suppose we should push it for -stable from 3.10 through 3.15.x, right?
>>>>>>>>
>>>>>>>> Rafael, I think that is a good idea.  I'm not sure what the protocol is for
>>>>>>>> adding stable@kernel.org though ...
>>>>
>>>> Rafael, let me (again) re-write the patch description.  I think Saravana has
>>>> raised an important issue that I have not clearly identified why it is safe to
>>>> remove this code in my patch description.  Also, I want to clearly identify the
>>>> appropriate -stable releases to push this out to.
>>>>
>>>> I'll submit a [v3] later today or tomorrow.
>>>
>>> In any case that's too late for 3.16 final, unless there's an -rc8.
>>>
>>> Thanks for doing that work!
>>
>> Ugh ... I tried this (yet another) large system and hit another panic :(.
>>
>> I'm investigating now, and I'm hoping this is just something "new".
> 
> Well, I've applied your patch as is and I can push it to Linus.
> 
> However, if you want to update the changelog, I'll not do that, but in that
> case the patch will have to wait for the next week.

Rafael, please let it wait for next week.  I _need_ to make sure this is correct
and I'd rather not pushed something half-done.

Thanks,

P.

> 
> Rafael
> 
