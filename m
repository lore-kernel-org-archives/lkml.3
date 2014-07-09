Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbaGIPHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:07:53 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63135 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaGIPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <53BD52B1.4060608@ti.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<0614df495e361dd23ebe2d4e4ee3d40cb23948da.1404231535.git.viresh.kumar@linaro.org>
	<53BD52B1.4060608@ti.com>
Date: Wed, 9 Jul 2014 20:37:41 +0530
Message-ID: <CAKohpo=YQwjbDRec6Sj1JbjL-0GbKmzBUxtRY610bHe0suKt6A@mail.gmail.com>
Subject: Re: [PATCH 03/14] cpufreq: Add support for per-policy driver data
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 20:03, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index ec4112d..d4b1108 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -112,6 +112,9 @@ struct cpufreq_policy {
>>       spinlock_t              transition_lock;
>>       wait_queue_head_t       transition_wait;
>>       struct task_struct      *transition_task; /* Task which is doing the transition */
>> +
>> +     /* For cpufreq driver's internal use */
>> +     void                    *driver_data;
>>  };
>>
> Minor comment for consistency either maintain same commenting style
> for the above structure (description after the variable) or may
> be clean up the comments in another patch.

Adding these to the end of variable makes it take multiple lines as we need
to break after 80 columns. And both the styles are already mixed
in existing file. So, would fix it separately in case I go for it :)
