Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbaGXOU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:20:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60198 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758886AbaGXOU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:20:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: Warn when shared interrupts do not match on NO_SUSPEND
Date: Thu, 24 Jul 2014 16:39:23 +0200
Message-ID: <3893758.epUfayuv4Z@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140724141525.GK3935@laptop>
References: <20140724133921.GY6758@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1407241544500.23352@nanos> <20140724141525.GK3935@laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 04:15:25 PM Peter Zijlstra wrote:
> On Thu, Jul 24, 2014 at 03:46:38PM +0200, Thomas Gleixner wrote:
> > On Thu, 24 Jul 2014, Peter Zijlstra wrote:
> > 
> > > Subject: irq: Warn when shared interrupts do not match on NO_SUSPEND
> > > 
> > > When suspend_device_irqs() iterates all descriptors, its pointless if
> > > one has NO_SUSPEND set while another has not.
> > > 
> > > Validate on request_irq() that NO_SUSPEND state maches for SHARED
> > > interrupts.
> > 
> > I'm happy to take that patch, but you are aware that it is going to
> > break a few things?
> > 
> >   25:  ....   PCI-MSI-edge      aerdrv, PCIe PME
> 
> Better an obvious splat than non obvious misbehaviour in my book.

And it will only break things that are already broken.

ACK for the patch.

Rafael

