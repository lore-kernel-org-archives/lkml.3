Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3FQLCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:02:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43140 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983Ab3FQLCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:02:49 -0400
Message-ID: <51BEEC84.1080102@ti.com>
Date: Mon, 17 Jun 2013 16:31:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joel A Fernandes <joelagnel@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
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
Subject: Re: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree binding
References: <1371263570-9323-1-git-send-email-joelagnel@ti.com> <1371263570-9323-5-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371263570-9323-5-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant, Rob,

Can one of you please take a look at this patch and see if you have any
comments on the binding definition?

Joel,

Ideally the bindings are described before they are used or along with
its usage. In that aspect, this patch is present too far back in the
series. Can you please fix this if you get to posting another version. I
think I gave the same comment on v9 as well.

On 6/15/2013 8:02 AM, Joel A Fernandes wrote:
> From: Matt Porter <mdp@ti.com>
> 
> The binding definition is based on the generic DMA controller
> binding.
> 
> Joel: Droped reserved and queue DT entries from Documentation
> for now from the original patch series.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> ---
>  Documentation/devicetree/bindings/dma/ti-edma.txt |   26 +++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
> 
> diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
> new file mode 100644
> index 0000000..ada0018
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
> @@ -0,0 +1,26 @@
> +TI EDMA
> +
> +Required properties:
> +- compatible : "ti,edma3"
> +- ti,hwmods: Name of the hwmods associated to the EDMA

ti,hwmods should be optional, no? hwmod is not present on DaVinci where
EDMA is also used. If it is not optional then these bindings wont work
there.

Thanks,
Sekhar
