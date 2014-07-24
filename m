Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbaGXOP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:15:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:42505 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886AbaGXOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:15:27 -0400
Date: Thu, 24 Jul 2014 16:15:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: Warn when shared interrupts do not match on
 NO_SUSPEND
Message-ID: <20140724141525.GK3935@laptop>
References: <20140724133921.GY6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1407241544500.23352@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407241544500.23352@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 03:46:38PM +0200, Thomas Gleixner wrote:
> On Thu, 24 Jul 2014, Peter Zijlstra wrote:
> 
> > Subject: irq: Warn when shared interrupts do not match on NO_SUSPEND
> > 
> > When suspend_device_irqs() iterates all descriptors, its pointless if
> > one has NO_SUSPEND set while another has not.
> > 
> > Validate on request_irq() that NO_SUSPEND state maches for SHARED
> > interrupts.
> 
> I'm happy to take that patch, but you are aware that it is going to
> break a few things?
> 
>   25:  ....   PCI-MSI-edge      aerdrv, PCIe PME

Better an obvious splat than non obvious misbehaviour in my book.
