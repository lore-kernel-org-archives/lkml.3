Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3FNOgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:36:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FNOge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:36:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
Date: Fri, 14 Jun 2013 16:36:29 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        "Linux-Arch" <linux-arch@vger.kernel.org>
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com> <201306121706.39368.arnd@arndb.de> <1371157181.2261.8.camel@dabdike>
In-Reply-To: <1371157181.2261.8.camel@dabdike>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306141636.29390.arnd@arndb.de>
X-Provags-ID: V02:K0:lGBAuhgLu2duj6y0Ghu/YtH/0zt4aBjLr6H5JjV/VCW
 J3EPVqrG3U5TVkuQPp4dZZ+ABXBjYv2a5Oo7FFQsHwGe0TlHh3
 qfnJtynfXOYVh9bMm8bZ0Jik1i26lXCMRLtz8IulNKPP3vHw+D
 baDk6oaUVl6gdzSTXqxDY7K/wNj+108RK4Mm2UTsZyL5uHs3Hr
 32Is1WlfzTKLKK+AinHpuTc9ksKBuURCPartij7AJN5l228H9K
 fHYmJ0F4FMghpaxGWwTbWBhYVVOz/cTA+RzeXneOS63ozU+rtz
 OqqLkfK8fgs5IeqY7j0/MxA5GNbzn7gVPqHsiKN2HLfPWtcTjU
 xAur9TPXFlJGzdqwe6ag=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 June 2013, James Bottomley wrote:
> On Wed, 2013-06-12 at 17:06 +0200, Arnd Bergmann wrote:
> > On Tuesday 11 June 2013, James Bottomley wrote:
> > > Really, no, it's not a good idea at all.  It invites tons of patches
> > > littering the code with BUG_ONs where we might possibly get a NULL
> > > dereference.  All it does is add extra instructions to a code path for
> > > no actual benefit.
> > > 
> > > If you can answer the question: what more information does the BUG_ON
> > > give you than the NULL deref Oops would not? then it might be
> > > reasonable.
> > 
> > The question is if a user can trigger the NULL dereference intentionally,
> > in which case they might get the kernel to jump into a  user-provided
> > buffer.
> 
> Can you elaborate on how they could do this?  If you're thinking they
> could alter the pointer and trigger the jump, then yes, but a BUG_ON
> won't prevent that because the altered pointer won't be NULL.

The attack that has been demonstrated a couple of times uses an anomymous
mmap to virtual address 0. You fill that page with pointers to a
function in your program. If there is a NULL pointer to some operations
structure and kernel code calls an operation without checking the
ops pointer first, it gets read from the NULL page and the kernel
jumps into user space.

	Arnd
