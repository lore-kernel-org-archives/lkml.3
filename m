Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbaGOJyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:54:05 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:59802 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbaGOJyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:54:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140715093234.GA8700@e103034-lin>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop> <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
 <20140711161344.GD26542@e103034-lin> <CAKfTPtDeTnPVM5nFR19eWRQZMtAZ3B2dB36q4qGNH=URgfLfHw@mail.gmail.com>
 <20140715093234.GA8700@e103034-lin>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 15 Jul 2014 11:53:41 +0200
Message-ID: <CAKfTPtB0K43THAEqaGhdXHcT5d4vLp_DRzi+c7Oiq3XjZQRySA@mail.gmail.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED"
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 July 2014 11:32, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Tue, Jul 15, 2014 at 10:27:19AM +0100, Vincent Guittot wrote:
>> On 11 July 2014 18:13, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
>>
>> [snip]
>>
>> >
>> > In this example using rq->avg leads to imbalance whereas unweighted load
>> > would not. Correct me if I missed anything.
>>
>> You just miss to take into account how the imbalance is computed
>
> I don't think so. I'm aware that the imbalance is calculated based on
> the runnable_load_avg of the cpus. But if you pick the wrong cpus to
> compare to begin with, it doesn't matter.

The average load of your sched_domain is 1 task per CPU so CPU1 will
pull only 1 task and not 2

>
> Morten
