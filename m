Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3ITUWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab3ITUV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:21:56 -0400
Message-ID: <1379708486.12705.131.camel@dhcp-128-237.ams.redhat.com>
Subject: Re: [PATCH] x86 efi: bugfix interrupt disabling sequence
From: Bart Kuivenhoven <bemk@redhat.com>
Reply-To: bemk@redhat.com
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jcm@redhat.com, msalter@redhat.com
Date: Fri, 20 Sep 2013 22:21:26 +0200
In-Reply-To: <20130920152859.GC21381@console-pimps.org>
References: <1379525333-4373-1-git-send-email-bemk@redhat.com>
	 <20130920152859.GC21381@console-pimps.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 16:28 +0100, Matt Fleming wrote:
> On Wed, 18 Sep, at 07:28:53PM, Bart Kuivenhoven wrote:
> > The problem in efi_main was that the idt was cleared before the
> > interrupts were disabled.
> > 
> > The UEFI spec states that interrupts aren't used so this shouldn't be
> > too much of a problem. Peripherals however don't necessarily know about
> > this and thus might cause interrupts to happen anyway. Even if
> > ExitBootServices() has been called.
> >
> > This means there is a risk of an interrupt being triggered while the IDT
> > register is nullified and the interrupt bit hasn't been cleared,
> > allowing for a triple fault.
> 
> Just to be clear, you haven't witnessed a triple fault, correct?
> 
> > This patch fixes this by clearing the interrupt bit before the lidt
> > instruction.
> 
> I think we can go even further than this and get rid of all of the IDT
> code in the EFI boot stub. The kernel maintains its own IDT anyway.
> 

Well, isn't it so, that the kernel expects a setup in which interrupts
are disabled before the decompressed image is loaded?

What we can do is remove the lidt instruction and IDT pointer, but that
still doesn't change anything with regards to the kernels expectations.

And no, I haven't witnessed a triple fault, this is purely theoretical,
with a very slim chance of it actually happening. That does not mean
that it can't happen though.

-- 
Kind regards/Met vriendelijke groet,
Bart Kuivenhoven.

Intern Fedora ARM,
Red Hat.

