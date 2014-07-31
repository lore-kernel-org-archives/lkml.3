Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaGaBgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 21:36:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55803 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaGaBgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 21:36:01 -0400
Message-ID: <53D99D80.8090905@codeaurora.org>
Date: Wed, 30 Jul 2014 18:36:00 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lenny Szubowicz <lszubowi@redhat.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <1727443.QxEjMbNBsd@vostro.rjw.lan> <53D8FEB1.5040808@redhat.com> <1816455.s1k7EgIPj9@vostro.rjw.lan>
In-Reply-To: <1816455.s1k7EgIPj9@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 02:40 PM, Rafael J. Wysocki wrote:
> On Wednesday, July 30, 2014 10:18:25 AM Prarit Bhargava wrote:
>>
>> On 07/29/2014 08:03 PM, Rafael J. Wysocki wrote:
>>> On Tuesday, July 29, 2014 07:46:02 AM Prarit Bhargava wrote:
>
> [cut]
>
>>>> This patch effectively reverts commit 955ef483.

The issue reported in this patch is valid. We are seeing that internally 
too. I believe I reported it in another thread (within the past month).

However, the original patch fixes a real deadlock issue (I'm too tired 
to look it up now). We can revet the original, but it's going to bring 
back the original issue. I just want to make sure Prarit and Raphael 
realize this before proceeding.

I do have plans for a proper fix for the mainline (not stable branches), 
but plan to do that after the current set of suspend/hotplug patches go 
through. The fix would be easier to make after that.

>>>
>>> OK, I'm convinced by this.
>>>
>>> I suppose we should push it for -stable from 3.10 through 3.15.x, right?
>>
>> Rafael, I think that is a good idea.  I'm not sure what the protocol is for
>> adding stable@kernel.org though ...
>
> I'll take care of this, thanks!
>

But you aren't going to pull the in for the next release, right?

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
