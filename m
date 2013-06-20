Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562Ab3FTNVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:21:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3FTNVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:21:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V8 1/4] pci: Add PCIe driver for Samsung Exynos
Date: Thu, 20 Jun 2013 15:20:48 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>
References: <00db01ce6db3$7f9a3830$7ecea890$@samsung.com>
In-Reply-To: <00db01ce6db3$7f9a3830$7ecea890$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201520.49212.arnd@arndb.de>
X-Provags-ID: V02:K0:OTNDZe/mATFf6x65amimYvWupHLONPdd3CNnNjtrARt
 /4IxTG8FeBM12YPQFs+ZH8JRg79T5LtungcjqkoAU684KLYDfm
 PIP8xUjwVDzHyfrlVfulYCiGf3xktvMgH2E/m55ZnRk8FqnK8E
 XzuqEgdoEiFN0UP/RF4JDhD/lwNPgtCIzIf+un9hF9gScwSgRw
 /aVzDOUIcXeQJdVzpYt4CA00roO20qF8jdGtmamOLvPADRAhq0
 CACzyoth2CeB9hr7kdQ+KGWHeR7mB6hv8Ri765oakcn08MhK8n
 zehtopbzAC3gC6kHVDeJszgmCpN8KdU7YYKasPT5NVUsXP9Xi/
 UTOlO9hYxPXbtP55miAw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Jingoo Han wrote:

> diff --git a/Documentation/devicetree/bindings/pci/exynos-pcie.txt b/Documentation/devicetree/bindings/pci/exynos-pcie.txt
> new file mode 100644
> index 0000000..f71d835
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/exynos-pcie.txt
> @@ -0,0 +1,73 @@
> +* Samsung Exynos PCIe interface

Please adapt the name of the binding as well, and name it snps-dwc-pcie.txt
for instance, to match the change in the driver and in the binding.

> +Required properties:
> +-compatible: should contain "snps,dwc-pcie" to identify the
> +	core, plus an identifier for the specific instance, such
> +	as "samsung,exynos5440-pcie".

Thanks for changing it here.

> +
> +	pcie@290000 {
> +		compatible = "samsung,exynos5440-pcie";
> +		reg = <0x290000 0x1000
> +			0x270000 0x1000
> +			0x271000 0x40>;


but please also change the example and the .dts files to match.
It should say here

		compatible = "samsung,exynos5440-pcie", "snps,dwc-pcie";

as now required by the binding.

	Arnd
