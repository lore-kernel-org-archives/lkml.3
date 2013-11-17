Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3KQQXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:23:33 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60544 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab3KQQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:23:16 -0500
MIME-Version: 1.0
In-Reply-To: <3555392.CLJaBWE9DL@vostro.rjw.lan>
References: <9847309.KdKOG5y1Zx@vostro.rjw.lan>
	<1384616184-6197-1-git-send-email-tianyu.lan@intel.com>
	<5288425A.6000501@linaro.org>
	<3555392.CLJaBWE9DL@vostro.rjw.lan>
Date: Sun, 17 Nov 2013 21:53:15 +0530
Message-ID: <CAKohpokhMk47kP1yCcNSuFG6K6s70YBU-SKJ3x0imyDAvWSaKQ@mail.gmail.com>
Subject: Re: [PATCH V2] Cpufreq: Make governor data on nonboot cpus across
 system suspend/resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 November 2013 20:14, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Sunday, November 17, 2013 09:43:14 AM viresh kumar wrote:

>> +               else if (event == CPUFREQ_GOV_POLICY_INIT)
>> +                       if (ret == -EALREADY) {
>
> You can write this as
>
>                else if (event == CPUFREQ_GOV_POLICY_INIT && ret == -EALREADY) {

I wrote it that way on the first go (though with separate braces for
both comparisons
as well), but there were multiple statements to enclose and so will
require {} and then
that would have to be added for above single line if/else as well, if
we follow coding
guidelines properly..

Anyway, this code is no more required. :)

>> +                               module_put(policy->governor->owner);
>> +                               ret = 0;
>> +                       }
>>                 mutex_unlock(&cpufreq_governor_lock);
>>         }
>>
>> -       if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
>> -                       ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
>> -               module_put(policy->governor->owner);
>> -
>>         return ret;
>
> Apart from the above I agree.

Thanks..
