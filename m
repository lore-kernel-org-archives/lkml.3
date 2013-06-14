Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3FNQOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:14:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34233 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab3FNQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:14:46 -0400
Message-ID: <1371226483.2726.19.camel@dabdike>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        Linux-Arch <linux-arch@vger.kernel.org>
Date: Fri, 14 Jun 2013 09:14:43 -0700
In-Reply-To: <201306141636.29390.arnd@arndb.de>
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
	 <201306121706.39368.arnd@arndb.de> <1371157181.2261.8.camel@dabdike>
	 <201306141636.29390.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 16:36 +0200, Arnd Bergmann wrote:
> On Thursday 13 June 2013, James Bottomley wrote:
> > On Wed, 2013-06-12 at 17:06 +0200, Arnd Bergmann wrote:
> > > On Tuesday 11 June 2013, James Bottomley wrote:
> > > > Really, no, it's not a good idea at all.  It invites tons of patches
> > > > littering the code with BUG_ONs where we might possibly get a NULL
> > > > dereference.  All it does is add extra instructions to a code path for
> > > > no actual benefit.
> > > > 
> > > > If you can answer the question: what more information does the BUG_ON
> > > > give you than the NULL deref Oops would not? then it might be
> > > > reasonable.
> > > 
> > > The question is if a user can trigger the NULL dereference intentionally,
> > > in which case they might get the kernel to jump into a  user-provided
> > > buffer.
> > 
> > Can you elaborate on how they could do this?  If you're thinking they
> > could alter the pointer and trigger the jump, then yes, but a BUG_ON
> > won't prevent that because the altered pointer won't be NULL.
> 
> The attack that has been demonstrated a couple of times uses an anomymous
> mmap to virtual address 0. You fill that page with pointers to a
> function in your program. If there is a NULL pointer to some operations
> structure and kernel code calls an operation without checking the
> ops pointer first, it gets read from the NULL page and the kernel
> jumps into user space.

This is the MMAP_PAGE_ZERO exploit.  The original exploit relied on a
leaky personality capability clearing mask and was fixed in 2.6.31 by

commit f9fabcb58a6d26d6efde842d1703ac7cfa9427b6
Author: Julien Tinnes <jt@cr0.org>
Date:   Fri Jun 26 20:27:40 2009 +0200

    personality: fix PER_CLEAR_ON_SETID

So it's not really relevant to 3.x kernels, is it?

James


