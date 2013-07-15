Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3GOR5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:57:21 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:36938
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab3GOR5S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:57:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Mon, 15 Jul 2013 12:57:05 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v3 1/2] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <vakul@freescale.com>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
References: <1373884499-24079-1-git-send-email-hongbo.zhang@freescale.com>
	<1373884499-24079-2-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1373884499-24079-2-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Mon Jul 15 05:34:58 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1373911025.8183.308@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 05:34:58 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this  
> patch add
> the device tree nodes for them.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |    8 +-
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   90  
> ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   90  
> ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>  4 files changed, 187 insertions(+), 5 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt  
> b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> index 2a4b4bc..8ee5732 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> @@ -76,10 +76,10 @@ Freescale PowerPC 85xx/86xx have on chip general  
> purpose DMA controllers.
> 
>  Required properties:
> 
> -- compatible        : compatible list, contains 2 entries, first is
> +- compatible        : compatible list, contains 3 entries, first is
>  		 "fsl,CHIP-dma", where CHIP is the processor
>  		 (mpc8540, mpc8540, etc.) and the second is
> -		 "fsl,eloplus-dma"
> +		 "fsl,eloplus-dma", the third is "fsl,elo3-dma"

The new device tree nodes have only one compatible in the list, not  
three.  And if you were to both fsl,eloplus-dma and fsl,elo3-dma on the  
same node, fsl,elo3-dma should come first.

>  - reg               : <registers mapping for DMA general status reg>
>  - cell-index        : controller index.  0 for controller @ 0x21000,
>                                           1 for controller @ 0xc000
> @@ -100,7 +100,7 @@ Example:
>  	dma@21300 {
>  		#address-cells = <1>;
>  		#size-cells = <1>;
> -		compatible = "fsl,mpc8540-dma", "fsl,eloplus-dma";
> +		compatible = "fsl,mpc8540-dma", "fsl,eloplus-dma",  
> "fsl,elo3-dma";

In addition to the above issue about ordering, mpc8540 does not have  
elo3.

-Scott
