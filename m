Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaKDMzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:55:32 -0500
Received: from mail113-251.mail.alibaba.com ([205.204.113.251]:34547 "EHLO
	us-alimail-mta1.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753153AbaKDMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:55:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r46d02010;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=8;RT=8;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Vincent Guittot'" <vincent.guittot@linaro.org>
Cc: "'Wanpeng Li'" <kernellwp@gmail.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Preeti U Murthy'" <preeti@linux.vnet.ibm.com>,
        "'Morten Rasmussen'" <Morten.Rasmussen@arm.com>,
        "'Kamalesh Babulal'" <kamalesh@linux.vnet.ibm.com>
References: <011001cff827$f14b9870$d3e2c950$@alibaba-inc.com> <CAKfTPtD6TZ4iHv9wtg-KCkGZriU79ySSxEV3nao2qQacveKAxA@mail.gmail.com>
In-Reply-To: <CAKfTPtD6TZ4iHv9wtg-KCkGZriU79ySSxEV3nao2qQacveKAxA@mail.gmail.com>
Subject: RE: [PATCH v8 03/10] sched: move cfs task on a CPU with higher capacity
Date: Tue, 04 Nov 2014 20:54:29 +0800
Message-ID: <011801cff82e$78cd2c90$6a6785b0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIA8HtVxJmKoorqFpZD8DtHhnWE3gJX3gDYm9u7zSA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On 4 November 2014 13:07, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
> >> >>   +     /*
> >> >> +        * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
> >> >
> >> >
> >> > Why specify one task instead of not less than one?
> >>
> >> if cfs.h_nr_running = 0 (which should not occurs at that point), we
> >> don't need to do more test to check if it's worth moving the task
> >> because there is no task to move.
> >>
> > I wonder if you can please shed light on the case that
> > the dst_cpu is newly idle.
> 
> The main problem if we do the test only for newly idle case, is that
> we are not sure to move the task because we must rely on the
> wakeup/sleep sequence of other tasks on an idle CPU in order to trig
> the migration (periodic background task as an example). So we might
> never move the task whereas idle CPUs are available
> 
So no task is migrated in the newly idle case, if I understand the
above correctly.

Hillf

