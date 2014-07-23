Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaGWL7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:59:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61482 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753350AbaGWL7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:59:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] ACPI / PM: Make ACPI-based PCI wakeup work for the "freeze" sleep state
Date: Wed, 23 Jul 2014 14:17:55 +0200
Message-ID: <6491652.ycQtdn67HU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140723113840.GJ20603@laptop.programming.kicks-ass.net>
References: <1907495.agrCMfRsQN@vostro.rjw.lan> <1938033.aGLPbNTjeQ@vostro.rjw.lan> <20140723113840.GJ20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 01:38:40 PM Peter Zijlstra wrote:
> On Wed, Jul 23, 2014 at 01:43:59PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, July 23, 2014 09:28:50 AM Peter Zijlstra wrote:
> > > On Wed, Jul 23, 2014 at 12:26:20AM +0200, Rafael J. Wysocki wrote:
> > > > All of that indicates that the machine in question has WoL based on native PCIe
> > > > PME signaling.  In that case it doesn't wake up from the "freeze" state, because
> > > > some code is missing.
> > > 
> > > Didn't wake, but it did show:
> > > 
> > > 0000:00:01.0:pcie01     1               1               0               0               0               0               0               99207           0
> > > LNXPWRBN:00             1               1               0               0               0               0               0               99191           0
> > > 
> > > So at least something's moving, although its not quite working yet.
> > 
> > That may be because I forgot about one piece, sorry about that.
> > This patch:
> > 
> > https://patchwork.kernel.org/patch/4526561/
> > 
> > (which I think is in tip already) is needed to make enable_irq_wake()
> > work with the "freeze" state.
> > 
> > Can you please apply this in addition and retest?
> 
> I appear to have that hunk already (I'm running -tip based kernels).

I see.

> (also, patchwork blows chunks :/)

That's never happened to me (and there's only one hunk in that patch).

Anyway, the count for 0000:00:01.0:pcie01 means that the wakeup source
has been activated, so it should have woken it up in theory.

Unless, of course, it was activated after the power button wakeup.

It looks like the stuff works on the hardware level, though, so we should be
able to make the wakeup work too.  I'll have another look later today.

Rafael

