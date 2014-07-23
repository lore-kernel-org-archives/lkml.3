Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaGWLiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:38:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaGWLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:38:44 -0400
Date: Wed, 23 Jul 2014 13:38:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] ACPI / PM: Make ACPI-based PCI wakeup work for the
 "freeze" sleep state
Message-ID: <20140723113840.GJ20603@laptop.programming.kicks-ass.net>
References: <1907495.agrCMfRsQN@vostro.rjw.lan>
 <3271848.fNJ1rk2xTa@vostro.rjw.lan>
 <20140723072850.GO3935@laptop>
 <1938033.aGLPbNTjeQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1938033.aGLPbNTjeQ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:43:59PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 23, 2014 09:28:50 AM Peter Zijlstra wrote:
> > On Wed, Jul 23, 2014 at 12:26:20AM +0200, Rafael J. Wysocki wrote:
> > > All of that indicates that the machine in question has WoL based on native PCIe
> > > PME signaling.  In that case it doesn't wake up from the "freeze" state, because
> > > some code is missing.
> > 
> > Didn't wake, but it did show:
> > 
> > 0000:00:01.0:pcie01     1               1               0               0               0               0               0               99207           0
> > LNXPWRBN:00             1               1               0               0               0               0               0               99191           0
> > 
> > So at least something's moving, although its not quite working yet.
> 
> That may be because I forgot about one piece, sorry about that.
> This patch:
> 
> https://patchwork.kernel.org/patch/4526561/
> 
> (which I think is in tip already) is needed to make enable_irq_wake()
> work with the "freeze" state.
> 
> Can you please apply this in addition and retest?

I appear to have that hunk already (I'm running -tip based kernels).

(also, patchwork blows chunks :/)
