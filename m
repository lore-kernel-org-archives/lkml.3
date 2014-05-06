Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbaEFIeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:34:09 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:47098 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934253AbaEFIdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:33:44 -0400
Message-ID: <53689E62.9090403@linaro.org>
Date: Tue, 06 May 2014 16:33:38 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org> <20140429145221.GH2639@e103034-lin> <5360C15B.9060608@linaro.org>
In-Reply-To: <5360C15B.9060608@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Maybe the predication is reasonable on per task history. but on a cpu
> load history, with many tasks rebalance. No testing show current method
> is helpful.
> 
> For task load change, scheduler has no idea for its future except guess
> from its history. but for cpu load change, scheduler know this from task
> wakeup and balance, which both under control and its aim.
> 
> 
> I think the first patch of this serial has the same effect of LB_LIAS
> disable. and previous result show performance is good.
> 
> Anyway, I just pushed the following patch to github, maybe fengguang's
> testing system will care this.

Fengguang,

Are there any performance change on
https://github.com/alexshi/power-scheduling.git noload repository?

> 
> diff --git a/kernel/sched/features.h b/kernel/sched/features.h
> index 5716929..0bf649f 100644
> --- a/kernel/sched/features.h
> +++ b/kernel/sched/features.h
> @@ -43,7 +43,7 @@ SCHED_FEAT(ARCH_POWER, true)
> 
>  SCHED_FEAT(HRTICK, false)
>  SCHED_FEAT(DOUBLE_TICK, false)
> -SCHED_FEAT(LB_BIAS, true)
> +SCHED_FEAT(LB_BIAS, false)
> 
> 


-- 
Thanks
    Alex
