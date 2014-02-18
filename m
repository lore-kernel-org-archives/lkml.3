Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaBRUa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:30:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38101 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBRUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:30:56 -0500
Message-ID: <5303C2FC.8040508@wwwdotorg.org>
Date: Tue, 18 Feb 2014 13:30:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        kgene.kim@samsung.com, jinchoi@broadcom.com, tianyu.lan@intel.com,
        sebastian.capella@linaro.org, jhbird.choi@samsung.com
Subject: Re: [PATCH V6 0/7] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
References: <cover.1392629003.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1392629003.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 02:25 AM, Viresh Kumar wrote:
> This patchset creates/calls cpufreq suspend/resume callbacks from dpm_{suspend|resume}()
> for handling suspend/resume of cpufreq governors and core.
> 
> There are multiple problems that are fixed by this patch:
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
>   wasn't working well with suspend/resume as calls for removing non-boot CPUs
>   was turning out into a call to drivers ->target() which then tries to play
>   with regulators. But regulators and their I2C bus were already suspended and
>   this resulted in a failure. Many platforms have such problems, samsung, tegra,
>   etc.. They solved it with driver specific PM notifiers where they used to
>   disable their driver's ->target() routine.
> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found an issue where tunables
>   configuration for clusters/sockets with non-boot CPUs was getting lost after
>   suspend/resume, as we were notifying governors with CPUFREQ_GOV_POLICY_EXIT on
>   removal of the last cpu for that policy and so deallocating memory for
>   tunables.  This is fixed by this patch as we don't allow any operation on
>   governors after device suspend and before device resume now.

The series,
Tested-by: Stephen Warren <swarren@nvidia.com>

Patch 7/7,
Acked-by: Stephen Warren <swarren@nvidia.com>

