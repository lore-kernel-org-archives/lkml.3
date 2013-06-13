Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab3FMU7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:59:45 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60261 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757738Ab3FMU7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:59:43 -0400
Message-ID: <1371157181.2261.8.camel@dabdike>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        Linux-Arch <linux-arch@vger.kernel.org>
Date: Thu, 13 Jun 2013 13:59:41 -0700
In-Reply-To: <201306121706.39368.arnd@arndb.de>
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
	 <51B703D7.8050804@samsung.com> <1370958858.2286.5.camel@dabdike>
	 <201306121706.39368.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 17:06 +0200, Arnd Bergmann wrote:
> On Tuesday 11 June 2013, James Bottomley wrote:
> > Really, no, it's not a good idea at all.  It invites tons of patches
> > littering the code with BUG_ONs where we might possibly get a NULL
> > dereference.  All it does is add extra instructions to a code path for
> > no actual benefit.
> > 
> > If you can answer the question: what more information does the BUG_ON
> > give you than the NULL deref Oops would not? then it might be
> > reasonable.
> 
> The question is if a user can trigger the NULL dereference intentionally,
> in which case they might get the kernel to jump into a  user-provided
> buffer.

Can you elaborate on how they could do this?  If you're thinking they
could alter the pointer and trigger the jump, then yes, but a BUG_ON
won't prevent that because the altered pointer won't be NULL.

James



