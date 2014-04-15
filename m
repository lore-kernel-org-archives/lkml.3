Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaDOJAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:00:34 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53668 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaDOJA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:00:29 -0400
Date: Tue, 15 Apr 2014 11:00:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y
 for X86_64
Message-ID: <20140415090025.GA31244@gmail.com>
References: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
 <20140328071716.GC30107@gmail.com>
 <20140328073718.GA12762@feng-snb>
 <53352DE5.2090600@ladisch.de>
 <20140328081117.GA32308@gmail.com>
 <20140415074443.GA10911@feng-snb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415074443.GA10911@feng-snb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Feng Tang <feng.tang@intel.com> wrote:

> Hi Ingo,
> 
> On Fri, Mar 28, 2014 at 09:11:17AM +0100, Ingo Molnar wrote:
> > 
> > * Clemens Ladisch <clemens@ladisch.de> wrote:
> > 
> > > Feng Tang wrote:
> > > > On Fri, Mar 28, 2014 at 08:17:16AM +0100, Ingo Molnar wrote:
> > > >> * Feng Tang <feng.tang@intel.com> wrote:
> > > >>  - or the kernel should have a quirk to reliably disable it. Why
> > > >>    should we crash or misbehave if a driver is built into the
> > > >>    kernel?
> > > >
> > > > I thought about this before, HPET doesn't have PCI ID like stuff,
> > > 
> > > HPET does have the PCI vendor ID in the first register.
> > > 
> > > > only thing I can think of to identify them may be the CPU family/ID.
> > > 
> > > The HPET is implemented by some actual chip, and that chip also has lots
> > > of PCI devices.  (In the case of a SoC, the CPU ID would work, too).
> > 
> > Correct. See arch/x86/kernel/hpet.c, which has a large number of HPET 
> > quirks keyed off chipset PCI IDs:
> > 
> >   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
> >                            ich_force_enable_hpet);
> >   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,
> >                            ich_force_enable_hpet);
> >   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
> >                            ich_force_enable_hpet);
> >   [...]
> 
> I just gave it another thought, that the HPET on our platform 
> currently do have some problem to be used as clocksource/clockevent, 
> but it may get fixed in future version (by Silicon or BIOS).
> 
> If I add quirk to block it now, I may revert this code in future 
> when it get fixed, same problem applis for the future generation of 
> platform.

If the hardware or BIOS gets fixed then that will be visible in the 
revision level of the hardware, right?

Such kind of revision level, once it is known, can then be used to 
turn the quirk on/off precisely.

Thanks,

	Ingo
