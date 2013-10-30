Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3J3J6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:58:09 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:55844
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734Ab3J3J6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:58:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z56bfiz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h17326ah8275bh1de097h186068hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Wed, 30 Oct 2013 17:32:18 +0800
From: Nicolin Chen <b42378@freescale.com>
To: <s.hauer@pengutronix.de>
CC: <timur@tabi.org>, <shawn.guo@linaro.org>, <broonie@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <b32955@freescale.com>
Subject: [b42378@freescale.com: Re: [PATCH 1/3] dma: imx-sdma: Add ssi dual
 fifo script support]
Message-ID: <20131030093218.GF9605@MrMyself>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just found that I missed Sascha's mail address in my TO list of last reply.
So resend it. And sorry for the duplicated mails.

----- Forwarded message from Nicolin Chen <b42378@freescale.com> -----

Date: Wed, 30 Oct 2013 12:48:48 +0800
From: Nicolin Chen <b42378@freescale.com>
Subject: Re: [PATCH 1/3] dma: imx-sdma: Add ssi dual fifo script support
User-Agent: Mutt/1.5.21 (2010-09-15)

Hi Sascha,

On Tue, Oct 29, 2013 at 02:51:43PM +0100, Sascha Hauer wrote:
> Look at drivers/dma/imx-sdma.c:
> 
> > /**
> >  * struct sdma_firmware_header - Layout of the firmware image
> >  *
> >  * @magic		"SDMA"
> >  * @version_major	increased whenever layout of struct
> >  * sdma_script_start_addrs
> >  *			changes.
> 
> Can you image why this firmware has a version field? Right, it's because
> it encodes the layout of struct sdma_script_start_addrs.
> 
> As the comment clearly states you have to *increase this field* when you
> add scripts.
> 
> Obviously you missed that, as the firmware on lkml posted recently
> shows:
> 
> > 00000000: 414d4453 00000001 00000001 0000001c SDMA............
>                      ^^^^^^^^
>                      Still '1'
> 
> > 00000010: 00000026 000000b4 0000067a 00000282 &.......z.......
> > 00000020: ffffffff 00000000 ffffffff ffffffff ................
> > 00000030: ffffffff ffffffff ffffffff ffffffff ................
> > 00000040: ffffffff ffffffff 00001a6a ffffffff ........j.......
> > 00000050: 000002eb 000018bb ffffffff 00000408 ................
> > 00000060: ffffffff 000003c0 ffffffff ffffffff ................
> > 00000070: ffffffff 000002ab ffffffff 0000037b ............{...
> > 00000080: ffffffff ffffffff 0000044c 0000046e ........L...n...
> > 00000090: ffffffff 00001800 ffffffff ffffffff ................
> > 000000a0: 00000000 00001800 00001862 00001a16 ........b.......
>                               ^^^^^^^^^^^^^^^^^
>                               new script addresses introduced
> 
> 
> > -#define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1	34
> > +#define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1	37
> 
> And no, this is not a bug. It's your firmware header that is buggy.
> 

I wasn't aware that the problem is far more complicated than I thought.
And thank you for telling me all this.

> What you need is:
> 
> #define SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V2      37
> 
> You (you as a company, not you as a person) knew that it was me who
> created this firmware format. So it was absolutely unnecessary to create
> an incompatible firmware instead of dropping me a short note.
> 
> Please add a version check to the driver as necessary and provide a proper
> firmware.
> 

Just currently it's not easy for me to create a new proper firmware,
and I's been told that besides this version number, it also lacks a
decent license info. So may I just refine this patch as you suggested
to add a version check and add those new scripts first?

Thank you,
Nicolin Chen

> Sascha
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

----- End forwarded message -----


