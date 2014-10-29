Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaJ2SZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:25:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaJ2SZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:25:25 -0400
Date: Wed, 29 Oct 2014 20:21:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
Message-ID: <20141029192141.GB16312@redhat.com>
References: <1414405105.19914.169.camel@tkhai> <20141027230427.GA18454@redhat.com> <1414473874.8574.2.camel@tkhai> <20141028225250.GA8519@redhat.com> <54505D10.7050809@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54505D10.7050809@yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Kirill Tkhai wrote:
>
> On 29.10.2014 01:52, Oleg Nesterov wrote:
>
> > And cgroup_task_migrate() can free ->cgroups via call_rcu(). Of course,
> > in practice raw_spin_lock_irq() should also act as rcu_read_lock(), but
> > we should not rely on implementation details.
>
> Do you mean cgroup_task_migrate()->put_css_set_locked()? It's not
> possible there, because old_cset->refcount is lager than 1. We increment
> it in cgroup_migrate_add_src() and real freeing happens in
> cgroup_migrate_finish(). These functions are around task_migrate(), they
> are pair brackets.

Ah, I see.

> If we've got old_cset in
> cgroup_post_fork()->sched_move_task(), the right sched_task_group will
> be installed by attach->sched_move_task().

Yes, yes, this part is clear.

OK, I think the patch is fine then.

Thanks!

Oleg.

