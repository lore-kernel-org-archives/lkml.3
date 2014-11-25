Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaKYCNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 21:13:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaKYCNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 21:13:00 -0500
Message-ID: <1416881559.20575.14.camel@linux-t7sj.site>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
From: Davidlohr Bueso <dave@stgolabs.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, peterz@infradead.org, riel@redhat.com,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Date: Mon, 24 Nov 2014 18:12:39 -0800
In-Reply-To: <alpine.DEB.2.11.1411242317380.6439@nanos>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <alpine.DEB.2.11.1411242317380.6439@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 00:35 +0100, Thomas Gleixner wrote:
> On Mon, 24 Nov 2014, Khalid Aziz wrote:
> > sched/fair: Add advisory flag for borrowing a timeslice
> > 
> > This patch adds a way for a task to request to borrow one timeslice
> > from future if it is about to be preempted, so it could delay
> > preemption and complete any critical task it is in the middle of.
> > 
> > This feature helps with performance on databases and has been
> > used for many years on other OSs by the databases. This feature
> > helps in situation where a task acquires a lock before performing a
> > critical operation on the database and happens to get preempted before
> > it completes its task.  This lock being held causes all other tasks
> > that also acquire the same lock to perform their critical operation
> > on the database, to start queueing up and causing large number of
> > context switches.  This queueing problem can be avoided if the task
> > that acquires lock first could request scheduler to let it borrow one
> > timeslice once it enters its critical section and hence allow it to
> > complete its critical section without causing queueing problem. If
> 
> While you are niftily avoiding to talk about the nature of the lock, I
> can take it for granted that you are talking about user space
> spinlocks, right?

Probably, or perhaps userspace fair locks. If the task that is next in
line to acquire the lock is preempted and the lock is released, fairness
prevents anyone else from taking it instead.

Thanks,
Davidlohr


