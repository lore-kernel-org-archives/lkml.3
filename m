Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3JCVHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:07:37 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43462 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3JCVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:07:35 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, daniel.lezcano@linaro.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 00/16] CPUIdle: Minor cleanups for 3.13
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Date: Thu, 03 Oct 2013 14:07:31 -0700
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org> (Viresh Kumar's
	message of "Thu, 3 Oct 2013 21:26:39 +0530")
Message-ID: <87vc1et65o.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> Hi Rafael,
>
> These are V2 of my CPUIdle cleanup series.. Few patches are dropped as they
> required further modifications. Last one is rewritten as suggested by Daniel.
> Most of them are already Acked by Daniel.

I gave these a spin on OMAP3 and both full-chip retention and off-mode
during idle are still working fine.

Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin

> Viresh Kumar (16):
>   cpuidle: fix indentation of cpumask
>   cpuidle: Fix comments in cpuidle core
>   cpuidle: make __cpuidle_get_cpu_driver() inline
>   cpuidle: make __cpuidle_device_init() return void
>   cpuidle: make __cpuidle_driver_init() return void
>   cpuidle: rearrange code in __cpuidle_driver_init()
>   cpuidle: rearrange __cpuidle_register_device() to keep minimal exit
>     points
>   cpuidle: merge two if() statements for checking error cases
>   cpuidle: reduce code duplication inside cpuidle_idle_call()
>   cpuidle: replace multiline statements with single line in
>     cpuidle_idle_call()
>   cpuidle: call cpuidle_get_driver() from after taking
>     cpuidle_driver_lock
>   cpuidle: use drv instead of cpuidle_driver in show_current_driver()
>   cpuidle: free all state kobjects from cpuidle_free_state_kobj()
>   cpuidle: don't calculate time-diff if entered_state < 0
>   cpuidle: don't call poll_idle_init() for every cpu
>   cpuidle: remove cpuidle_unregister_governor()
>
>  Documentation/cpuidle/governor.txt |  1 -
>  drivers/cpuidle/coupled.c          |  2 +-
>  drivers/cpuidle/cpuidle.c          | 95 ++++++++++----------------------------
>  drivers/cpuidle/driver.c           | 69 ++++++++++++++++++++-------
>  drivers/cpuidle/governor.c         | 43 -----------------
>  drivers/cpuidle/sysfs.c            | 30 ++++++------
>  include/linux/cpuidle.h            |  8 +---
>  7 files changed, 94 insertions(+), 154 deletions(-)
