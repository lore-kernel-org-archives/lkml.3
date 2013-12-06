Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab3LFTVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:21:31 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:34108 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662Ab3LFTV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:21:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386357684.7375.124.camel@snotra.buserror.net>
Subject: Re: [PATCH] DTS: DMA: Fix DMA3 interrupts
From: Scott Wood <scottwood@freescale.com>
To: <hongbo.zhang@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 6 Dec 2013 13:21:24 -0600
In-Reply-To: <1385712446-28221-1-git-send-email-hongbo.zhang@freescale.com>
References: <1385712446-28221-1-git-send-email-hongbo.zhang@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-29 at 16:07 +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> MPIC registers for internal interrupts is non-continous in address, any
> internal interrupt number greater than 159 should be added (16+208) to work.
> 16 is due to external interrupts as usual, 208 is due to the non-continous MPIC
> register space.
> Tested on T4240 rev2 with SRIO2 disabled.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

The FSL MPIC binding should be updated to point out how this works.  

Technically it's not a change to the binding itself, since it's defined
in terms of register offset, but the explanatory text says "So interrupt
0 is at offset 0x0, interrupt 1 is at offset 0x20, and so on." which is
not accurate for these new high interrupt numbers.

-Scott



