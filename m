Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaHGGE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:04:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49454 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaHGGE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:04:26 -0400
Message-ID: <e56e038d44951df6fc371b07d173c000.squirrel@www.codeaurora.org>
In-Reply-To: <1667655.2j1xLy7HXa@vostro.rjw.lan>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
    <1667655.2j1xLy7HXa@vostro.rjw.lan>
Date: Thu, 7 Aug 2014 06:04:25 -0000
Subject: Re: [PATCH v4 0/5] Simplify hotplug/suspend handling
From: skannan@codeaurora.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Todd Poynor" <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Stephen Boyd" <sboyd@codeaurora.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rafael J. Wysocki wrote:
> On Thursday, July 24, 2014 06:07:23 PM Saravana Kannan wrote:
>> Series of patchs to simplify policy/sysfs/kobj/locking handling across
>> suspend/resume
>
> I need someone to review this series for me.  Viresh or Srivatsa,
> preferably
> both.
>
> Thanks!

This took quite a bit of work to get to v4. It's been almost 2 weeks.
Could someone please review this? I'll get pulled into some heavy "work"
work soon. I would really prefer not to let this bit rot and later
abandoned due to lack of time on my part. Would really appreciate some
review folks. Thanks.

Regards,
Saravana

>> The following have been tested so far on a 2x2 cluster environment:
>> - Boot with 2 cpus and no cpufreq driver.
>> - mod probe driver and see cpufreq sysfs files show up only for the 1st
>> cluster.
>> - Online the rest of the 2 CPUs and have files show up correctly.
>> - rmmod the driver and see the files go away.
>> - modprobe again (or back and forth multiples times) and see it work.
>> - suspend/resume works as expected.
>> - When a cluster is offline, all read/writes to its sysfs files return
>> an error
>>
>> v4
>> - Split it up into smaller patches
>> - Will handle physical CPU removal correctly
>> - Fixed earlier mistake of deleting code under !recover_policy
>> - Dropped some code refactor that reuses a lot of code between
>> add/remove
>> - Dropped fix for exiting hotplug race with cpufreq driver probe/rmmod
>> - Dropped changes will come later once this series is acked.
>>
>>
>> Saravana Kannan (5):
>>   cpufreq: Don't wait for CPU to going offline to restart governor
>>   cpufreq: Keep track of which CPU owns the kobj/sysfs nodes separately
>>   cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
>>   cpufreq: Properly handle physical CPU hot-add/hot-remove
>>   cpufreq: Delete dead code related to policy save/restore
>>
>>  drivers/cpufreq/cpufreq.c | 238
>> ++++++++++++++++++----------------------------
>>  include/linux/cpufreq.h   |   1 +
>>  2 files changed, 93 insertions(+), 146 deletions(-)
>>
>>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
>


-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

