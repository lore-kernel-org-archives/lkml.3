Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3HFIvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:51:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40567 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3HFIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:51:47 -0400
Date: Tue, 6 Aug 2013 09:51:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 51/51] ARM: 7805/1: mm: change max*pfn to include
	the physical offset of memory
Message-ID: <20130806085123.GC23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk> <E1V51J5-0006uq-1h@rmk-PC.arm.linux.org.uk> <CAL_Jsq+9+LBVCwQKKJznbPP06WA0Wn-7m+cFoyF==GRkP9XXmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+9+LBVCwQKKJznbPP06WA0Wn-7m+cFoyF==GRkP9XXmQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:15:11PM -0500, Rob Herring wrote:
> On Thu, Aug 1, 2013 at 5:25 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
> > +/* The ARM override for dma_max_pfn() */
> > +static inline unsigned long dma_max_pfn(struct device *dev)
> > +{
> > +       return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
> 
> Do we need to handle dev == NULL case?

No, look at where it's used and the code it's replacing.  You'll find
that its callsites handle the dev = NULL case.
