Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaGBMGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:06:10 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42294 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGBMGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:06:07 -0400
Date: Wed, 2 Jul 2014 13:06:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com
Subject: Re: [PATCH 1/5] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140702120601.GD16724@lee--X1>
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
 <1404133317-25953-2-git-send-email-lee.jones@linaro.org>
 <53B3CFDD.5090504@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B3CFDD.5090504@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2014, Kishon Vijay Abraham I wrote:
> On Monday 30 June 2014 06:31 PM, Lee Jones wrote:
> > The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> > devices. It has 2 ports which it can use for either; both SATA, both
> > PCIe or one of each in any configuration.
> > 
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  .../devicetree/bindings/phy/phy-miphy365x.txt      | 76 ++++++++++++++++++++++
> >  1 file changed, 76 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> > new file mode 100644
> > index 0000000..d75f300
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> > @@ -0,0 +1,76 @@
> > +STMicroelectronics STi MIPHY365x PHY binding
> > +============================================
> > +
> > +This binding describes a miphy device that is used to control PHY hardware
> > +for SATA and PCIe.
> > +
> > +Required properties:
> > +- compatible :	Should be "st,miphy365x-phy"
> > +- #phy-cells :	Should be 2 (See second example)
> > +		First cell is the port number from:
> > +			- MIPHY_PORT_0
> > +			- MIPHY_PORT_1
> 
> I'm just thinking if we can directly give phandle to the sub-node
> (channel0/channel1 or port0/port1) we won't need this information in the PHY
> specifier. This might need some modification in the phy-core but that can be done.

If we do that, we need a new property to identify the port number.  I
figured using an existing cell to identify the port would be better
than to try an introduce yet another property.

> > +		Second cell is device type from:
> > +			- MIPHY_TYPE_SATA
> > +			- MIPHY_TYPE_PCI
> > +- reg       :	Address and length of register sets for each device in
> > +		"reg-names"
> > +- reg-names : 	The names of the register addresses corresponding to the
> > +		registers filled in "reg", from:
> > +			- sata0: For SATA port 0 registers
> > +			- sata1: For SATA port 1 registers
> > +			- pcie0: For PCIE port 0 registers
> > +			- pcie1: For PCIE port 1 registers
> 
> this information should be in the documentation of sub-nodes.

You're right, will fix.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
