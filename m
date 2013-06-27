Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3F0Sdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:33:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46729 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3F0Sdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:33:52 -0400
Date: Thu, 27 Jun 2013 19:32:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Matt Fleming <matt@console-pimps.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, matt.fleming@intel.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Message-ID: <20130627183222.GE4283@n2100.arm.linux.org.uk>
References: <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com> <20130626135311.GA9078@rocoto.smurfnet.nu> <20130626135933.GQ22026@console-pimps.org> <1372257499.2168.5.camel@dabdike> <20130627013219.GA346@srcf.ucam.org> <CACxGe6uFkbuJ3BxM=A0Lu=jZQ79Ba8SmNsdBdTOO13szTfTZ=Q@mail.gmail.com> <1372314821.557.33.camel@dabdike> <CACxGe6uyMjT8HGb16+eqgCwZEDOuC6nkORvej2uGra3oCnyLwg@mail.gmail.com> <1372345486.2522.23.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372345486.2522.23.camel@dabdike>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 08:04:46AM -0700, James Bottomley wrote:
> That's what the x86_64 proposal from Borislav Petkov does.  We alter the
> page tables before calling into the UEFI hooks to make sure both the
> physical and virtual addresses work.  Your problem on ARM with this
> approach is that you're a VI platform, not a PI platform like intel, so

Let me correct that.  Historically, ARM has had virtual indexed caches,
and some of its caches still are (eg, the instruction cache).  Some
data caches might still be technically indexed by virtual address but
as the virtual index uses the address bits below the page size, it's
equivalent to a physically indexed cache.

>From ARMv7, practially all data caches now do not suffer from aliasing
with themselves.  We do still suffer from data <-> instruction, and
cache <-> dma incoherence though.
