Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaIKXzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:55:03 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:54490 "EHLO
	homiemail-a8.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbaIKXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:55:01 -0400
Message-ID: <1410479618.14217.4.camel@linux-t7sj.site>
Subject: Re: futex_wait_setup sleeping while atomic bug.
From: Davidlohr Bueso <dave@stgolabs.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Darren Hart <darren@dvhart.com>
Date: Thu, 11 Sep 2014 16:53:38 -0700
In-Reply-To: <alpine.DEB.2.10.1409112318500.4178@nanos>
References: <20140911151040.GB3008@redhat.com>
	 <alpine.DEB.2.10.1409112318500.4178@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 23:52 +0200, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 11 Sep 2014 23:44:35 +0200
> Subject: futex: Unlock hb->lock in futex_wait_requeue_pi() error path

That's the second time we are bitten by bugs in when requeing, now pi.
We need to reconsider some of our testing tools to stress these paths
better, imo.

> futex_wait_requeue_pi() calls futex_wait_setup(). If
> futex_wait_setup() succeeds it returns with hb->lock held and
> preemption disabled. Now the sanity check after this does:
> 
>         if (match_futex(&q.key, &key2)) {
> 	   	ret = -EINVAL;
> 		goto out_put_keys;
> 	}
> 
> which releases the keys but does not release hb->lock. So we happily
> return to user space with hb->lock held and therefor preemption
> disabled.
> 
> Unlock hb->lock before taking the exit route.
> 
> Reported-by: Dave "Trinity" Jones <davej@redhat.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>


