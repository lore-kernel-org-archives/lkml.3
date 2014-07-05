Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaGEUgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:36:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:41390 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687AbaGEUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:36:18 -0400
Date: Sat, 5 Jul 2014 22:36:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Blackwood <john.blackwood@ccur.com>
cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Austin Schuh <austin@peloton-tech.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-rt-users@vger.kernel.org
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
In-Reply-To: <537CFECF.9070701@ccur.com>
Message-ID: <alpine.DEB.2.10.1407052233230.22031@nanos>
References: <537CFECF.9070701@ccur.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, John Blackwood wrote:
> I'm not 100% sure that the patch below will fix your problem, but we
> saw something that sounds pretty familiar to your issue involving the
> nvidia driver and the preempt-rt patch.  The nvidia driver uses the
> completion support to create their own driver's notion of an internally
> used semaphore.

And why should we care about that? If they abuse the completion code
then it's their problem. And it has nothing to do at all with the
problem Austin is observing.
 
> Some tasks were failing to ever wakeup from wait_for_completion() calls
> due to a race in the underlying do_wait_for_common() routine.

Why are you not fixing the nvidia crap instead of hacking utter shite
into the core kernel?

Thanks,

	tglx
