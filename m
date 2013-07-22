Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3GVRxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:53:30 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:33106
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab3GVRx3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:53:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
Date: Mon, 22 Jul 2013 12:53:20 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v4 1/3] DMA: Freescale: revise device tree binding
 document
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <vakul@freescale.com>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
In-Reply-To: <1374472540-21177-2-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Mon Jul 22 00:55:38 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1374515600.15592.8@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 12:55:38 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> This updates the discription of each type of DMA controller and its  
> channels,
> it is preparation for adding another new DMA controller binding, also  
> fixes
> some defects of indent for text alignment at the same time.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |   56  
> +++++++++++---------
>  1 file changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt  
> b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> index 2a4b4bc..0650171 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> @@ -1,33 +1,33 @@
> -* Freescale 83xx DMA Controller
> +* Freescale DMA Controllers
> 
> -Freescale PowerPC 83xx have on chip general purpose DMA controllers.
> +** Freescale ELO DMA Controller
> +   This is a little-endian DMA controller.
> +   Used in Freescale PowerPC 83xx series, such as:
> +   mpc8313, mpc8315, mpc8323, mpc8347, mpc8349, mpc8360, mpc8377,  
> mpc8378, mpc8379.

You don't need to list every single chip...  What happens when new  
chips come out (not so likely with mpc83xx, but more likely for  
eloplus/elo3)?  Do we keep updating this, or have a list that looks  
complete but isn't?

My point in suggesting that some examples be given is just so that the  
reader knows where to find a manual that documents a particular version  
of "elo", and to give a rough idea of what product families use it.

> -Freescale PowerPC 85xx/86xx have on chip general purpose DMA  
> controllers.
> +** Freescale ELOPLUS DMA Controller
> +   This is DMA controller with extended addresses and chaining.
> +   Used in Freescale PowerPC 85xx/86xx and pxxx series chips, such  
> as:
> +   [1] mpc8540, mpc8541, mpc8555, mpc8560, mpc8610, mpc8641,
> +   [2] mpc8536, mpc8544, mpc8548, mpc8568, mpc8569, mpc8572, p1010,  
> p1020, p1021,
> +       p1022, p1023, p2020, p2041, p3041, p4080, p5020, p5040, and  
> also bsc9131.

What do [1] and [2] signify here?

Oh, I see.  It's weird for footnotes to come before the place they're  
referenced...

>  Required properties:
> 
> -- compatible        : compatible list, contains 2 entries, first is
> -		 "fsl,CHIP-dma", where CHIP is the processor
> -		 (mpc8540, mpc8540, etc.) and the second is
> -		 "fsl,eloplus-dma"
> +- compatible        : compatible list, contains 2 entries for chips  
> in above
> +                      list[1], the first is "fsl,CHIP-dma", where  
> CHIP is the
> +                      processor and the second is "fsl,eloplus-dma".  
> contains
> +                      only one "fsl,eloplus-dma" for chips in above  
> list[2]

Don't encode this difference in the binding document.  It wasn't on  
purpose, but rather an artifact of factoring things out into dtsi  
files.  Just make it optional.

Why can't we just talk about what compatible must include, as I  
suggested earlier, rather than what it must *be*?

>  - reg               : <registers mapping for DMA general status reg>
>  - cell-index        : controller index.  0 for controller @ 0x21000,
>                                           1 for controller @ 0xc000
> -- ranges		: Should be defined as specified in 1) to  
> describe the
> -		  DMA controller channels.
> +- ranges            : physical address range of DMA controller  
> channels

ranges will not have physical addresses at this level.  They'll only  
become physical addresses when translated by the ccsr node's ranges.

-Scott
