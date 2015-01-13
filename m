Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbbAMUwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:52:13 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37894 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976AbbAMUwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:52:11 -0500
Date: Tue, 13 Jan 2015 21:52:07 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/5] irqchip: Add DT binding doc for dumb demuxer
 chips
Message-ID: <20150113215207.185d92b4@bbrezillon>
In-Reply-To: <20150113190050.GZ24989@titan.lakedaemon.net>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
	<1421174781-4340-3-git-send-email-boris.brezillon@free-electrons.com>
	<20150113190050.GZ24989@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Tue, 13 Jan 2015 14:00:50 -0500
Jason Cooper <jason@lakedaemon.net> wrote:

> Boris,
> 
> On Tue, Jan 13, 2015 at 07:46:18PM +0100, Boris Brezillon wrote:
> > Add documentation for the dumb demuxer.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  .../bindings/interrupt-controller/dumb-demux.txt   | 34 ++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt b/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
> > new file mode 100644
> > index 0000000..1c777ef
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/interrupt-controller/dumb-demux.txt
> > @@ -0,0 +1,34 @@
> > +* Generic Dumb Interrupt Demultiplexer
> > +
> > +This Dumb demultiplixer simply forward all incoming interrupts to its
> > +enabled/unmasked children.
> 
> Please forgive the potentially naïve question, but what hardware is this
> describing?

That's not a real hardware per se, but on some hardware (like at91 SoCs)
some IRQ line are shared by several peripherals, and this dumb
demultiplex is here to represent such shared irq lines which cannot be
easily demultiplexed (because they do not provide a 'cause'
register).

You can see it as a virtual irqchip provided to address broken hardware
designs.

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
