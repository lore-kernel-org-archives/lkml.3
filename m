Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaBOJum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 04:50:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33225 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaBOJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 04:50:39 -0500
Date: Sat, 15 Feb 2014 10:50:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, linux-mmc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] genirq: Provide irq_wake_thread()
Message-ID: <20140215095028.GH14089@laptop.programming.kicks-ass.net>
References: <20140215002742.507053194@linutronix.de>
 <20140215003823.772565780@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215003823.772565780@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 12:55:19AM -0000, Thomas Gleixner wrote:
> In course of the sdhci/sdio discussion with Russell about killing the
> sdio kthread hackery we discovered the need to be able to wake an
> interrupt thread from software.
> 
> The rationale for this is, that sdio hardware can lack proper
> interrupt support for certain features. So the driver needs to poll
> the status registers, but at the same time it needs to be woken up by
> an hardware interrupt.
> 
> To be able to get rid of the home brewn kthread construct of sdio we
> need a way to wake an irq thread independent of an actual hardware
> interrupt.
> 
> Provide an irq_wake_thread() function which wakes up the thread which
> is associated to a given dev_id. This allows sdio to invoke the irq
> thread from the hardware irq handler via the IRQ_WAKE_THREAD return
> value and provides a possibility to wake it via a timer for the
> polling scenarios. That allows to simplify the sdio logic
> significantly.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Peter Zijlstra <peterz@infradead.org>
