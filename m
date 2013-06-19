Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346Ab3FSIoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:44:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:53125 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934319Ab3FSInj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:43:39 -0400
Date: Wed, 19 Jun 2013 10:43:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker'
 before main looping, since it can "WARN_ON(worker->task)".
In-Reply-To: <51C12D9A.8030801@asianux.com>
Message-ID: <alpine.DEB.2.02.1306191041570.4013@ionos.tec.linutronix.de>
References: <51C12D9A.8030801@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Chen Gang wrote:

> 
> Since "WARN_ON(worker->task)", we can not assume that 'worker->task'
> will be NULL before set 'current' to it.

It better is NULL and all that WARN_ON does is to verify that.
 
> So need let 'worker' lock protected too, just like it already lock
> protected all time in main looping.

No. That's pointless. This happens when the new worker starts up and
there is nothing which can modify worker->task at this point.
 
Thanks,

	tglx
