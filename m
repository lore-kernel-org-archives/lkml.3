Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaFESBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:01:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaFESBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:01:43 -0400
Date: Thu, 5 Jun 2014 11:05:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, sudeep.holla@arm.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 3.10 005/103] irqchip: Gic: Support forced affinity
 setting
Message-ID: <20140605180524.GC4121@kroah.com>
References: <20140604232546.704156131@linuxfoundation.org>
 <20140604232547.006861681@linuxfoundation.org>
 <20140605160500.GD31564@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605160500.GD31564@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 05:05:00PM +0100, Mark Rutland wrote:
> Hi Greg,
> 
> On Thu, Jun 05, 2014 at 12:24:28AM +0100, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > commit ffde1de64012c406dfdda8690918248b472f24e4 upstream.
> > 
> > To support the affinity setting of per cpu timers in the early startup
> > of a not yet online cpu, implement the force logic, which disables the
> > cpu online check.
> > 
> > Tagged for stable to allow a simple fix of the affected SoC clock
> > event drivers.
> 
> This patch alone has the possiblity of breaking CPU hotplug on arm and
> arm64 (specifically it breaks hot unplugging CPU0 where interrupts may
> be left targetting the offline CPU).
> 
> For arm64 [1] that's fixed by commit 601c942176d8 (arm64: use
> cpu_online_mask when using forced irq_set_affinity).

Thanks, I'll apply that to the 3.14-stable tree, but, it doesn't seem
relevant at all for 3.10-stable as arch/arm64/kernel/irq.c doesn't do
anything with cpumask or set_affinity.  If it's relevant for 3.10,
please provide a backported version.

> Unfortunately there is not an equivalent fix for arm - Russell objected
> to the approach [2,3,4], and that's not yet settled.

Ok, be sure to cc: stable on the patch when it goes into the tree and
I'll pick it up then.

thanks,

greg k-h
