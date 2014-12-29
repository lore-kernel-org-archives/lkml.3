Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaL2M2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:28:49 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52676 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751580AbaL2M2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:28:46 -0500
Date: Mon, 29 Dec 2014 13:28:41 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: at91/dt: sama5: move NAND nodes into board
 dts/dtsi
Message-ID: <20141229132841.3d694058@bbrezillon>
In-Reply-To: <549D2E4F.4090705@atmel.com>
References: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com>
	<1417732214-3292-5-git-send-email-boris.brezillon@free-electrons.com>
	<549D2E4F.4090705@atmel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Fri, 26 Dec 2014 17:45:51 +0800
Josh Wu <josh.wu@atmel.com> wrote:

> Hi, Boris
> 
> On 12/5/2014 6:30 AM, Boris Brezillon wrote:
> > sama5d3 and sama5d4 SoCs provides several CS to interface with external
> > memories, and in particular NAND chips.
> > The NAND flash controller embedded in the these SoCs can connect to any of
> > the available CS (each CS is assigned a memory range, hence the nand@xxx
> > you're seeing in the DT), thus the NAND chip definition should be part of
> > the board description because we cannot guess at the SoC level which CS
> > will be chosen by the board designer.
> >
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >   arch/arm/boot/dts/at91-sama5d3_xplained.dts | 18 +++++++++++++++++-
> >   arch/arm/boot/dts/at91-sama5d4ek.dts        | 16 +++++++++++++++-
> >   arch/arm/boot/dts/sama5d3.dtsi              | 21 ---------------------
> >   arch/arm/boot/dts/sama5d3xcm.dtsi           | 18 +++++++++++++++++-
> >   arch/arm/boot/dts/sama5d4.dtsi              | 19 -------------------
> >   5 files changed, 49 insertions(+), 43 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> > index fec1fca..860258b 100644
> > --- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> > +++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> > @@ -213,13 +213,29 @@
> >   		};
> >   
> >   		nand0: nand@60000000 {
> > +			compatible = "atmel,at91rm9200-nand";
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			ranges;
> it would be better to leave this part to the sama5d3.dtsi.

Actually I did it on purpose, because nothing prevents anyone from
connecting its NAND chip on a different CS and connect something else
on CS3, hence this NAND node should not be defined at SoC level but in
upper layers.
I know this is currently hardcoded in the NAND driver, but I'd really
like to have the DT part corrected, and defining the NAND node in the
proper dts(i) file is part of the correction.

If you really want to make this node common to all atmel boards
embedding a sama5d3 SoC, then we could create another dtsi (but I
remember that Nicolas was trying to limit the number of dtsi files).

The same goes for the other parts you pointed out.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
