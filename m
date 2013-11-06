Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3KFRtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:49:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:46690 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3KFRtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:49:45 -0500
Date: Wed, 6 Nov 2013 18:49:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
In-Reply-To: <1383228427.5272.36.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
References: <1383228427.5272.36.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013, Mike Galbraith wrote:

> Hi Frederic,
> 
> The tick wakes ksoftirqd, ensuring nr_running test ain't gonna happen
> when an otherwise lonely task takes the timer interrupt.  Deferring to
> softirq processing time..... works.

-ENOPARSE

What the heck is this patch doing aside of slapping #ifdeffery all
over the place?

I bet you are trying to work around some of the side effects of the
occasional tick which is still necessary despite of full nohz, right?

Bah, we want to solve the underlying problems and get rid of the tick
completely instead of hiding the issues by magic hackery.
 
Thanks,

	tglx
