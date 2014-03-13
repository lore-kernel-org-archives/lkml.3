Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaCMIRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:17:10 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:50715 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaCMIRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <1394463171.2270.54.camel@shinybook.infradead.org>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20110101151545.GC25924@n2100.arm.linux.org.uk>
	<1394459790.2270.39.camel@shinybook.infradead.org>
	<20140310143247.GZ21483@n2100.arm.linux.org.uk>
	<1394463171.2270.54.camel@shinybook.infradead.org>
Date: Thu, 13 Mar 2014 09:17:04 +0100
Message-ID: <CACRpkdZrRYY0U5zDwoKRarAH=W6UmxGKX_gWR6nYPM64t6Dzpg@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.walleij@linaro.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, yuanyabin1978@sina.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to understand this, bear with me if I'm thinking sidewise...

On Mon, Mar 10, 2014 at 3:52 PM, David Woodhouse <dwmw2@infradead.org> wrote:

> Actually, if it's really true that the *kernel* is supposed to tell the
> DMA controller which source-id to use for a given channel, instead of it
> being programmed in advance by the BIOS, then ACPI doesn't solve that
> for us in this case either.

So what exactly is a source-id in this case? I'm thinking something
like a logical signal number, like 0x18 is a certain PCM device or
something. That is usually just the number of a rail routed in silicon from
the DMAC to the peripheral in question and doesn't have much to do
with how memory is mapped and data transferred in bursts or single
requests.

> The whole thing seems to be designed such
> that the DMA just *does* appear to come from the slave, not the DMA
> controller.

This sounds like the tag on the bus is set such that the transactions get
some number (maybe the above source-id) transmitted on a few bits
depending on bus arbitration protocol, during transactions making it
appear as if that device is driving the transaction.

Again as Russell stated that doesn't necessarily influence any memory
coherency or the physical address pointer written into the DMAC
hardware at all, does it? The transfers can still happen between the
peripheral and DMAC, and the IOMMU can still be sitting in the middle
of things, in front of the DMAC not the device, needing to be flushed etc.

Sorry if I don't get it... maybe this is one of these funny Intel things
I cannot wrap my head around properly.

Yours,
Linus Walleij
