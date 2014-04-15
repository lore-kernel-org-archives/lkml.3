Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaDOON0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:13:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:51854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaDOONY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,864,1389772800"; 
   d="scan'208";a="493519313"
Date: Tue, 15 Apr 2014 22:12:06 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y
 for X86_64
Message-ID: <20140415141206.GA12076@feng-snb>
References: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
 <20140328071716.GC30107@gmail.com>
 <20140328073718.GA12762@feng-snb>
 <53352DE5.2090600@ladisch.de>
 <20140328081117.GA32308@gmail.com>
 <20140415074443.GA10911@feng-snb>
 <20140415090025.GA31244@gmail.com>
 <20140415095539.GA19271@feng-snb>
 <20140415104206.GA31656@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415104206.GA31656@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:42:06PM +0200, Ingo Molnar wrote:
> 
> * Feng Tang <feng.tang@intel.com> wrote:
> 
> > On Tue, Apr 15, 2014 at 11:00:25AM +0200, Ingo Molnar wrote:
> > > 
> > > * Feng Tang <feng.tang@intel.com> wrote:
> > > 
> > > > Hi Ingo,
> > > > 
> > > > On Fri, Mar 28, 2014 at 09:11:17AM +0100, Ingo Molnar wrote:
> > > > > 
> > > > > * Clemens Ladisch <clemens@ladisch.de> wrote:
> > > > > 
> > > > > > Feng Tang wrote:
> > > > > > > On Fri, Mar 28, 2014 at 08:17:16AM +0100, Ingo Molnar wrote:
> > > > > > >> * Feng Tang <feng.tang@intel.com> wrote:
> > > > > > >>  - or the kernel should have a quirk to reliably disable it. Why
> > > > > > >>    should we crash or misbehave if a driver is built into the
> > > > > > >>    kernel?
> > > > > > >
> > > > > > > I thought about this before, HPET doesn't have PCI ID like stuff,
> > > > > > 
> > > > > > HPET does have the PCI vendor ID in the first register.
> > > > > > 
> > > > > > > only thing I can think of to identify them may be the CPU family/ID.
> > > > > > 
> > > > > > The HPET is implemented by some actual chip, and that chip also has lots
> > > > > > of PCI devices.  (In the case of a SoC, the CPU ID would work, too).
> > > > > 
> > > > > Correct. See arch/x86/kernel/hpet.c, which has a large number of HPET 
> > > > > quirks keyed off chipset PCI IDs:
> > > > > 
> > > > >   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
> > > > >                            ich_force_enable_hpet);
> > > > >   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,
> > > > >                            ich_force_enable_hpet);
> > > > >   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
> > > > >                            ich_force_enable_hpet);
> > > > >   [...]
> > > > 
> > > > I just gave it another thought, that the HPET on our platform 
> > > > currently do have some problem to be used as clocksource/clockevent, 
> > > > but it may get fixed in future version (by Silicon or BIOS).
> > > > 
> > > > If I add quirk to block it now, I may revert this code in future 
> > > > when it get fixed, same problem applis for the future generation of 
> > > > platform.
> > > 
> > > If the hardware or BIOS gets fixed then that will be visible in the 
> > > revision level of the hardware, right?
> > 
> > AFAIK, if it is fixed in a new silicon version, we should be able to 
> > detect it by the "stepping", but the PCI DEV ID is not likely to 
> > change.
> > 
> > If it is fixed by BIOS or PUNIT FW, then we may go through the DMI 
> > info to check the BIOS version, One problem is there is some 
> > Baytrail tablet platforms that doesn't provide DMI info as its FW is 
> > not UEFI/Legacy BIOS compatible version.
> 
> So just turn it off for the current hardware, via PCI ID. When you get 
> a fix, you can turn it back on again by refining the quirk check, for 
> that specific hardware.

got it, thanks!

- Feng

