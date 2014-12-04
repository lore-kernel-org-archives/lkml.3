Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaLDMKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:10:23 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33027 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaLDMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:10:22 -0500
MIME-Version: 1.0
In-Reply-To: <009501d00fb2$e90c30f0$bb2492d0$@alibaba-inc.com>
References: <007f01d00fa1$68bf6770$3a3e3650$@alibaba-inc.com>
 <CAKfTPtAOTJ1i5HPad4j91SWNiK5m_JRmg6Z4COiC8pADhi3dng@mail.gmail.com>
 <27240C0AC20F114CBF8149A2696CBE4A01EEA337@SHSMSX101.ccr.corp.intel.com>
 <CAKfTPtDWpu=nEQ7yyt86y7EUL0=rXGHj7i4KYGH=TSuoJfkEdw@mail.gmail.com> <009501d00fb2$e90c30f0$bb2492d0$@alibaba-inc.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 4 Dec 2014 13:10:01 +0100
Message-ID: <CAKfTPtDWd=hC4e25bmGW-C8HRuQzxx=e+1rqLZbmUqmcgbCBaA@mail.gmail.com>
Subject: Re: [PATCH] sched/fair: fix select_task_rq_fair return -1
To: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Zhang, Jun" <jun.zhang@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 December 2014 at 12:10, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
>>
>> The change below  will give a similar behavior than 3.18 for 3.14 and
>> we still match the condition if (new_cpu == -1 || new_cpu == cpu) in
>>
> And -1 is no longer needed.

yes indeed

>
>> order to go in the child level
>>
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4151,7 +4151,7 @@ static int
>>  find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>>  {
>>         unsigned long load, min_load = ULONG_MAX;
>> -       int idlest = -1;
>> +       int idlest = this_cpu;
>>         int i;
>>
>>         /* Traverse only the allowed CPUs */
>>
>
