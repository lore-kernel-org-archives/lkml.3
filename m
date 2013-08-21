Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3HUWqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:46:09 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:11105
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020Ab3HUWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:46:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1377125156.5029.40.camel@snotra.buserror.net>
Subject: Re: [PATCH v7 1/3] DMA: Freescale: revise device tree binding
 document
From: Scott Wood <scottwood@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <hongbo.zhang@freescale.com>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <leoli@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 21 Aug 2013 17:45:56 -0500
In-Reply-To: <5215402E.70007@wwwdotorg.org>
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
	 <1375094944-3343-2-git-send-email-hongbo.zhang@freescale.com>
	 <5215402E.70007@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 16:33 -0600, Stephen Warren wrote:
> On 07/29/2013 04:49 AM, hongbo.zhang@freescale.com wrote:
> > From: Hongbo Zhang <hongbo.zhang@freescale.com>
> > 
> > This patch updates the discription of each type of DMA controller and its
> > channels, it is preparation for adding another new DMA controller binding, it
> > also fixes some defects of indent for text alignment at the same time.
> 
> > diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> 
> > -- compatible        : compatible list, contains 2 entries, first is
> > -		 "fsl,CHIP-dma", where CHIP is the processor
> > -		 (mpc8349, mpc8360, etc.) and the second is
> > -		 "fsl,elo-dma"
> > +- compatible        : must include "fsl,elo-dma"
> 
> Why remove the list of supported compatible values. Lately it seems that
> we're moving towards listing more/all the values rather than removing
> their documentation...

Previous versions had language that required fsl,CHIP-dma for 83xx (and
maybe 85xx?) but not the new chip.  I asked for it to be consistent.
The reason that 83xx still has fsl,CHIP-dma is not because of anything
special to 83xx, but that most other chips with this device have been
converted to dtsi and it's much more of a pain to specify the specific
SoC in that context.  The existing language does not match actual device
trees when it comes to 85xx.

Plus, the exact SoC name is of dubious value for integrated devices.  It
doesn't uniquely identify the hardware because different versions of the
SoC could have different versions of the subdevice.  As such, on our
chips we've been moving away from including a compatible that specifies
the exact SoC.  If it turns out we made a mistake in naming different
versions of the device, or if there are errata, the exact SoC can still
be determined at runtime using SVR.

> > -- ranges		: Should be defined as specified in 1) to describe the
> > -		  DMA controller channels.
> > +- ranges            : describes the mapping between the address space of the
> > +                      DMA channels and the address space of the DMA controller
> 
> What is "the address space of the DMA controller". Perhaps this should
> say "the CPU-visible address space" instead?

It's translating from the addresses used in the child nodes to a CCSR
offset.  It's really just a convenience for the readability and
macro-ability of the device tree that we do this translation at all,
versus having an empty ranges and using CCSR offsets in the children.

It's not about translating between the DMA controller's view and the
CPU's view or anything like that.

-Scott



