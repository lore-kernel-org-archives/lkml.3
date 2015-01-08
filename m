Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbbAHTSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:18:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:40189 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbbAHTSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:18:07 -0500
Message-ID: <1420744670.5830.44.camel@kernel.crashing.org>
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, Purcareata Bogdan <b43198@freescale.com>,
        linux-kernel@vger.kernel.org, Andreas Mohr <andi@lisas.de>
Date: Thu, 08 Jan 2015 20:17:50 +0100
In-Reply-To: <1420650283.4961.52.camel@freescale.com>
References: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
	 <1420481454.4961.16.camel@freescale.com>
	 <1420641876.5830.32.camel@kernel.crashing.org>
	 <1420650283.4961.52.camel@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 11:04 -0600, Scott Wood wrote:
> On Wed, 2015-01-07 at 15:44 +0100, Benjamin Herrenschmidt wrote:
> > On Mon, 2015-01-05 at 12:10 -0600, Scott Wood wrote:
> > > It would have been nice if a code comment explained why it was doing the
> > > readback...  I don't see any particular need to wait for EOI completion
> > > here (unlike when masking).
> > 
> > The EOI is what causes the MPIC to drop it's EE output to the CPU, if the
> > EOI is processed too slowly & asynchronously (posted write + 33Mhz MPIC)
> > we observe cases of spurrious interrupts. We had some macs basically getting
> > a spurrious irq for every MPIC interrupts...
> 
> Shouldn't reading INTACK be what causes the MPIC to drop its EE output?

Hrm, looks like I had too much wine or something, you are correct yes,
it's the intack, so my explanation is bogus.

So we are down to possibly delaying the raising back of the CPU priority
which is not a big deal indeed, we could probably get rid of the read
back.

Ben.


