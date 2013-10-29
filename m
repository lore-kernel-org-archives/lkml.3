Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3J2AQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:16:09 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:43586
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007Ab3J2AQG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:16:06 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Mon, 28 Oct 2013 17:15:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmc: arasan: Add driver for Arasan SDHCI
References: <1381864085-8806-1-git-send-email-soren.brinkmann@xilinx.com>
 <526EF149.8060304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <526EF149.8060304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-ID: <ff1f2d38-4185-49f0-8b63-b3bd2b4f9a27@CO9EHSMHS024.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 06:20:41PM -0500, Rob Herring wrote:
> On 10/15/2013 02:08 PM, Soren Brinkmann wrote:
> > Add a driver for Arasan's SDHCI controller core.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  .../devicetree/bindings/mmc/arasan,sdhci.txt       |  23 +++
> >  MAINTAINERS                                        |   1 +
> >  drivers/mmc/host/Kconfig                           |  12 ++
> >  drivers/mmc/host/Makefile                          |   1 +
> >  drivers/mmc/host/sdhci-of-arasan.c                 | 224 +++++++++++++++++++++
> >  5 files changed, 261 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
> >  create mode 100644 drivers/mmc/host/sdhci-of-arasan.c
> > 
> > diff --git a/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt b/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
> > new file mode 100644
> > index 000000000000..20f0fc25e270
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
> > @@ -0,0 +1,23 @@
> > +Device Tree Bindings for the Arasan SDCHI Controller
> > +
> > +  The bindings follow the mmc[1] and the clock bindings[2]. Only deviations are
> > +  documented here.
> > +
> > +  [1] Documentation/devicetree/bindings/mmc/mmc.txt
> > +  [2] Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +
> > +Required Properties:
> > +  - compatible: Compatibility string. Must be 'arasan,sdhci'
> 
> This string is a bit non-specific. Vendor IP typically has configurable
> options, different revs of IP with fixes/differences, and the
> possibility of integration wierdness or bugs. So it is better to be as
> specific as possible in case the kernel needs to know exactly what
> version of h/w this is.
Okay. The Zynq TRM specifies the version as '8.9A_apr02nd_2010', which seems
a little overly specific to me. How does 'arasan,sdhci-8.9a' sound to
you?

	Thanks,
	Sören


