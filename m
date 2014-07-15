Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaGOFhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 01:37:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56064 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbaGOFhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 01:37:01 -0400
Message-ID: <53C4BDFB.70707@codeaurora.org>
Date: Mon, 14 Jul 2014 22:36:59 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org> <1405052287-4744-1-git-send-email-skannan@codeaurora.org> <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com> <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org> <CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com> <53C0A12A.2060204@codeaurora.org> <CAKohpon9en_VnSx+CVydPsWBHtArvmazn0hrodrRJt9jgOa0-g@mail.gmail.com> <53C42AA8.8010107@codeaurora.org> <CAKohpomkqbHZo9KrJMSwsEKGt6+Ac2Fg2X0+S7ZAo=OzhAc45g@mail.gmail.com>
In-Reply-To: <CAKohpomkqbHZo9KrJMSwsEKGt6+Ac2Fg2X0+S7ZAo=OzhAc45g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 09:35 PM, Viresh Kumar wrote:
> On 15 July 2014 00:38, Saravana Kannan <skannan@codeaurora.org> wrote:
>> Yeah, it definitely crashes if policy->cpu if an offline cpu. Because the
>> mutex would be uninitialized if it's stopped after boot or it would never
>> have been initialized (depending on how you fix policy->cpu at boot).
>>
>> Look at this snippet on the actual tree and it should be pretty evident.
>
> Yeah, I missed it. So the problem is we initialize timer_mutex's for
> policy->cpus. So we need to do that just for policy->cpu and also we don't
> need a per-cpu timer_mutex anymore.
>

Btw, I tried to take a stab at removing any assumption in cpufreq code 
about policy->cpu being ONLINE. There are 160 instances of those of with 
23 are in cpufreq.c

So, even if we are sure cpufreq.c is fine, it's 137 other uses spread 
across all the other files. I definitely don't want to try and fix those 
as part of this patch. Way too risky and hard to get the test coverage 
it would need. Even some of the acpi cpufreq drivers seem to be making 
this assumption.

Btw, I think v3 is done. I did some testing and it was fine. But made 
some minor changes. Will test tomorrow to make sure I didn't break 
anything with the minor changes and then send them out.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
