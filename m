Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaGVAoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:44:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53295 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751024AbaGVAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:44:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Update 2x][PATCH 1/2] ACPI / PM: Always enable wakeup GPEs when enabling device wakeup
Date: Tue, 22 Jul 2014 03:02:29 +0200
Message-ID: <30566603.pYsRuTlO6S@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140721081734.GL3935@laptop>
References: <1907495.agrCMfRsQN@vostro.rjw.lan> <5962983.s3jy9r09Hm@vostro.rjw.lan> <20140721081734.GL3935@laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 21, 2014 10:17:34 AM Peter Zijlstra wrote:
> On Mon, Jul 21, 2014 at 01:51:46AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / PM: Always enable wakeup GPEs when enabling device wakeup
> > 
> > Wakeup GPEs are currently only enabled when setting up devices for
> > remote wakeup at run time.  During system-wide transitions they are
> > enabled by ACPICA at the very last stage of suspend (before asking
> > the BIOS to take over).  Of course, that only works for system
> > sleep states supported by ACPI, so in particular it doesn't work
> > for the "freeze" sleep state.
> > 
> > For this reason, modify the ACPI core device PM code to enable wakeup
> > GPEs for devices when setting them up for wakeup regardless of whether
> > that is remote wakeup at runtime or system wakeup.  That allows the
> > same device wakeup setup routine to be used for both runtime PM and
> > system-wide PM and makes it possible to reduce code size quite a bit.
> > 
> > That should make things like ACPI-based PCI Wake-on-LAN work with
> > the "freeze" sleep state among other things.
> > 
> > Tested-on: Toshiba Portege R500
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > The PCI ACPI device PM notify handler has to be updated to avoid running
> > runtime resume callbacks during system suspend too.
> 
> So I tested the first version, with that my WSM-EP didn't resume on WoL
> and pressing the power button after the WoL had it crash and burn in the
> igb driver.
> 
> Today I tested this latest version and WoL still didn't trigger a
> resume, but the power button did make it go again, no crashes and I
> suppose I can confirm the earlier patch that stopped making it go halt
> works.

OK, thanks!

> When I 'halt' I can wake the machine back up using a WoL so that all
> _should_ work afaik.

Yes, it should.

I'll send an updated patchset shortly, so please test that one.  If it
doesn't help, we'll need to dig deeper still.

Rafael

