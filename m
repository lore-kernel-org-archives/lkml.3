Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3KODBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:01:41 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:31542
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab3KODBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:01:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 15 Nov 2013 11:02:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolin Chen <b42378@freescale.com>
CC: <timur@tabi.org>, <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <linux@arm.linux.org.uk>, <ijc+devicetree@hellion.org.uk>,
        <swarren@wwwdotorg.org>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>
Subject: Re: [PATCH 0/2] Add monaural audio support for fsl_ssi.c
Message-ID: <20131115030247.GC11014@S2101-09.ap.freescale.net>
References: <1384427230-979-1-git-send-email-b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1384427230-979-1-git-send-email-b42378@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 07:07:08PM +0800, Nicolin Chen wrote:
> This series of patches need to be applied into one single tree because
> the second patch depends on the first one. Without it, SSI would playback
> constant noise to the right channel when playback monaural audio files on
> i.MX6 Series board.

Let me try to understand if the dependency is true.

Saying I apply the DTS patch on IMX tree while Mark apply the fsl_ssi
patch on his tree, will there be any regression on either IMX tree or
Mark's tree?  The monaural playback on imx6qdl never worked, so it's not
a regression.  If there is no regression on either tree, there is no
dependency to maintain.

Shawn

> 
> We might also need to apply the iomux change to the other i.MX platforms,
> just currently I don't have those boards so I drop their changes for now.
> 
> Nicolin Chen (2):
>   ARM: dts: imx: specify the value of audmux pinctrl instead of
>     0x80000000
>   ASoC: fsl_ssi: Add monaural audio support for non-ac97 interface
> 
>  arch/arm/boot/dts/imx6qdl.dtsi | 22 +++++++++++-----------
>  sound/soc/fsl/fsl_ssi.c        | 22 +++++++++++++++++++---
>  2 files changed, 30 insertions(+), 14 deletions(-)
> 
> -- 
> 1.8.4
> 
> 

