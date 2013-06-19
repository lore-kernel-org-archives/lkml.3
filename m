Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851Ab3FSPw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:52:26 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56465 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSPwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:52:24 -0400
Date: Wed, 19 Jun 2013 08:52:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker'
 before main looping,  since it can "WARN_ON(worker->task)".
Message-ID: <20130619155218.GA14881@htj.dyndns.org>
References: <51C12D9A.8030801@asianux.com>
 <20130619084124.GF30681@mtj.dyndns.org>
 <51C18540.5060200@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C18540.5060200@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 06:17:36PM +0800, Chen Gang wrote:
> Hmm... can 'worker->task' has chance to be not NULL before set 'current'
> to it ?

Yes, if the caller screws up and try to attach more than one workers
to the kthread_worker, which has some possibility of happening as
kthread_worker allows both attaching and detaching a worker.

> why do we use WARN_ON(worker->task) ?

To detect bugs on the caller side.

> I guess it still has chance to let "worker->task != NULL", or it should
> be BUG_ON(worker->task) instead of.

What difference does that make?

-- 
tejun
