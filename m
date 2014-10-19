Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaJSTqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaJSTqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:46:46 -0400
Date: Sun, 19 Oct 2014 21:43:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141019194314.GA3434@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru> <20141018205614.GA15934@redhat.com> <33631413674011@web7o.yandex.ru> <20141019192437.GA842@redhat.com> <20141019193744.GA3097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019193744.GA3097@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Oleg Nesterov wrote:
>
> Forgot to mention... Or we can make task_struct_cachep SLAB_DESTROY_BY_RCU,
> in this case ->curr (or any other "task_struct *" ponter) can not go away
> under rcu_read_lock(). task_numa_compare() still needs the PF_EXITING check,
> but we do not need to recheck ->curr or probe_kernel_read().

Damn, please ignore ;) we still need to recheck ->curr.

Oleg.

