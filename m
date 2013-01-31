Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3AaSpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:45:31 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:65243 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab3AaSpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:45:03 -0500
Date: Thu, 31 Jan 2013 19:44:49 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 1/2] cpufreq: governors: Get rid of dbs_data->enable field
Message-ID: <20130131184449.GA20164@balto.lan>
References: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:58:01PM +0530, Viresh Kumar wrote:
> CPUFREQ_GOV_START/STOP are called only once for all policy->cpus and hence we
> don't need to adapt cpufreq_governor_dbs() routine for multiple calls.
> 
> So, this patch removes dbs_data->enable field entirely. And rearrange code a
> bit.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Fabio,
> 
> I have fixed all the pending issues, but haven't checked these patches. Can you
> please add your tested-by (obviously after testing them) ?
> 
> Compile tested only.

Hello Viresh, thanks for getting this done... looks much cleaner now!

I tested both patches on my ux500 setup (dual Cortex-A9) and it seems to
run correctly on both CPU load changes and CPU hotplug, so:

Tested-by: Fabio Baltieri <fabio.baltieri@linaro.org>

As a sidenote, I noticed just now that since:

bc92bea cpufreq: Notify governors when cpus are hot-[un]plugged

governor's sampling_rate gets reset to default every time you hotplug a
CPU (the one you read/write on
/sys/devices/system/cpu/cpufreq/ondemand/sampling_rate).

If you need further tests, I'll be back on Monday.

Thanks,
Fabio

-- 
Fabio Baltieri
