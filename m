Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab3E1HaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:30:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:58896 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927Ab3E1H37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:29:59 -0400
Message-ID: <1369726185.3557.74.camel@pasglop>
Subject: Re: [PATCH] powerpc/pseries: Force 32 bit MSIs when tearing down
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 17:29:45 +1000
In-Reply-To: <20130528072021.GA10576@dhcp-26-207.brq.redhat.com>
References: <20130527162027.GA18182@dhcp-26-207.brq.redhat.com>
	 <1369691531.3557.36.camel@pasglop>
	 <20130528072021.GA10576@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 09:20 +0200, Alexander Gordeev wrote:
> On Tue, May 28, 2013 at 07:52:11AM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2013-05-27 at 18:20 +0200, Alexander Gordeev wrote:
> > > This fix just adds a missed call to a new PAPR function
> > > which should have been done with commit e61133d ("powerpc/
> > > pseries: Force 32 bit MSIs for devices that require it")
> > 
> > Arguably, PAPR should allow to disable MSIs using either interface,
> > we shouldn't have to know whether the MSI was a forced-32-bit one to be
> > able to disable it.
> 
> BTW, it is not clear why MSIs do not get disabled on powernv on teardown.
> Would this (pseudo-code) make sense?

Because we don't really have anything to do there. The MSI is just a normal
interrupt source in the PHB, so the "normal" disable_irq (part of free_irq)
will take care of masking it, and from there it's just returning it to the pool
of available interrupts (the bitmap) and removing the mapping.

Cheers,
Ben.


