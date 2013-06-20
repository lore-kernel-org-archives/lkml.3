Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935544Ab3FTByG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:54:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:51969 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935237Ab3FTByE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:54:04 -0400
X-Spam-Score: -100.8
Message-ID: <51C26087.9000109@asianux.com>
Date: Thu, 20 Jun 2013 09:53:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker' before
 main looping,  since it can "WARN_ON(worker->task)".
References: <51C12D9A.8030801@asianux.com> <20130619084124.GF30681@mtj.dyndns.org> <51C18540.5060200@asianux.com> <20130619155218.GA14881@htj.dyndns.org>
In-Reply-To: <20130619155218.GA14881@htj.dyndns.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 11:52 PM, Tejun Heo wrote:
> On Wed, Jun 19, 2013 at 06:17:36PM +0800, Chen Gang wrote:
>> > Hmm... can 'worker->task' has chance to be not NULL before set 'current'
>> > to it ?
> Yes, if the caller screws up and try to attach more than one workers
> to the kthread_worker, which has some possibility of happening as
> kthread_worker allows both attaching and detaching a worker.
> 

If we detect the bugs, and still want to use WARN_ON() to report warning
and continue running, we need be sure of keeping the related things no
touch (at least not lead to worse).

If we can not be sure of keeping the related things no touch:
  if it is a kernel bug, better use BUG_ON() instead of,
  if it is a user mode bug, better to return failure with error code and
print related information.

>> > why do we use WARN_ON(worker->task) ?
> To detect bugs on the caller side.
> 

OK, thanks.

>> > I guess it still has chance to let "worker->task != NULL", or it should
>> > be BUG_ON(worker->task) instead of.
> What difference does that make?

BUG_ON() will stop current working flow and report kernel bug in details.


Thanks.
-- 
Chen Gang

Asianux Corporation
