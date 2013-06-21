Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3FUEKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:10:51 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:62536 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3FUEKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <002001ce6e2e$623d7970$26b86c50$@samsung.com>
References: <002001ce6e2e$623d7970$26b86c50$@samsung.com>
Date: Fri, 21 Jun 2013 09:40:48 +0530
Message-ID: <CAK9yfHxCy0JcvsFHo8gERefdiZhxi1J8MNALe5-g6ooTGR-QjA@mail.gmail.com>
Subject: Re: [PATCH V9 1/4] pci: Add PCIe driver for Samsung Exynos
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Surendranath Gurivireddy Balla <suren.reddy@samsung.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

Some small corrections inline.

On 21 June 2013 08:51, Jingoo Han <jg1.han@samsung.com> wrote:
> Exynos5440 has a PCIe controller which can be used as Root Complex.
> This driver supports a PCIe controller as Root Complex mode.
>
> Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../devicetree/bindings/pci/designware-pcie.txt    |   73 ++
>  drivers/pci/host/Kconfig                           |    9 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-designware.c                  | 1057 ++++++++++++++++++++
>  4 files changed, 1140 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/designware-pcie.txt
>  create mode 100644 drivers/pci/host/pci-designware.c
>
> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> new file mode 100644
> index 0000000..e4681e6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> @@ -0,0 +1,73 @@
> +* Synopsis Designware PCIe interface
> +
> +Required properties:
> +-compatible: should contain "snps,dw-pcie" to identify the
> +       core, plus an identifier for the specific instance, such
> +       as "samsung,exynos5440-pcie".
> +-reg: base addresses and lengths of the pcie conteroller,

s/conteroller/controller

> +       the phy controller, additional register for the phy controller.
> +- interrupts: interrupt values for level interrupt,
> +       pulse interrupt, special interrupt.
> +- clocks: from common clock binding: handle to pci clock.
> +- clock-names: from common clock binding: Shall be "pcie", "pcie_bus".

s/Shall be .../should be "pcie" and "pcie_bus".

[snip]

> +
> +MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
> +MODULE_DESCRIPTION("Samsung PCIe host controller driver");
> +MODULE_LICENSE("GPLv2");

I think this should be "GPL v2"  (with a space between GPL and v2).


-- 
With warm regards,
Sachin
