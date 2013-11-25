Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3KYViB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:38:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57530 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab3KYVh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:37:58 -0500
Message-ID: <5293C327.2030606@ti.com>
Date: Mon, 25 Nov 2013 15:37:43 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>
CC: <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <kgene.kim@samsung.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <jinchoi@broadcom.com>,
        <tianyu.lan@intel.com>, <sebastian.capella@linaro.org>,
        <jhbird.choi@samsung.com>
Subject: Re: [PATCH V3 0/6] cpufreq: suspend early/resume late
References: <cover.1385374819.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385374819.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 08:11 AM, Viresh Kumar wrote:
> This patchset adds cpufreq callbacks to dpm_{suspend|resume}() for handling
> suspend/resume of cpufreq governors and core. This is required for early suspend
> and late resume of governors and cpufreq core.
> 
> There are multiple problems that are fixed by this patch:
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
>   wasn't working well with suspend/resume as calls for removing non-boot CPUs
>   was turning out into a call to drivers ->target() which then tries to play
>   with regulators. But regulators and their I2C bus were already suspended and
>   this resulted in a failure. Many platforms have such problems, samsung, tegra,
>   etc.. They solved it with driver specific PM notifiers where they used to
>   disable their driver's ->target() routine. Most of these are updated in this
>   patchset to use new infrastructure.
> 
> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
>   tunables configuration for clusters/sockets with non-boot CPUs was getting
>   lost after suspend/resume, as we were notifying governors with
>   CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
>   deallocating memory for tunables. This is also fixed with this patch as don't
>   allow any operation on Governors during suspend/resume now.
> 
> 
> So to solve these issues we introduce early suspend and late resume callbacks
> which would remove need of cpufreq drivers to implement PM notifiers to disable
> transition after suspend and before resume.
> 
> @Nishanth: Can you please test V2 as well and confirm that suspend_noirq()
> doesn't work for you. I am sure it will not, but would be better if you confirm
> that.
> 
> Viresh Kumar (6):
>   cpufreq: suspend governors on system suspend/hibernate
>   cpufreq: call driver's suspend/resume for each policy
patches 1-2,
Tested-by: Nishanth Menon <nm@ti.com>
http://pastebin.mozilla.org/3670932

Prior to these two patches: http://pastebin.mozilla.org/3670933
cpufreq driver used: cpufreq_cpu0


-- 
Regards,
Nishanth Menon
