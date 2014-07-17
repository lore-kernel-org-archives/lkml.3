Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaGQFfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 01:35:17 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:37594 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaGQFfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 01:35:15 -0400
MIME-Version: 1.0
In-Reply-To: <53C6D8EC.1030609@codeaurora.org>
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
	<1405464473-3916-2-git-send-email-skannan@codeaurora.org>
	<CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
	<53C65F03.1050609@mit.edu>
	<53C6D8EC.1030609@codeaurora.org>
Date: Thu, 17 Jul 2014 11:05:14 +0530
Message-ID: <CAKohpongsNtEVbHL=w1fbw5tEXK=WaMcp1N03ar9Sx_CU=1O-w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Srivatsa S. Bhat" <srivatsa@mit.edu>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2014 01:26, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 07/16/2014 04:16 AM, Srivatsa S. Bhat wrote:

>> That is, we wanted
>> to do the kobject cleanup after releasing the hotplug lock, and POST_DEAD
>> stage was well-suited for that.

I think, this has changed in Saravana's patch, we do it in the PREPARE stage
now.

>> Commit 1aee40ac9c8 (cpufreq: Invoke __cpufreq_remove_dev_finish() after
>> releasing cpu_hotplug.lock) explains this in detail. Saravana, please take
>> a
>> look at that reasoning and ensure that your patch doesn't re-introduce
>> those
>> deadlock possibilities!
>
>
> But all of that was needed _because_ we were creating and destroying
> policies and kobjs all the time. We don't do that anymore. So, I don't think
> any of that applies. We only destroy when the cpufreq driver is
> unregistered. That's kinda of the point of this patchset.
>
> Thoughts?

See above.
