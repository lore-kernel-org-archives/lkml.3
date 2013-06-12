Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3FLECT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 00:02:19 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:61366 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3FLECR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 00:02:17 -0400
MIME-Version: 1.0
In-Reply-To: <11735265.3zXb8Z81XT@vostro.rjw.lan>
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
	<11735265.3zXb8Z81XT@vostro.rjw.lan>
Date: Wed, 12 Jun 2013 09:32:16 +0530
Message-ID: <CAKohpomwDonECPOPoSZvrOS+mRyNARX4Sk1XoEAGLXrOQQjYjA@mail.gmail.com>
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 03:44, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, June 05, 2013 05:11:22 PM Chanwoo Choi wrote:
>> This patch add new sysfs file to show previous accumulated data of CPU load
>> as following path. This sysfs file is used to judge the correct system state
>> or determine suitable system resource on user-space.
>> - /sys/devices/system/cpu/cpu0/cpufreq/stats/load_table
>>
>> This sysfs file include following data:
>> - Measurement point of time
>> - CPU frequency
>> - Per-CPU load
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Well, first of all, there is the "one value per file" rule for sysfs attributes
> which is evidently violated by this code.

Even this was enclosed in CONFIG_CPU_FREQ_STAT_DETAILS,
so even sysfs isn't that bad as we already had something similar here.

> Second, this looks like a feature needed to handle one particular platform, so
> why do you want to add it to the cpufreq core?

I really felt this would be useful to others. They can track the load on
all cores for some time and that will really be useful. People can
understand their loads and system more easily with this patch in.
