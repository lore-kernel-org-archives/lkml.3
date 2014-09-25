Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaIYMLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:11:15 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:42749 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaIYMLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:11:11 -0400
MIME-Version: 1.0
In-Reply-To: <5422B8C7.6090905@linux.vnet.ibm.com>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-7-git-send-email-vincent.guittot@linaro.org> <5422B8C7.6090905@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 25 Sep 2014 14:10:50 +0200
Message-ID: <CAKfTPtCcgzHtNoP3gdsH-AZwoUqp9pUq0EZMsdC0uHYa+w7b4Q@mail.gmail.com>
Subject: Re: [PATCH v6 6/6] sched: add SD_PREFER_SIBLING for SMT level
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2014 14:27, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 09/23/2014 09:38 PM, Vincent Guittot wrote:
>> add the SD_PREFER_SIBLING flag for SMT level in order to ensure that
>> the scheduler will put at least 1 task per core.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/core.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index c7c8ac4..f72663e 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -6134,6 +6134,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
>>        */
>>
>>       if (sd->flags & SD_SHARE_CPUCAPACITY) {
>> +             sd->flags |= SD_PREFER_SIBLING;
>>               sd->imbalance_pct = 110;
>>               sd->smt_gain = 1178; /* ~15% */
>>
> Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>

Thanks

>
