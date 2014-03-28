Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaC1ILZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:11:25 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46976 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaC1ILW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:11:22 -0400
Date: Fri, 28 Mar 2014 09:11:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Feng Tang <feng.tang@intel.com>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y
 for X86_64
Message-ID: <20140328081117.GA32308@gmail.com>
References: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
 <20140328071716.GC30107@gmail.com>
 <20140328073718.GA12762@feng-snb>
 <53352DE5.2090600@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53352DE5.2090600@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clemens Ladisch <clemens@ladisch.de> wrote:

> Feng Tang wrote:
> > On Fri, Mar 28, 2014 at 08:17:16AM +0100, Ingo Molnar wrote:
> >> * Feng Tang <feng.tang@intel.com> wrote:
> >>  - or the kernel should have a quirk to reliably disable it. Why
> >>    should we crash or misbehave if a driver is built into the
> >>    kernel?
> >
> > I thought about this before, HPET doesn't have PCI ID like stuff,
> 
> HPET does have the PCI vendor ID in the first register.
> 
> > only thing I can think of to identify them may be the CPU family/ID.
> 
> The HPET is implemented by some actual chip, and that chip also has lots
> of PCI devices.  (In the case of a SoC, the CPU ID would work, too).

Correct. See arch/x86/kernel/hpet.c, which has a large number of HPET 
quirks keyed off chipset PCI IDs:

  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
                           ich_force_enable_hpet);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,
                           ich_force_enable_hpet);
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
                           ich_force_enable_hpet);
  [...]

Thanks,

	Ingo
