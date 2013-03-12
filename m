Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3CLGxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:53:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51654 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab3CLGxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:53:42 -0400
Message-ID: <513ED0CF.6070302@ti.com>
Date: Tue, 12 Mar 2013 12:23:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 5/9] dmaengine: edma: Add TI EDMA device tree binding
References: <1362586540-10393-1-git-send-email-mporter@ti.com> <1362586540-10393-6-git-send-email-mporter@ti.com>
In-Reply-To: <1362586540-10393-6-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2013 9:45 PM, Matt Porter wrote:
> The binding definition is based on the generic DMA controller
> binding.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>

Okay the bindings the documented after they are used leading to some
confusion. This patch should be moved up the series. As I noted in my
other e-mail, some of these bindings are not really hardware description
and need to be re-looked.

Thanks,
Sekhar

> ---
>  Documentation/devicetree/bindings/dma/ti-edma.txt |   49 +++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
> 
> diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
> new file mode 100644
> index 0000000..075a60e3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
> @@ -0,0 +1,49 @@
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
> 
