Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaA1Tre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:47:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaA1Trb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:47:31 -0500
Date: Tue, 28 Jan 2014 13:47:29 -0600
From: Andy Gross <agross@codeaurora.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
Message-ID: <20140128194729.GA18930@qualcomm.com>
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org>
 <1390890471-14882-3-git-send-email-agross@codeaurora.org>
 <52E772DF.6000604@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E772DF.6000604@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:05:35AM +0100, Lars-Peter Clausen wrote:
> On 01/28/2014 07:27 AM, Andy Gross wrote:
> > Add device tree binding support for the QCOM BAM DMA driver.
> > 
> > Signed-off-by: Andy Gross <agross@codeaurora.org>
> > ---
> >  .../devicetree/bindings/dma/qcom_bam_dma.txt       |   52 ++++++++++++++++++++
> >  1 file changed, 52 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > new file mode 100644
> > index 0000000..53fd10a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > @@ -0,0 +1,52 @@
> > +QCOM BAM DMA controller
> > +
> > +Required properties:
> > +- compatible:	Must be "qcom,bam-v1.4.0" for MSM8974 V1
> > +		Must be "qcom,bam-v1.4.1" for MSM8974 V2
> > +- reg: Address range for DMA registers
> > +- interrupts: single interrupt for this controller
> > +- #dma-cells: must be <2>
> > +- clocks: required clock
> > +- clock-names: name of clock
> > +- qcom,ee : indicates the active Execution Environment identifier (0-7)
> > +
> > +Example:
> > +
> > +	uart-bam: dma@f9984000 = {
> > +		compatible = "qcom,bam-v1.4.1";
> > +		reg = <0xf9984000 0x15000>;
> > +		interrupts = <0 94 0>;
> > +		clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
> > +		clock-names = "bam_clk";
> > +		#dma-cells = <2>;
> > +		qcom,ee = <0>;
> > +	};
> > +
> > +Client:
> > +Required properties:
> > +- dmas: List of dma channel requests
> > +- dma-names: Names of aforementioned requested channels
> > +
> > +Clients must use the format described in the dma.txt file, using a three cell
> > +specifier for each channel.
> > +
> > +The three cells in order are:
> > +  1. A phandle pointing to the DMA controller
> > +  2. The channel number
> > +  3. Direction of the fixed unidirectional channel
> > +     0 - Memory to Device
> > +     1 - Device to Memory
> > +     2 - Device to Device
> > +
> 
> Why does the direction needs to be specified in specifier? I see two
> options, either the direction per is fixed in hardware. In that case the DMA
> controller node should describe which channel is which direction. Or the
> direction is not fixed in hardware and can be changed at runtime in which
> case it should be set on a per descriptor basis.
> 

It is specified because the direction is physically set by the hardware.  And
this can change depending on the attached peripheral.  It probably does make
more sense to set the direction in the controller.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
