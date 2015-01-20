Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbbATQzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:55:24 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58393 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbATQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:55:23 -0500
Message-ID: <54BE8868.2080101@gmail.com>
Date: Tue, 20 Jan 2015 19:55:04 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra20: Store CPU "resettable" status in IRAM
References: <1421319545-23920-1-git-send-email-digetx@gmail.com> <1421319545-23920-2-git-send-email-digetx@gmail.com> <20150119141224.GF23778@ulmo.nvidia.com> <54BD3E3E.2040801@wwwdotorg.org> <54BD41D3.7030703@gmail.com> <54BD42D0.3020107@wwwdotorg.org> <54BD4626.70902@gmail.com> <54BD4C42.6090407@gmail.com>
In-Reply-To: <54BD4C42.6090407@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.01.2015 21:26, Dmitry Osipenko пишет:
> 19.01.2015 21:00, Dmitry Osipenko пишет:
>> 19.01.2015 20:45, Stephen Warren пишет:
>>> On 01/19/2015 10:41 AM, Dmitry Osipenko wrote:
>>>> 19.01.2015 20:26, Stephen Warren пишет:
>>>>> Hopefully this works out. I suppose it's unlikely anyone will be
>>>>> running code on
>>>>> the AVP upstrem, so any potential conflict with AVP's usage of IRAM
>>>>> isn't likely
>>>>> to occur.
>>>>>
>>>> I don't see how it can conflict with AVP code. First KB of IRAM is
>>>> reserved for reset handler. Am I missing something?
>>>>
>>>>  From reset.h:
>>>>
>>>> /* The first 1K of IRAM is permanently reserved for the CPU reset
>>>> handler */
>>>
>>> I believe "CPU" in that context means AVP CPU. Still, I may not be correct, and
>>> to be honest it's likely not too well defined even if that comment seems
>>> clear-cut.
>>>
>> Hmm... Suddenly I recalled that LP2 was always disabled in downstream kernel. I
>> remember that I tried it once (couple years ago) and it didn't work, however I
>> presume it was just broken. Now I don't feel good with it.
>>
> Can't generic RAM be used for "resettable" status? Or it will be too slow?...
>
> CPU1 always come up after CPU0, so RAM is already init'ed. Given that CPU0 can't
> be halted with running CPU1, I suppose CPU1 can't be booted first, right? Anyway
> it's not the case for linux.
>
Correcting myself:

Well, it's meaningless in case if LP2 cpuidle can't co-exist with AVP firmware. 
Isn't possible verify it?

-- 
Dmitry
