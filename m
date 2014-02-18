Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaBRChY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:37:24 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37916 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaBRChU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:37:20 -0500
Message-ID: <5302C754.8000109@linaro.org>
Date: Tue, 18 Feb 2014 10:37:08 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
CC: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/11] remove cpu_load in rq
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 09:55 AM, Alex Shi wrote:
> The cpu_load decays on time according past cpu load of rq. The sched_avg also decays tasks' load on time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load by decay calculation. This patch try to remove the cpu_load decay.
> 
> There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change.
> 
> V2,
> 1, This version do some tuning on load bias of target load, to maximum match current code logical.
> 2, Got further to remove the cpu_load in rq.
> 3, Revert the patch 'Limit sd->*_idx range on sysctl' since no needs

Any comments for this? :)

> 
> Any testing/comments are appreciated.
> 
> This patch rebase on latest tip/master.
> The git tree for this patchset at:
>  git@github.com:alexshi/power-scheduling.git noload
> 
> Thanks
> Alex
> 


-- 
Thanks
    Alex
