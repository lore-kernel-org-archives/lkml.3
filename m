Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaLDLLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:11:14 -0500
Received: from out21.biz.mail.alibaba.com ([205.204.114.132]:41583 "EHLO
	out21.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbaLDLLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:11:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g08153;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=7;RT=7;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Liu, Chuansheng'" <chuansheng.liu@intel.com>
Cc: "'Zhang, Jun'" <jun.zhang@intel.com>, "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Liu, Changcheng'" <changcheng.liu@intel.com>
References: <007f01d00fa1$68bf6770$3a3e3650$@alibaba-inc.com> <CAKfTPtAOTJ1i5HPad4j91SWNiK5m_JRmg6Z4COiC8pADhi3dng@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A01EEA337@SHSMSX101.ccr.corp.intel.com> <CAKfTPtDWpu=nEQ7yyt86y7EUL0=rXGHj7i4KYGH=TSuoJfkEdw@mail.gmail.com>
In-Reply-To: <CAKfTPtDWpu=nEQ7yyt86y7EUL0=rXGHj7i4KYGH=TSuoJfkEdw@mail.gmail.com>
Subject: Re: [PATCH] sched/fair: fix select_task_rq_fair return -1
Date: Thu, 04 Dec 2014 19:10:27 +0800
Message-ID: <009501d00fb2$e90c30f0$bb2492d0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJSp9NksmY1Oxbhvzcu8e1IGpYcmAIwAl8OAVYA1pYCPfQzR5tL9a0Q
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The change below  will give a similar behavior than 3.18 for 3.14 and
> we still match the condition if (new_cpu == -1 || new_cpu == cpu) in
> 
And -1 is no longer needed.

> order to go in the child level
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4151,7 +4151,7 @@ static int
>  find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  {
>         unsigned long load, min_load = ULONG_MAX;
> -       int idlest = -1;
> +       int idlest = this_cpu;
>         int i;
> 
>         /* Traverse only the allowed CPUs */
> 

