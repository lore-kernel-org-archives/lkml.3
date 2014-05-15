Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaEOQ2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:28:23 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49380 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaEOQ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:28:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware core driver
Date: Thu, 15 May 2014 18:28 +0200
Message-ID: <4195791.GS9XG8RaXW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400169692-9677-6-git-send-email-m-karicheri2@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-6-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Tvi1x81Udtn1hr1tQPZKsEtTVXYnz79tFsfKReLxzUR
 gF2DGXlMr/vvZunr6nT4Xtvpmz1YF3QRbCIUWBEaepWKyPfrgc
 aW6qJZgjheXXh2Yk3dDZ4/6xsrx/8A3AxFyNnOSY27Xg0+gN+r
 Qz4RdU36SAcPdeFPogWwIoz8ssj/woWS7yDAiD1DsdSNUvTK9N
 AI5X6jGwWOL/MKZAQrjScO2+tzsAK7DASg+dRH5l3tlhouOEEY
 1PqmXNATnlLRDbXHbYwaaNXp8RIiK+/A7n2ACJ/lMPeY0V/2Gb
 P1z8MEEfxYWtSlLeJ8ldKSAq5e8OxW6XlL5g2tXBviEgeRn/IU
 sLh1M9OZ3Tw/g7yCP3vc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 12:01:32 Murali Karicheri wrote:
> +Sample bindings shown below:-
> +
> + - Remove ti,enable-linktrain if boot loader already does Link training and do EP
> +   configuration.
> + - Remove ti,init-phy if boot loader already initialize the phy and sets up pcie
> +   link

You actually have to document all the properties. Have a look at the
other bindings for what this means.

> +
> +               pcie@21800000 {
> +                       compatible = "ti,keystone-pcie";
> +                       device_type = "pci";
> +                       clocks = <&clkpcie>;
> +                       clock-names = "pcie";

The dw-pcie binding lists two clocks.

> +                       #address-cells = >;
> +                       #size-cells = <2>;
> +                       reg =  <0x21800000 0x1000>, <0x0262014c 4>;
> +                       reg-names = "reg_rc_app", "reg_devcfg";

There should be standard names that are documented in the binding.

> +                       interrupts = <GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 37 IRQ_TYPE_EDGE_RISING>,
> +                                       <GIC_SPI 38 IRQ_TYPE_EDGE_RISING>; /* Error IRQ */

What are all these interrupts?

> +                       ranges = <0x00000800 0 0x21801000 0x21801000 0 0x0002000    /* Configuration space */
> +                                 0x81000000 0 0          0x24000000 0 0x4000       /* downstream I/O */
> +                                 0x82000000 0 0x50000000 0x50000000 0 0x10000000>; /* non-prefetchable memory */

Please move the config space into 'reg' now instead of 'ranges'.
This was a mistake earlier, and there are already other front-ends
doing the same thing.

> +                       num-lanes = <2>;
> +                       ti,enable-linktrain;
> +                       ti,init-phy;
> +
> +                       /* PCIE phy */
> +                       phys = <&pcie0_phy>;
> +                       phy-names = "pcie-phy";
> +
> +                       #interrupt-cells = <1>;
> +                       interrupt-map-mask = <0 0 0 0>;
> +                       interrupt-map = <0 0 0 1 &pcie_intc 1>, // INT A
> +                                       <0 0 0 2 &pcie_intc 2>, // INT B
> +                                       <0 0 0 3 &pcie_intc 3>, // INT C
> +                                       <0 0 0 4 &pcie_intc 4>; // INT D

I think this is the wrong map-mask.

	Arnd
