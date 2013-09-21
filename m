Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3IUHuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 03:50:09 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59588 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3IUHuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 03:50:07 -0400
Date: Sat, 21 Sep 2013 09:50:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Bart Kuivenhoven <bemk@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, matt.fleming@intel.com,
        hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, msalter@redhat.com
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
Message-ID: <20130921075002.GB7771@gmail.com>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
 <20130920152859.GC21381@console-pimps.org>
 <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bart Kuivenhoven <bemk@redhat.com> wrote:

> On Fri, 2013-09-20 at 16:28 +0100, Matt Fleming wrote:
> > On Wed, 18 Sep, at 07:28:53PM, Bart Kuivenhoven wrote:
> > > The problem in efi_main was that the idt was cleared before the
> > > interrupts were disabled.
> > > 
> > > The UEFI spec states that interrupts aren't used so this shouldn't be
> > > too much of a problem. Peripherals however don't necessarily know about
> > > this and thus might cause interrupts to happen anyway. Even if
> > > ExitBootServices() has been called.
> > >
> > > This means there is a risk of an interrupt being triggered while the IDT
> > > register is nullified and the interrupt bit hasn't been cleared,
> > > allowing for a triple fault.
> > 
> > Just to be clear, you haven't witnessed a triple fault, correct?
> > 
> > > This patch fixes this by clearing the interrupt bit before the lidt
> > > instruction.
> > 
> > I think we can go even further than this and get rid of all of the IDT
> > code in the EFI boot stub. The kernel maintains its own IDT anyway.
> > 
> 
> Well, isn't it so, that the kernel expects a setup in which interrupts 
> are disabled before the decompressed image is loaded?
> 
> What we can do is remove the lidt instruction and IDT pointer, but that 
> still doesn't change anything with regards to the kernels expectations.
> 
> And no, I haven't witnessed a triple fault, this is purely theoretical, 
> with a very slim chance of it actually happening. That does not mean 
> that it can't happen though.

it would also be very hard to prove that it occured (outside of special 
debug environments) - spurious, low probability triple faults are as 
undebuggable as it gets.

Thanks,

	Ingo
