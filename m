Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3FCGLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:11:32 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61909 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3FCGL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:11:26 -0400
MIME-Version: 1.0
In-Reply-To: <51AA1BFF.20803@semaphore.gr>
References: <51A7BFA6.3070800@semaphore.gr>
	<CAKohpo=oD9Wgr0Y9zA3aVCdMq5MUC5GESWyL45h=izRyp9-CLA@mail.gmail.com>
	<51A8D0C2.1080801@semaphore.gr>
	<CAKohpokmn-Rf-1w2aQHMMMkMbJqxokWXm5ye3DNuc-yzzk=7pQ@mail.gmail.com>
	<51AA1BFF.20803@semaphore.gr>
Date: Mon, 3 Jun 2013 11:41:25 +0530
Message-ID: <CAKohpom3AA3xCHqZ-TeWgOgwM-=CQxd0XSAmKp85mR-p6txmcg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 June 2013 21:36, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> On 06/01/2013 05:56 PM, Viresh Kumar wrote:

>> Even removal of __cpufreq_driver_getavg() should be done in a separate
>> patch, so that it can be reverted easily if required later.
>
> Thanks, Viresh. I will do the removal of that function in a seperate patch.
> Should I use a third patch for it? Or should I include it in the patch which
> will remove APERF/MPERF support?

Maybe a third patch would be more cleaner.

>> Why are you changing it to cpuinfo.max_freq?? This is fixed once a driver is
>> initialized.. but user may request a lower max freq for a governor or policy.
>> Which is actually reflected in policy->max I believe.
>
> My initial thought is to have a linear function to calculate the target freq
> proportional to load: (I will use 'C' as the function's slope as Rafael used it)
>
> freq_target = C * load
>
> For simplicity, let's assume that load is between 0 and 1 as initially is calculated
> in governor.
> Ideally,  for a load = 0, we should have freq_target = 0 and for load = 1,
> freq_target = cpuinfo.max
>
> So, the slope C = cpuinfo.max
>
> I think, it's matter of definition about what policy->min and policy->max can do.
> Should they change the slope C? Or only limit freq_target?
> I don't think that the policy->max (or min) should affect HOW (slope C) governor
> calculates freq_target but only limit the calculated result.
>
> Maybe, we could have separate tunables to a affect the slope C.
>
> If I'm wrong about the definition of policy->min, policy->max, I would change
> the code accordingly.

Lets discuss that in reply to Rafael's mail.

>> As, if load is over 95, then even policy->max * 95 / 100 will even give almost
>> the same freq.
>>
>
> I thought that too. But maybe user selects a lower value for up_threshold.
> (For example, up_threshold = 60). In my opinion, we have to keep up_theshold,
> to give the possibility to user to have max freq with small loads.

Yes... good point.
