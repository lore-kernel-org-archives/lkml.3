Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588Ab3FSKS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:18:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17117 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934254Ab3FSKS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:18:27 -0400
X-Spam-Score: -100.8
Message-ID: <51C18540.5060200@asianux.com>
Date: Wed, 19 Jun 2013 18:17:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker' before
 main looping,  since it can "WARN_ON(worker->task)".
References: <51C12D9A.8030801@asianux.com> <20130619084124.GF30681@mtj.dyndns.org>
In-Reply-To: <20130619084124.GF30681@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 04:41 PM, Tejun Heo wrote:
> On Wed, Jun 19, 2013 at 12:03:38PM +0800, Chen Gang wrote:
>> > 
>> > Since "WARN_ON(worker->task)", we can not assume that 'worker->task'
>> > will be NULL before set 'current' to it.
>> > 
>> > So need let 'worker' lock protected too, just like it already lock
>> > protected all time in main looping.
> That synchronization is the kthread_worker user's responsibility.  The
> locking around worker->task = NULL is to prevent the worker task being
> destroyed while insert_kthread_work() is trying to wake it up.  It has
> nothing to do with the user trying to attach multiple tasks to the
> same kthread_worker.  Plus, putting locking around WARN_ON() is
> pointless.  It doesn't really fix anything.  It just makes WARN_ON()
> trigger *slightly* more reliably.

Hmm... can 'worker->task' has chance to be not NULL before set 'current'
to it ?

why do we use WARN_ON(worker->task) ?

I guess it still has chance to let "worker->task != NULL", or it should
be BUG_ON(worker->task) instead of.


Thanks.
-- 
Chen Gang

Asianux Corporation
