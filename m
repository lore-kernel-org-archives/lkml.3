Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaJPWJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 18:09:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaJPWJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 18:09:15 -0400
Date: Fri, 17 Oct 2014 00:05:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix
	use after free
Message-ID: <20141016220540.GA29796@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141015150641.GA2755@redhat.com> <20141016080106.GD7369@worktop.fdxtended.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016080106.GD7369@worktop.fdxtended.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Peter Zijlstra wrote:
>
> On Wed, Oct 15, 2014 at 05:06:41PM +0200, Oleg Nesterov wrote:
> >
> > At least the code like
> >
> > 	rcu_read_lock();
> > 	get_task_struct(foreign_rq->curr);
> > 	rcu_read_unlock();
> >
> > is certainly wrong. And _probably_ the problem should be fixed here. Perhaps
> > we can add try_to_get_task_struct() which does atomic_inc_not_zero() ...
>
> There is an rcu_read_lock() around it through task_numa_compare().

Yes, and the code above has rcu_read_lock() too. But it doesn't help
as Kirill pointed out.

Sorry, didn't have time today to read other emails in this thread,
will do tomorrow and (probably) send the patch which adds PF_EXITING
check.

Oleg.

