Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaIIG0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:26:21 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40226 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaIIG0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1Daczk+YT3ETviCL5d7xLGKzRL+AAo1z6rLs=r+j5+r45-xw@mail.gmail.com>
References: <1410221424-20590-1-git-send-email-anupc@chromium.org>
	<CAKohponb199_zt11M2J39yHn45MjFMSrT+hPBp7rbqiHu4vKpQ@mail.gmail.com>
	<CAN1Daczk+YT3ETviCL5d7xLGKzRL+AAo1z6rLs=r+j5+r45-xw@mail.gmail.com>
Date: Tue, 9 Sep 2014 11:56:18 +0530
X-Google-Sender-Auth: aQLcDMoJ5LcNWyE3UiNCC1Ibm6Y
Message-ID: <CAOh2x==oX4HN2NJ=bMUzyuL0K9KdrmV7HjRctX9dio7yw-4sbQ@mail.gmail.com>
Subject: Re: [PATCH] intel_pstate: track and export frequency residency stats
 via sysfs.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Anup Chenthamarakshan <anupc@chromium.org>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Sameer Nanda <snanda@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 11:02 AM, Anup Chenthamarakshan
<anupc@chromium.org> wrote:
> I had initially tried reusing cpufreq_stats.c to export stats.
> Calling cpufreq_stats_update() via the cpufreq notifier added
> some amount of overhead while switching frequencies. Specifically,
> looking up the index of the new frequency in freq_table_get_index()
> is a linear search through all available frequencies (vs a single
> subtraction with custom stats export). Also, the notifier mechanism

I don't think just this linear search will make things so bad..

> itself added a level of indirection before calling stats_update.

Probably some other notifier is registered which is taking considerable
amount of time.. Try checking what all registered with cpufreq-core.

> There is a 5X increase in time taken to complete intel_pstate_set_pstate
> while using cpufreq_stats compared to having custom stats exported.

Try calling cpufreq_stat_notifier_trans() directly instead of a notifier
and lets see if this makes it any better.
