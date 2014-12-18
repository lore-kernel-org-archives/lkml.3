Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaLRXMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:12:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:60580 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaLRXMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:12:00 -0500
Date: Fri, 19 Dec 2014 00:11:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: fix symbol export for __irq_set_affinity
In-Reply-To: <20141218144836.0000091d@unknown>
Message-ID: <alpine.DEB.2.11.1412190004530.17382@nanos>
References: <20141218223031.23847.86103.stgit@jbrandeb-cp2.jf.intel.com> <alpine.DEB.2.11.1412182340300.17382@nanos> <20141218144836.0000091d@unknown>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Jesse Brandeburg wrote:
> On Thu, 18 Dec 2014 23:42:03 +0100
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 18 Dec 2014, Jesse Brandeburg wrote:
> > > Enabling this function means that kernel drivers can include
> > > an initial affinity setting for the interrupt, instead of all
> > > interrupts starting out life on CPU0.  It seems to have just
> > > been an oversight that it was not included.
> 
> > And why needs this to be called from modules? Just because or is there
> > a legitimate reason? IOW, you forgot to describe the actual usecase.
> 
> As stated above, the use case for my interest is making a network
> driver's many interrupt vectors not all show up on CPU0.  Of course a
> user can work around this by manually tuning smp_affinity, but I have
> seen many reports from users and testers where the performance of the
> network was really bad due to all network interrupts on CPU0.
> 
> This allows the driver to set a sane default smp_affinity value at
> driver load.

Fair enough. Overloaded brain missed parts of the explanation. :)
 
> Would you instead consider a patch where if a user calls the
> set_irq_affinity_hint that the initial affinity is set to the hinted
> value?

That would make a lot of sense, because you probably will set the
affinity hint anyway, right?

Thanks,

	tglx



 
