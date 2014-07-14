Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbaGNRyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:54:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34028 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaGNRyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:54:09 -0400
Message-ID: <53C41943.2000601@arm.com>
Date: Mon, 14 Jul 2014 18:54:11 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED"
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org> <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org> <20140710131646.GB3935@laptop> <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com> <20140711151304.GD3935@laptop> <CAKfTPtCL6mta75k9eoK724wCm7S3w7E+psa1XDrxhN1YVDONPw@mail.gmail.com>
In-Reply-To: <CAKfTPtCL6mta75k9eoK724wCm7S3w7E+psa1XDrxhN1YVDONPw@mail.gmail.com>
X-OriginalArrivalTime: 14 Jul 2014 17:54:05.0425 (UTC) FILETIME=[9A8DB610:01CF9F8C]
X-MC-Unique: 114071418540700501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

>> In that same discussion ISTR a suggestion about adding avg_running time,
>> as opposed to the current avg_runnable. The sum of avg_running should be
>> much more accurate, and still react correctly to migrations.
> 
> I haven't look in details but I agree that avg_running would be much
> more accurate than avg_runnable and should probably fit the
> requirement. Does it means that we could re-add the avg_running (or
> something similar) that has disappeared during the review of load avg
> tracking patchset ?

Are you referring to '[RFC PATCH 14/14] sched: implement usage tracking'
https://lkml.org/lkml/2012/2/1/769 from Paul Turner?

__update_entity_runnable_avg() has an additional parameter 'running' so
that it can be called for

a) sched_entities in update_entity_load_avg():

  __update_entity_runnable_avg(..., se->on_rq, cfs_rq->curr == se))


b) rq's in update_rq_runnable_avg():

  __update_entity_runnable_avg(..., runnable, runnable);

I can see how it gives us two different signals for a sched_entity but
for a rq?

Do I miss something here?

-- Dietmar

[...]

