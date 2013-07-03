Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3GCGlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:41:19 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:38792 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab3GCGlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:41:14 -0400
MIME-Version: 1.0
In-Reply-To: <51D2B03A.3010806@samsung.com>
References: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
	<CAKohpon6AaSRQKvffPG+J=NUU+5JdVhFo-_uMm=2H3u-yT5h0A@mail.gmail.com>
	<51CD55E2.5060205@samsung.com>
	<CAKohpokY+GEt9UaU5inWaiooLq8sX7jy63sok+FFvs_KyQpcKg@mail.gmail.com>
	<51D2B03A.3010806@samsung.com>
Date: Wed, 3 Jul 2013 12:11:14 +0530
Message-ID: <CAKohpokZP=zJFoMGmQ7RY7OrttmbG+o2Hf+6ybJdx9PFqKmNPg@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 July 2013 16:19, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Previously, I sent two reply about your reply. But, Please ignore previous reply.
> Those have wrong function flow about creating sysfs file and poor wrong opinion.
>
> I'm so sorry if you're confused.

Its okay.

> OK. I'll create link for CPU[1-3] if multiple core use one cpufreq policy.
> In result, we can check below directory structure.
>
> sh-4.1# ls -al /sys/kernel/debug/cpufreq/
> total 0
> drwxr-xr-x  3 root root 0 Jan  1 09:00 .
> drwx------ 26 root root 0 Jan  1 09:00 ..
> drwxr-xr-x  2 root root 0 Jan  1 09:00 cpu0
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu1 -> ./cpu0
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu2 -> ./cpu0
> lrwxrwxrwx  1 root root 0 Jan  1 09:00 cpu3 -> ./cpu0
>
> And then I will create load_table debugfs file below of /sys/kernel/debug/cpufreq/cpu0
> in cpufreq_stats.c

Looks good.

> I understand your opinion. But I have a suggestion for using load_table debugfs file
> if cpufreq governor is performance/powersave.
>
> So, I suggest that performance/powersave governor may need to executes dbs_check_cpu()
> to calculate CPUx load. Sometimes, we need CPUs load on performance/powersave
> govenor because we could get different power-consumption according to CPUs load
> on same cpu frequency when we estimate power-consumption on specific test case.

How will these two call dbs_check_cpu()? We don't have a timer for
those two governors :)

Okay do one thing. Create debugfs and debug/cpufreq/cpuX directory always.
Let load_table contain zero when we have irrelevant governors set for it.

We will see if we want some smart code in place for this or not.
