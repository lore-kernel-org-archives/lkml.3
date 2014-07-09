Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaGIOyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:54:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47177 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbaGIOxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:53:55 -0400
Message-ID: <53BD576F.2010408@ti.com>
Date: Wed, 9 Jul 2014 10:53:35 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>,
        <shawn.guo@linaro.org>
CC: <nm@ti.com>, <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <t.figa@samsung.com>,
        <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <thomas.ab@samsung.com>, <arvind.chauhan@arm.com>,
        <spk.linux@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 09/14] cpufreq: cpu0: Move per-cluster initialization
 code to ->init()
References: <cover.1404231535.git.viresh.kumar@linaro.org> <b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 01 July 2014 12:32 PM, Viresh Kumar wrote:
> Currently this driver only support platforms on which all CPUs share clock &
> voltage lines and there is requirement to support platforms which have separate
> clock & voltage lines for CPUs, like Qualcomm's Krait and ARM's big LITTLE.
> 
> Each group of CPUs sharing clock/voltage lines are represented by 'struct
> cpufreq_policy' in cpufreq framework. And core calls ->init() once for each
> policy.
> 
> Currently we do all initialization/allocation from probe() which wouldn't work
> for above scenario. To make it work for these platforms, the first step is to
> move all initialization/allocation to ->init() and add ->exit() to do the
> reverse of it.
> 
> Also, remove all global variables and allocate space for them at runtime.
> 
> This patch creates 'struct private_data' for keeping all such information and
> a pointer to that would be stored in policy->driver_data.
> 
> The changed probe() routine now tries to see if regulator/clocks are available
> or we need to defer probe. In case they are available, it registers cpufreq
> driver. Otherwise, returns with -EPROBE_DEFER.
> 
> We still *don't* support platforms with separate clock/voltage lines for CPUs.
> This would be done in a separate patch.
> 
I scanned this patch and subsequent patches from the series. Since you are
modifying the interfaces and bindings, I just think its better if we can
address the cases where separate clock lines will be used by CPUs.

Surely don't want to increase your work neither want hold the progress
of the series but if you look at the changes to the interfaces, they
give you a feeling of incompleteness.

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
Would you able to give some idea about what will it take to address that one
remainder case as well as part of this series.

Regards,
Santosh
