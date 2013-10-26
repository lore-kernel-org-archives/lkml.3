Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3JZMpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 08:45:54 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58164 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3JZMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 08:45:51 -0400
Date: Sat, 26 Oct 2013 08:45:46 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Wendy Ng <wendy.ng@broadcom.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Eduardo Valentin <eduardo.valentin@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>,
        Markus Mayer <mmayer@broadcom.com>, Tim Kryger <tim.kryger@linaro.org>
Subject: Re: [PATCH 1/3] thermal: bcm281xx: Add Temperature Monitor driver
Message-ID: <20131026124546.GH29341@beef>
References: <1382745629-1123-1-git-send-email-wendy.ng@broadcom.com>
 <1382745629-1123-2-git-send-email-wendy.ng@broadcom.com>
 <382461FD-5CB7-461C-A9A7-76D2EF99C769@codeaurora.org>
 <46DC9641-6D01-4D2F-B5C3-0942B480D6E0@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DC9641-6D01-4D2F-B5C3-0942B480D6E0@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 01:47:40AM -0500, Kumar Gala wrote:
> 
> On Oct 26, 2013, at 1:46 AM, Kumar Gala wrote:
> 
> > 
> > On Oct 25, 2013, at 7:00 PM, Wendy Ng wrote:
> > 
> >> This adds the support for Temperature Monitor (TMON) driver for
> >> Broadcom bcm281xx SoCs. This driver plugs into the Thermal Framework.
> >> 
> >> Note that this version of the TMON driver does support interrupt-driven
> >> mode -- only polling-mode of the thermal framework can be used.
> >> 
> >> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
> >> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
> >> Reviewed-by: Christian Daudt <csd@broadcom.com>
> >> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> >> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> >> ---
> >> .../bindings/thermal/bcm-kona-thermal.txt          |   24 +++
> >> drivers/thermal/Kconfig                            |   11 ++
> >> drivers/thermal/Makefile                           |    1 +
> >> drivers/thermal/bcm_kona_tmon.c                    |  173 ++++++++++++++++++++
> >> 4 files changed, 209 insertions(+)
> >> create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
> >> create mode 100644 drivers/thermal/bcm_kona_tmon.c
> >> 
> >> diff --git a/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
> >> new file mode 100644
> >> index 0000000..225b898
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
> >> @@ -0,0 +1,24 @@
> >> +* Broadcom Kona TMON bindings
> >> +
> >> +This version is for the Kona family of SoCs.  The TMON (Temperature Monitor)
> >> +block in a Kona SoC device is used to measure the chip temperature at constant
> >> +intervals.
> >> +The TMON block asserts an interrupt if temperature exceeds a user programmed
> >> +threshold value.  The TMON block would reset the entire device once it
> >> +reaches a critical temperature which is also a programmable setting.
> >> +
> >> +Required properties:
> >> +- compatible : "brcm,bcm11351-tmon", "brcm,kona-tmon"
> >> +- reg : Address range of the thermal register
> >> +- clocks : the clock signal that drives the TMON block
> >> +- interrupts: the interrupt signal associated with the TMON block
> >> +
> >> +
> >> +Example:
> >> +	tmon@34008000 {
> >> +		compatible = "brcm,bcm11351-tmon", "brcm,kona-tmon";
> >> +		reg = <0x34008000 0x0024>;
> >> +		clocks = <&tmon_1m_clk>;
> >> +		interrupts = <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>;
> >> +		status = "disabled";
> > 
> > I'd remove the 'status' line from an example.
> > 
> >> +	};
> > 
> > Ack on the binding (beyond my minor nit pick on the status prop).
> > 
> > Acked-by: Kumar Gala <galak@codeaurora.org>
> > 
> > - k
> 
> 
> After looking at your .dts{i} I see you've got a #thermal-sensor-cells prop, where is that documented?

It's in Eduardo's "device thermal limits represented in device tree
nodes" series. Here's the direct link to the binding post/discussion
https://lkml.org/lkml/2013/9/26/772

-Matt
