Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaKJQDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:03:24 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaKJQDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:03:23 -0500
Date: Mon, 10 Nov 2014 17:03:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141110160320.GA10501@worktop.programming.kicks-ass.net>
References: <1413962231.19914.130.camel@tkhai>
 <545D928B.2070508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545D928B.2070508@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:48:27PM -0500, Sasha Levin wrote:
> [  829.539183] BUG: spinlock recursion on CPU#10, trinity-c594/11067
> [  829.539203]  lock: 0xffff880631dd6b80, .magic: dead4ead, .owner: trinity-c594/11067, .owner_cpu: 13

Ooh, look at that. CPU#10 vs .owner_cpu: 13 on the _same_ task.

One of those again :/
