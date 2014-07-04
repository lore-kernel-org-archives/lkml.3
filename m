Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaGDG66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:58:58 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:59032
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbaGDG6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:58:55 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Joerg Roedel <joro@8bytes.org>
CC: Olav Haugan <ohaugan@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        "Rhyland Klein" <rklein@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Allen Martin" <amartin@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 02/10] devicetree: Add generic IOMMU device tree
 bindings
Thread-Topic: [PATCH v3 02/10] devicetree: Add generic IOMMU device tree
 bindings
Thread-Index: AQHPkYA08SnEX/zafUiz9zvloXUeUJuPfwkQ
Date: Fri, 4 Jul 2014 06:42:48 +0000
Message-ID: <9ffe3c3871ef4b60a955259bfa0bed6c@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-3-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1403815790-8548-3-git-send-email-thierry.reding@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(189002)(199002)(13464003)(95666004)(83322001)(81342001)(85852003)(66066001)(21056001)(19580395003)(76176999)(92566001)(80022001)(99396002)(74316001)(20776003)(83072002)(46102001)(86362001)(99286002)(85306003)(4396001)(74502001)(77982001)(54356999)(19580405001)(101416001)(87936001)(76482001)(79102001)(74662001)(107046002)(105586002)(50986999)(2656002)(76576001)(81542001)(15975445006)(106356001)(106116001)(33646001)(64706001)(31966008)(108616002)(921003)(1121002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB466;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Thierry Reding
> Sent: Friday, June 27, 2014 2:20 AM
> To: Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell; Kumar Gala;
> Stephen Warren; Arnd Bergmann; Will Deacon; Joerg Roedel
> Cc: Olav Haugan; devicetree@vger.kernel.org; Grant Grundler; Rhyland
> Klein; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> Marc Zyngier; Allen Martin; Paul Walmsley; linux-tegra@vger.kernel.org;
> Cho KyongHo; Dave Martin; linux-arm-kernel@lists.infradead.org
> Subject: [PATCH v3 02/10] devicetree: Add generic IOMMU device tree
> bindings
> 
> From: Thierry Reding <treding@nvidia.com>
> 
> This commit introduces a generic device tree binding for IOMMU devices.
> Only a very minimal subset is described here, but it is enough to cover
> the requirements of both the Exynos System MMU and Tegra SMMU as
> discussed here:
> 
>     https://lkml.org/lkml/2014/4/27/346
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v3:
> - use #iommu-cells instead of #address-cells/#size-cells
> - drop optional iommu-names property
> 
> Changes in v2:
> - add notes about "dma-ranges" property (drop note from commit message)
> - document priorities of "iommus" property vs. "dma-ranges" property
> - drop #iommu-cells in favour of #address-cells and #size-cells
> - remove multiple-master device example
> 
>  Documentation/devicetree/bindings/iommu/iommu.txt | 156
> ++++++++++++++++++++++
>  1 file changed, 156 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
> 
> diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt
> b/Documentation/devicetree/bindings/iommu/iommu.txt
> new file mode 100644
> index 000000000000..f8f03f057156
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iommu/iommu.txt
> @@ -0,0 +1,156 @@
> +This document describes the generic device tree binding for IOMMUs and
> +their master(s).
> +
> +
> +IOMMU device node:
> +==================
> +
> +An IOMMU can provide the following services:
> +
> +* Remap address space to allow devices to access physical memory ranges
> +that
> +  they otherwise wouldn't be capable of accessing.
> +
> +  Example: 32-bit DMA to 64-bit physical addresses
> +
> +* Implement scatter-gather at page level granularity so that the device
> +does
> +  not have to.
> +
> +* Provide system protection against "rogue" DMA by forcing all accesses
> +to go
> +  through the IOMMU and faulting when encountering accesses to unmapped
> +  address regions.
> +
> +* Provide address space isolation between multiple contexts.
> +
> +  Example: Virtualization
> +
> +Device nodes compatible with this binding represent hardware with some
> +of the above capabilities.
> +
> +IOMMUs can be single-master or multiple-master. Single-master IOMMU
> +devices typically have a fixed association to the master device,
> +whereas multiple- master IOMMU devices can translate accesses from more
> than one master.
> +
> +The device tree node of the IOMMU device's parent bus must contain a
> +valid "dma-ranges" property that describes how the physical address
> +space of the IOMMU maps to memory. An empty "dma-ranges" property means
> +that there is a
> +1:1 mapping from IOMMU to memory.
> +
> +Required properties:
> +--------------------
> +- #iommu-cells: The number of cells in an IOMMU specifier needed to
> +encode an
> +  address.
> +
> +Typical values for the above include:
> +- #iommu-cells = <0>: Single master IOMMU devices are not configurable
> +and
> +  therefore no additional information needs to be encoded in the
> specifier.
> +  This may also apply to multiple master IOMMU devices that do not
> +allow the
> +  association of masters to be configured.
> +- #iommu-cells = <1>: Multiple master IOMMU devices may need to be
> +configured
> +  in order to enable translation for a given master. In such cases the
> +single
> +  address cell corresponds to the master device's ID.
> +- #iommu-cells = <4>: Some IOMMU devices allow the DMA window for
> +masters to
> +  be configured. The first cell of the address in this may contain the
> +master
> +  device's ID for example, while the second cell could contain the
> +start of
> +  the DMA window for the given device. The length of the DMA window is
> +given
> +  by the third and fourth cells.
> +
> +
> +IOMMU master node:
> +==================
> +
> +Devices that access memory through an IOMMU are called masters. A
> +device can have multiple master interfaces (to one or more IOMMU
> devices).
> +
> +Required properties:
> +--------------------
> +- iommus: A list of phandle and IOMMU specifier pairs that describe the
> +IOMMU
> +  master interfaces of the device. One entry in the list describes one
> +master
> +  interface of the device.
> +
> +When an "iommus" property is specified in a device tree node, the IOMMU
> +will be used for address translation. If a "dma-ranges" property exists
> +in the device's parent node it will be ignored. An exception to this
> +rule is if the referenced IOMMU is disabled, in which case the
> +"dma-ranges" property of the parent shall take effect.
> +
> +
> +Notes:
> +======
> +
> +One possible extension to the above is to use an "iommus" property
> +along with a "dma-ranges" property in a bus device node (such as PCI
> +host bridges). This can be useful to describe how children on the bus
> +relate to the IOMMU if they are not explicitly listed in the device
> +tree (e.g. PCI devices). However, the requirements of that use-case
> +haven't been fully determined yet. Implementing this is therefore not
> +recommended without further discussion and extension of this binding.
> +
> +
> +Examples:
> +=========
> +
> +Single-master IOMMU:
> +--------------------
> +
> +	iommu {
> +		#iommu-cells = <0>;
> +	};
> +
> +	master {
> +		iommus = <&/iommu>;
> +	};
> +
> +Multiple-master IOMMU with fixed associations:
> +----------------------------------------------
> +
> +	/* multiple-master IOMMU */
> +	iommu {
> +		/*
> +		 * Masters are statically associated with this IOMMU and
> +		 * address translation is always enabled.
> +		 */
> +		#iommu-cells = <0>;
> +	};
> +
> +	/* static association with IOMMU */
> +	master@1 {
> +		reg = <1>;
> +		iommus = <&/iommu>;
> +	};
> +
> +	/* static association with IOMMU */
> +	master@2 {
> +		reg = <2>;
> +		iommus = <&/iommu>;
> +	};
> +
> +Multiple-master IOMMU:
> +----------------------
> +
> +	iommu {
> +		/* the specifier represents the ID of the master */
> +		#iommu-cells = <1>;
> +	};
> +
> +	master {
> +		/* device has master ID 42 in the IOMMU */
> +		iommus = <&/iommu 42>;
> +	};
> +
Master node corresponds to the device node, right? Master ID would correspond to Stream ID? We are already using "iommu-parent" property to link a device to its corresponding IOMMU. We can use the same property instead of using "iommus".

-Varun

