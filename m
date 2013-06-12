Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3FLK4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:56:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34837 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3FLKz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:55:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to show accumulated data of CPU
Date: Wed, 12 Jun 2013 13:05:09 +0200
Message-ID: <2801243.ZfLEluCnpU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomwDonECPOPoSZvrOS+mRyNARX4Sk1XoEAGLXrOQQjYjA@mail.gmail.com>
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com> <11735265.3zXb8Z81XT@vostro.rjw.lan> <CAKohpomwDonECPOPoSZvrOS+mRyNARX4Sk1XoEAGLXrOQQjYjA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 12, 2013 09:32:16 AM Viresh Kumar wrote:
> On 12 June 2013 03:44, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, June 05, 2013 05:11:22 PM Chanwoo Choi wrote:
> >> This patch add new sysfs file to show previous accumulated data of CPU load
> >> as following path. This sysfs file is used to judge the correct system state
> >> or determine suitable system resource on user-space.
> >> - /sys/devices/system/cpu/cpu0/cpufreq/stats/load_table
> >>
> >> This sysfs file include following data:
> >> - Measurement point of time
> >> - CPU frequency
> >> - Per-CPU load
> >>
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > Well, first of all, there is the "one value per file" rule for sysfs attributes
> > which is evidently violated by this code.
> 
> Even this was enclosed in CONFIG_CPU_FREQ_STAT_DETAILS,
> so even sysfs isn't that bad as we already had something similar here.

Yes, we did, and yes, it was a mistake.  It should have been in debugfs from
the very beginning.

> > Second, this looks like a feature needed to handle one particular platform, so
> > why do you want to add it to the cpufreq core?
> 
> I really felt this would be useful to others. They can track the load on
> all cores for some time and that will really be useful. People can
> understand their loads and system more easily with this patch in.

If it were in debugfs, I'd have no objections.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
