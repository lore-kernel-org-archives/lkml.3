Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaG3AKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:10:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55288 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752651AbaG3AKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:10:39 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 0/5] Simplify hotplug/suspend handling
Date: Wed, 30 Jul 2014 02:29:11 +0200
Message-ID: <1667655.2j1xLy7HXa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 06:07:23 PM Saravana Kannan wrote:
> Series of patchs to simplify policy/sysfs/kobj/locking handling across
> suspend/resume

I need someone to review this series for me.  Viresh or Srivatsa, preferably
both.

Thanks!

> The following have been tested so far on a 2x2 cluster environment:
> - Boot with 2 cpus and no cpufreq driver.
> - mod probe driver and see cpufreq sysfs files show up only for the 1st cluster.
> - Online the rest of the 2 CPUs and have files show up correctly.
> - rmmod the driver and see the files go away.
> - modprobe again (or back and forth multiples times) and see it work.
> - suspend/resume works as expected.
> - When a cluster is offline, all read/writes to its sysfs files return an error
> 
> v4
> - Split it up into smaller patches
> - Will handle physical CPU removal correctly
> - Fixed earlier mistake of deleting code under !recover_policy
> - Dropped some code refactor that reuses a lot of code between add/remove
> - Dropped fix for exiting hotplug race with cpufreq driver probe/rmmod
> - Dropped changes will come later once this series is acked.
> 
> 
> Saravana Kannan (5):
>   cpufreq: Don't wait for CPU to going offline to restart governor
>   cpufreq: Keep track of which CPU owns the kobj/sysfs nodes separately
>   cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
>   cpufreq: Properly handle physical CPU hot-add/hot-remove
>   cpufreq: Delete dead code related to policy save/restore
> 
>  drivers/cpufreq/cpufreq.c | 238 ++++++++++++++++++----------------------------
>  include/linux/cpufreq.h   |   1 +
>  2 files changed, 93 insertions(+), 146 deletions(-)
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
