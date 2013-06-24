Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3FXLtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:49:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48974 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab3FXLtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:49:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Subject: Re: [PATCH 00/13] CPUFreq: Fix {PRE|POST}CHANGE notification sequence
Date: Mon, 24 Jun 2013 13:58:43 +0200
Message-ID: <19900521.4upM9YL2PZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 02:22:54 PM Viresh Kumar wrote:
> PRECHANGE and POSTCHANGE notifiers must be called in groups, i.e either both
> should be called or both shouldn't be.
> 
> In case we have started PRECHANGE notifier and found an error, we must call
> POSTCHANGE notifier with freqs.new = freqs.old to guarantee that sequence of
> calling notifiers is complete.
> 
> This isn't obeyed by many of the drivers and core wasn't forcing it.
> 
> This patchset first fixes all the driver to follow it strictly and then adds
> some protection against this. Now, we keep track of the last transaction and see
> if something went wrong.
> 
> Last patch is intentionally kept towards the end, so that git bisect still works
> well for all the faulty drivers.
> 
> This is pushed here and a pull request for 3.11 would be sent after few days.
> 
> git://git.linaro.org/people/vireshk/linux.git cpufreq-fix-notification
> 
> Viresh Kumar (13):
>   cpufreq: acpi: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: arm-big-little: call CPUFREQ_POSTCHANGE notfier in error
>     cases
>   cpufreq: davinci: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: dbx500: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: e_powersave: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: exynos: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: imx6q: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: omap: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: pcc: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: powernow-k8: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: s3c64xx: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: tegra: call CPUFREQ_POSTCHANGE notfier in error cases
>   cpufreq: make sure frequency transitions are serialized

Patches [1,5,9-10/13] applied to bleeding-edge, the ARM ones I'm expecting
to get from you and [13/13] can wait.

Thanks,
Rafael

