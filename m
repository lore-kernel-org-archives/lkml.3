Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaK0Xjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:39:44 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36456 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbaK0Xjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:39:42 -0500
Date: Fri, 28 Nov 2014 00:39:38 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Message-ID: <20141128003938.7efb4ea0@bbrezillon>
In-Reply-To: <3935244.Dm2HkZj2Bg@wuerfel>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
	<3550407.q87bWB4Jdt@wuerfel>
	<20141127171243.GL4508@piout.net>
	<3935244.Dm2HkZj2Bg@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, 28 Nov 2014 00:12:25 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 27 November 2014 18:12:43 Alexandre Belloni wrote:
> > 
> > As discussed some weeks ago, I prepared patches to switch sama5d[3-4] to
> > multiplatform. We are still missing the SMC and matrix drivers to switch
> > sam9 and rm9200.
> 
> I just looked at the drivers because I got curious, and to see if
> there are still any low-hanging fruit, but I guess you already picked
> them all ;-)
> 
> > The currently affected drivers are:
> >  - drivers/ata/pata_at91.c (SMC)
> >  - drivers/pcmcia/at91_cf.c (SMC)
> 
> I guess the SMC should live in drivers/memory with an interface
> similar to mvebu-devbus.c?

Actually, there's some work in progress to support the EBI/SMC blocks
as a memory controller driver ;-):

http://thread.gmane.org/gmane.linux.kernel/1822096

I'll post a new version soon.

> 
> Seems doable but nontrivial.
> 
> >  - drivers/usb/gadget/udc/at91_udc.c (Matrix, this is the only one
> >    for sam9)
> 
> Is at91_matrix a pin controller? With the board files removed, the udc
> driver has the only two remaining calls to at91_matrix_{read,write}
> for setting the pullup, so that could be modeled as a trivial pinctrl
> driver

The matrix block is containing several system configuration registers.
Most of them are related to AHB/APB bus config (master <-> slave
priority, burst and some other configs I don't remember).
Another register is here to define which HW logic is attached to an
external device connected through the EBI (External Bus Interface):
NAND, SDRAM, CompactFlash, ...
And, as you pointed out, there's a register to configure the pullup of
the UDC device.

As you can see, the matrix registers might be accessed by different
drivers (include the EBI/SMC driver), hence I proposed to expose them as
a syscon device (see the EBI/SMC series).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
