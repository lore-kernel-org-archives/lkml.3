Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaJTJDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:03:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:36118 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaJTJD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:03:28 -0400
Message-ID: <1413795794.19914.20.camel@tkhai>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Date: Mon, 20 Oct 2014 13:03:14 +0400
In-Reply-To: <20141019194314.GA3434@redhat.com>
References: <1413376300.24793.55.camel@tkhai>
	 <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru>
	 <20141018205614.GA15934@redhat.com> <33631413674011@web7o.yandex.ru>
	 <20141019192437.GA842@redhat.com> <20141019193744.GA3097@redhat.com>
	 <20141019194314.GA3434@redhat.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вс, 19/10/2014 в 21:43 +0200, Oleg Nesterov пишет:
> On 10/19, Oleg Nesterov wrote:
> >
> > Forgot to mention... Or we can make task_struct_cachep SLAB_DESTROY_BY_RCU,
> > in this case ->curr (or any other "task_struct *" ponter) can not go away
> > under rcu_read_lock(). task_numa_compare() still needs the PF_EXITING check,
> > but we do not need to recheck ->curr or probe_kernel_read().
> 
> Damn, please ignore ;) we still need to recheck ->curr.

Yeah, this bug like "collect puzzle" :)


