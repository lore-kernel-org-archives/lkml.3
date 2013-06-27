Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3F0Phi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:37:38 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44942 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3F0Phg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <1372345790.2522.26.camel@dabdike>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <20130626135311.GA9078@rocoto.smurfnet.nu> <20130626135933.GQ22026@console-pimps.org>
 <1372257499.2168.5.camel@dabdike> <20130627013219.GA346@srcf.ucam.org>
 <CACxGe6uFkbuJ3BxM=A0Lu=jZQ79Ba8SmNsdBdTOO13szTfTZ=Q@mail.gmail.com>
 <1372314821.557.33.camel@dabdike> <20130627143714.GA12900@srcf.ucam.org> <1372345790.2522.26.camel@dabdike>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 27 Jun 2013 16:37:16 +0100
X-Google-Sender-Auth: wzrRLE9gb3Dh8id5lVaPKp9-19I
Message-ID: <CACxGe6u2xU=+MzYLUbDLFB-9kA23TT2=otzM59zrbGWYt8x7Uw@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 4:09 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2013-06-27 at 15:37 +0100, Matthew Garrett wrote:
>> On Wed, Jun 26, 2013 at 11:33:41PM -0700, James Bottomley wrote:
>> > On Thu, 2013-06-27 at 07:23 +0100, Grant Likely wrote:
>> > > What is the problem trying to be avoided by not using the virtual map?
>> > > Is it passing the virtual mapping data from one kernel to the next
>> > > when kexecing? Or something else?
>> >
>> > Where to begin ... SetVirtualAddressMap() is one massive hack job ...
>> > just look at the tiano core implementation.   Basically it has a fixed
>> > idea of where all the pointers are and it tries to convert them all to
>> > the new address space.  The problem we see in x86 is that this
>> > conversion process isn't exhaustive due to implementation cockups, so
>> > the post virtual address map image occasionally tries to access
>> > unconverted pointers via the old physical address and oopses the kernel.
>>
>> And yet it's the only mode in which the firmrware is actually tested
>> against an OS, so we don't have any real choice in the matter.
>
> Agree for x86 ... we just have to cope with the implementations we see
> in the field.  However, ARM has much more scope to have the UEFI
> implementation developed collaboratively with Linux as the reference
> platform.  If we can convince the ARM implementors that
> SetVirtualAddressMap is an accident waiting to happen, they might be
> more flexible.

We may not have any success convincing them of that; but given the
larger scope for Linux on ARM UEFI implementations, it will actually
get tested. If Linux chooses to use a 1:1 mapping, then the hardware
vendors will make sure a 1:1 mapping will actually work.

I must say that I'm a whole lot more comfortable with this approach.
I've never been comfortable with calling out to UEFI functions while
leaving the entirety of kernel space accessable. Sure UEFI can still
do nasty things if it really wants to and important devices get
mapped, but at least it will protect against accidental accesses.

g.
