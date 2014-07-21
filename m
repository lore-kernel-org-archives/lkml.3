Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaGUIRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:17:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:54056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaGUIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:17:38 -0400
Date: Mon, 21 Jul 2014 10:17:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Update 2x][PATCH 1/2] ACPI / PM: Always enable wakeup GPEs when
 enabling device wakeup
Message-ID: <20140721081734.GL3935@laptop>
References: <1907495.agrCMfRsQN@vostro.rjw.lan>
 <1617640.X0G82q0eFI@vostro.rjw.lan>
 <7670400.0LUVFHKPfm@vostro.rjw.lan>
 <5962983.s3jy9r09Hm@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5962983.s3jy9r09Hm@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 01:51:46AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / PM: Always enable wakeup GPEs when enabling device wakeup
> 
> Wakeup GPEs are currently only enabled when setting up devices for
> remote wakeup at run time.  During system-wide transitions they are
> enabled by ACPICA at the very last stage of suspend (before asking
> the BIOS to take over).  Of course, that only works for system
> sleep states supported by ACPI, so in particular it doesn't work
> for the "freeze" sleep state.
> 
> For this reason, modify the ACPI core device PM code to enable wakeup
> GPEs for devices when setting them up for wakeup regardless of whether
> that is remote wakeup at runtime or system wakeup.  That allows the
> same device wakeup setup routine to be used for both runtime PM and
> system-wide PM and makes it possible to reduce code size quite a bit.
> 
> That should make things like ACPI-based PCI Wake-on-LAN work with
> the "freeze" sleep state among other things.
> 
> Tested-on: Toshiba Portege R500
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> The PCI ACPI device PM notify handler has to be updated to avoid running
> runtime resume callbacks during system suspend too.

So I tested the first version, with that my WSM-EP didn't resume on WoL
and pressing the power button after the WoL had it crash and burn in the
igb driver.

Today I tested this latest version and WoL still didn't trigger a
resume, but the power button did make it go again, no crashes and I
suppose I can confirm the earlier patch that stopped making it go halt
works.

When I 'halt' I can wake the machine back up using a WoL so that all
_should_ work afaik.
