Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaFDLSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:18:52 -0400
Received: from forward1h.mail.yandex.net ([84.201.187.146]:53841 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaFDLSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:18:51 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>, "riel@redhat.com" <riel@redhat.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
In-Reply-To: <20140604104122.GL30445@twins.programming.kicks-ass.net>
References: <20140604104122.GL30445@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched: Fix migration_cpu_stop() return value
MIME-Version: 1.0
Message-Id: <5962011401880725@web26h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 04 Jun 2014 15:18:45 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

04.06.2014, 14:41, "Peter Zijlstra" <peterz@infradead.org>:
> šA while ago I did a similar patch for some debugging, but looking at it
> šagain today I realized we should probably fix this anyway.
>
> š---
> šSubject: sched: Fix migration_cpu_stop() return value
>
> šThere are a number of migration_cpu_stop() users; and some actually care
> šabout the success of the migration. So report this.
>
> šIn particular migrate_task_to() as used from task_numa_migrate()
> šactually tests this return value.
>
> šAlso change set_cpus_allowed_ptr() to propagate this return value, since
> šit already returns other errors.
>
> šCc: Lai Jiangshan <laijs@cn.fujitsu.com>
> šCc: Ingo Molnar <mingo@redhat.com>
> šSigned-off-by: Peter Zijlstra <peterz@infradead.org>
> š---
> šškernel/sched/core.c | šš15 +++++++++++----
> šš1 file changed, 11 insertions(+), 4 deletions(-)
(snipped everything because of bad email editor)

In set_cpus_allowed_ptr() p->on_rq branch can not fail.

We've changed affinity and released rq's lock, so task can migrate
on allowed cpu only (even if migration_cpu_stop fails).

And it's a little ambiguously how user should react on this EAGAIN.

Regards,
Kirill.
