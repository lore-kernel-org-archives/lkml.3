Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaLCPiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:38:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:41319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbaLCPiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:38:06 -0500
Date: Wed, 3 Dec 2014 16:38:02 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 06/11] memory: atmel-ebi: add DT bindings
 documentation
Message-ID: <20141203163802.2a9c7610@bbrezillon>
In-Reply-To: <20141203163449.3ca4f43b@bbrezillon>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
	<1417429647-3419-7-git-send-email-boris.brezillon@free-electrons.com>
	<547F24B6.8070504@atmel.com>
	<547F2918.3070803@atmel.com>
	<20141203163449.3ca4f43b@bbrezillon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise, I sent the email before finishing my answer.

On Wed, 3 Dec 2014 16:34:49 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> On Wed, 3 Dec 2014 16:15:36 +0100
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
> > Le 03/12/2014 15:56, Nicolas Ferre a écrit :
> > > Le 01/12/2014 11:27, Boris Brezillon a écrit :
> > >> The EBI (External Bus Interface) is used to access external peripherals
> > >> (NOR, SRAM, NAND, and other specific devices like ethernet controllers).
> > >> Each device is assigned a CS line and an address range and can have its
> > >> own configuration (timings, access mode, bus width, ...).
> > >> This driver provides a generic DT binding to configure a device according
> > >> to its requirements.
> > >> For specific device controllers (like the NAND one) the SMC timings
> > >> should be configured by the controller driver through the matrix and smc
> > >> syscon regmaps.
> > >>
> > >> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > >> ---
> > >>  .../bindings/memory-controllers/atmel-ebi.txt      | 155 +++++++++++++++++++++
> > >>  1 file changed, 155 insertions(+)
> > >>  create mode 100644 Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
> > >>
> > >> diff --git a/Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt b/Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
> > >> new file mode 100644
> > >> index 0000000..3749ea1
> > >> --- /dev/null
> > >> +++ b/Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
> > >> @@ -0,0 +1,155 @@
> > >> +* Device tree bindings for Atmel EBI
> > >> +
> > >> +The External Bus Interface (EBI) controller is a bus where you can connect
> > >> +asynchronous (NAND, NOR, SRAM, ....) and synchronous memories (SDR/DDR SDRAMs).
> > >> +The EBI provides a glue-less interface to asynchronous memories though the SMC
> > >> +(Static Memory Controller).
> > >> +Synchronous memories (and some asynchronous memories like NANDs) can be
> > >> +attached to specialized controllers which are responsible for configuring the
> > >> +bus appropriately according to the connected device.
> > >> +In the other hand, the bus interface can be automated for simple asynchronous
> > >> +devices.
> > >> +
> > >> +Required properties:
> > >> +
> > >> +- compatible:		"atmel,at91sam9260-ebi"
> > >> +			"atmel,at91sam9261-ebi"
> > >> +			"atmel,at91sam9263-ebi0"
> > >> +			"atmel,at91sam9263-ebi1"
> > > 
> > > Ditto: 9263 twice.
> > > 
> > >> +			"atmel,at91sam9g45-ebi"
> > >> +			"atmel,at91sam9x5-ebi"
> > >> +			"atmel,sama5d3-ebi"
> > >> +
> > >> +- reg:			Contains offset/length value for EBI memory mapping.
> > >> +			This property might contain several entries if the EBI
> > >> +			memory range is not contiguous
> > >> +
> > >> +- #address-cells:	Must be 2.
> > >> +			The first cell encodes the CS.
> > >> +			The second cell encode the offset into the CS memory
> > >> +			range.
> > >> +
> > >> +- #size-cells:		Must be set to 1.
> > >> +
> > >> +- ranges:		Encodes CS to memory region association.
> > >> +
> > >> +- clocks:		Clock feeding the EBI controller.
> > >> +			See clock-bindings.txt
> > >> +
> > >> +Child chip-select (cs) nodes contain the memory devices nodes connected to
> > >> +such as NOR (e.g. cfi-flash) and NAND.
> > >> +There might be board specific devices like FPGAs.
> > >> +You'll define you device requirements in these child nodes.
> > >> +
> > >> +Required child cs node properties:
> > >> +
> > >> +- #address-cells:	Must be 2.
> > >> +
> > >> +- #size-cells:		Must be 1.
> > >> +
> > >> +- ranges:		Empty property indicating that child nodes can inherit
> > >> +			memory layout.
> > >> +
> > >> +Optional child cs node properties:
> > >> +- atmel,generic-dev		boolean property specifying if the device is
> > >> +				a generic device.
> > 
> > Well... no real information, specify right here what a "generic device" is.
> 
> I do not describe what a generic device is, but the description of a
> specialized device is given just below.
> 
> Maybe I haven't chosen the appropriate word here.
> The datasheet gives the following description:

• EBI_CS4A: EBI Chip Select 4 Assignment
0 = EBI Chip Select 4 is only assigned to the Static Memory Controller
    and EBI_NCS4 behaves as defined by the SMC.
1 = EBI Chip Select 4 is assigned to the Static Memory Controller and
    the CompactFlash Logic (first slot) is activated.

What about using "atmel,generic-logic" instead of
"atmel,generic-dev" ?


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
