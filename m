Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3BAGqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:46:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46525 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab3BAGqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:46:48 -0500
Message-ID: <510B6510.6060608@ti.com>
Date: Fri, 1 Feb 2013 12:17:44 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        <robin.randhawa@arm.com>, <Steve.Bannister@arm.com>,
        <Liviu.Dudau@arm.com>, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 3/3] cpufreq: Remove unnecessary use of policy->shared_type
References: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org> <902bed453159832925df76e24806f3b919fdfc74.1359700706.git.viresh.kumar@linaro.org>
In-Reply-To: <902bed453159832925df76e24806f3b919fdfc74.1359700706.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2013 12:10 PM, Viresh Kumar wrote:
> policy->shared_type field was added only for SoCs with ACPI support:
>
> commit 3b2d99429e3386b6e2ac949fc72486509c8bbe36
> Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Date:   Wed Dec 14 15:05:00 2005 -0500
>
>      P-state software coordination for ACPI core
>
>      http://bugzilla.kernel.org/show_bug.cgi?id=5737
>
> Many non-ACPI systems are filling this field by mistake, which makes its usage
> confusing. Lets clean it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
I haven't looked at the cpufreq code recently but remember
that it was needed to ensure that all the CPU which
share clock/voltage gets updated (affected cpus) on
freq change. The CPUs which needs SW co-ordination, should
have this flag enabled and OMAP was falling in that category.

May be I miss-understood its use, but can you confirm that
SW co-ordination logic continues to work without this flag ?

Regards,
Santosh

