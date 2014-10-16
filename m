Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaJPIBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:01:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:50200 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaJPIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:01:20 -0400
Date: Thu, 16 Oct 2014 10:01:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix use
 after free
Message-ID: <20141016080106.GD7369@worktop.fdxtended.com>
References: <1413376300.24793.55.camel@tkhai>
 <20141015150641.GA2755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015150641.GA2755@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 05:06:41PM +0200, Oleg Nesterov wrote:
> 
> At least the code like
> 
> 	rcu_read_lock();
> 	get_task_struct(foreign_rq->curr);
> 	rcu_read_unlock();
> 
> is certainly wrong. And _probably_ the problem should be fixed here. Perhaps
> we can add try_to_get_task_struct() which does atomic_inc_not_zero() ...

There is an rcu_read_lock() around it through task_numa_compare().
