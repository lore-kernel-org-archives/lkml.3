Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3KFQl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:41:56 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:2877 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab3KFQly convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:41:54 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z37d4lzbb2dI98dI9371Ic89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2149h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Wed, 6 Nov 2013 08:41:44 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] arm: zynq: headsmp: Move .glbl out of actual code
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
 <1383235819-2552-7-git-send-email-soren.brinkmann@xilinx.com>
 <5279F3DD.9040605@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5279F3DD.9040605@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <e1194cb0-825b-4cb1-919c-8879aef95d77@VA3EHSMHS008.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 08:46:37AM +0100, Michal Simek wrote:
> On 10/31/2013 05:10 PM, Soren Brinkmann wrote:
> > Move the .glbl lines exporting symbols to the top of the file and out of
> > the actual code, in order to make the code more readable.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/mach-zynq/headsmp.S | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.S
> > index 57a32869f0aa..12d1b40c7d78 100644
> > --- a/arch/arm/mach-zynq/headsmp.S
> > +++ b/arch/arm/mach-zynq/headsmp.S
> > @@ -9,14 +9,15 @@
> >  #include <linux/linkage.h>
> >  #include <linux/init.h>
> >  
> > +.globl zynq_secondary_trampoline_jump
> > +.globl zynq_secondary_trampoline_end
> > +
> >  ENTRY(zynq_secondary_trampoline)
> >  	ldr	r0, [pc]
> >  	bx	r0
> > -.globl zynq_secondary_trampoline_jump
> >  zynq_secondary_trampoline_jump:
> >  	/* Space for jumping address */
> >  	.word	/* cpu 1 */
> > -.globl zynq_secondary_trampoline_end
> >  zynq_secondary_trampoline_end:
> >  ENDPROC(zynq_secondary_trampoline)
> >  
> 
> I don't want this one.
> I have applied 1-5 to zynq/cleanup branch.
Up to you. But having these .global statements in the middle of actual
code does not help reading the code. And IMHO, they don't belong there.

	Sören


