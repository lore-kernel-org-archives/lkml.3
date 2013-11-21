Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3KUPyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:54:07 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47602 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab3KUPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:54:03 -0500
MIME-Version: 1.0
In-Reply-To: <2383693.rhJDd9X40m@vostro.rjw.lan>
References: <9847309.KdKOG5y1Zx@vostro.rjw.lan>
	<1384616184-6197-1-git-send-email-tianyu.lan@intel.com>
	<2383693.rhJDd9X40m@vostro.rjw.lan>
Date: Thu, 21 Nov 2013 21:24:02 +0530
Message-ID: <CAKohponphVhZ3T1HD2AfhPBUn9SfQyrqdbvW3bEJFzRdKF2i0Q@mail.gmail.com>
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

On 21 November 2013 20:13, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> -     if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
>
> The inner parens are not necessary.
>
>> -                     ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
>> +     if ((event == CPUFREQ_GOV_POLICY_INIT) && ret) {
>
> Same here.
>
>> +             module_put(policy->governor->owner);
>> +             if (ret == -EALREADY)
>> +                     return 0;
>> +     } else if ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret) {
>
> Same here.

Logically, yes you are correct. But probably its better for readability to
get these even if you know precedence is going to take care of our
expression..
