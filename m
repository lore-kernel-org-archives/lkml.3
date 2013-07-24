Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3GXT3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:29:17 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:4523
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273Ab3GXT3Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:29:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Wed, 24 Jul 2013 14:29:08 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v5 2/4] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
References: <1374646870-5162-1-git-send-email-hongbo.zhang@freescale.com>
	<1374646870-5162-3-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1374646870-5162-3-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Wed Jul 24 01:21:07 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1374694148.15592.61@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 01:21:07 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this  
> patch add
> the device tree nodes for them.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |   66  
> ++++++++++++++++
>  arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81  
> ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81  
> ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>  5 files changed, 232 insertions(+), 4 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt  
> b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> index ed703d9..54a023b2 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> @@ -130,6 +130,72 @@ Example:
>  		};
>  	};
> 
> +** Freescale Elo3 DMA Controller
> +   This is EloPlus controller with 8 channels, used in Freescale  
> Txxx and Bxxx
> +   series chips, such as t1040, t4240, b4860.
> +
> +Required properties:
> +
> +- compatible        : should be "fsl,elo3-dma"

Should include "fsl,elo3-dma".  There's nothing different about elo3  
versus elo/eloplus regarding whether fsl,CHIP-dma is allowed.  I'd just  
drop the references to fsl,CHIP-dma throughout the binding, and phrase  
the compatible description as "must include" rather than "must be" so  
that additional strings are allowed.

-Scott
