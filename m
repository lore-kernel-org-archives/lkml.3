Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3AKHyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:54:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45082 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab3AKHys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:54:48 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Subject: RE: [PATCH v4 05/14] dmaengine: edma: Add TI EDMA device tree
 binding
Thread-Topic: [PATCH v4 05/14] dmaengine: edma: Add TI EDMA device tree
 binding
Thread-Index: AQHN778N3Q8yXUBs106MMySLg/IG4JhDwfDw
Date: Fri, 11 Jan 2013 07:54:05 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB3EBBD@DBDE01.ent.ti.com>
References: <1357883330-5364-1-git-send-email-mporter@ti.com>
 <1357883330-5364-6-git-send-email-mporter@ti.com>
In-Reply-To: <1357883330-5364-6-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 11:18:41, Porter, Matt wrote:
> The binding definition is based on the generic DMA controller
> binding.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  Documentation/devicetree/bindings/dma/ti-edma.txt |   51 +++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
> 
> diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
> new file mode 100644
> index 0000000..3344345
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
> @@ -0,0 +1,51 @@
> +TI EDMA
> +
> +Required properties:
> +- compatible : "ti,edma3"
> +- ti,hwmods: Name of the hwmods associated to the EDMA
> +- ti,edma-regions: Number of regions
> +- ti,edma-slots: Number of slots
> +- ti,edma-queue-tc-map: List of transfer control to queue mappings
> +- ti,edma-queue-priority-map: List of queue priority mappings
> +- ti,edma-default-queue: Default queue value
> +
> +Optional properties:
> +- ti,edma-reserved-channels: List of reserved channel regions
> +- ti,edma-reserved-slots: List of reserved slot regions
> +- ti,edma-xbar-event-map: Crossbar event to channel map
> +
> +Example:
> +
> +edma: edma@49000000 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;

address-cells & size-cells are only required when current node is a parent 
node & it has sibling/child nodes (that too if the child node uses "reg" 
property).

> +	reg = <0x49000000 0x10000>;
> +	interrupt-parent = <&intc>;
> +	interrupts = <12 13 14>;
> +	compatible = "ti,edma3";
> +	ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> +	#dma-cells = <1>;
> +	dma-channels = <64>;
> +	ti,edma-regions = <4>;
> +	ti,edma-slots = <256>;
> +	ti,edma-reserved-channels = <0  2
> +				     14 2
> +				     26 6
> +				     48 4
> +				     56 8>;
> +	ti,edma-reserved-slots = <0  2
> +				  14 2
> +				  26 6
> +				  48 4
> +				  56 8
> +				  64 127>;
> +	ti,edma-queue-tc-map = <0 0
> +				1 1
> +				2 2>;
> +	ti,edma-queue-priority-map = <0 0
> +				      1 1
> +				      2 2>;
> +	ti,edma-default-queue = <0>;
> +	ti,edma-xbar-event-map = <1 12
> +				  2 13>;
> +};
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
