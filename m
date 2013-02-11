Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3BKJKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:10:43 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46163 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab3BKJKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:10:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130211085220.GA10857@localhost>
References: <20130211085220.GA10857@localhost>
Date: Mon, 11 Feb 2013 14:40:39 +0530
Message-ID: <CAKohpo=WRgdBUfzKrs7yeNDCgT6w+j7GPFr8QfbPOShdGgEd1w@mail.gmail.com>
Subject: Re: [cpufreq] WARNING: at kernel/lockdep.c:2739 lockdep_trace_alloc()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2013 14:22, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,

Hi Fengguang,

> I got the below oops and the first bad commit is
>
> commit 50f6802f8dccb7bbad29010e57973d46b7e7a07e
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Thu Feb 7 10:55:00 2013 +0530

There is something really wrong. This problem was earlier reported
and was fixed immediately. And shouldn't be there with linux-next
branch of Rafael.

What tree are you working on ?

Even in linux-next/master i see above commit as:

commit 2eaa3e2df185997e92596ab14a2a67dde3876d2e
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Thu Feb 7 10:55:00 2013 +0530

    cpufreq: Fix locking issues

    cpufreq core uses two locks:
    - cpufreq_driver_lock: General lock for driver and cpufreq_cpu_data array.
    - cpu_policy_rwsemfix locking: per CPU reader-writer semaphore
designed to cure
      all cpufreq/hotplug/workqueue/etc related lock issues.

    These locks were not used properly and are placed against their principle
    (present before their definition) at various places. This patch is
an attempt to
    fix their use.

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/cpufreq.c | 72
++++++++++++++++++++++++++++++++++++++----------------------------------
 1 file changed, 38 insertions(+), 34 deletions(-)


Which would certainly fix your problem.
