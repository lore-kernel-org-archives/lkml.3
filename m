Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3KOGtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:49:53 -0500
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:47218
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab3KOGtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:49:47 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Fri, 15 Nov 2013 14:40:09 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <timur@tabi.org>, <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <linux@arm.linux.org.uk>, <ijc+devicetree@hellion.org.uk>,
        <swarren@wwwdotorg.org>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: imx: specify the value of audmux pinctrl
 instead of 0x80000000
Message-ID: <20131115064009.GD745@MrMyself>
References: <1384427230-979-1-git-send-email-b42378@freescale.com>
 <1384427230-979-2-git-send-email-b42378@freescale.com>
 <20131115064159.GG11014@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131115064159.GG11014@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 02:42:01PM +0800, Shawn Guo wrote:
> On Thu, Nov 14, 2013 at 07:07:09PM +0800, Nicolin Chen wrote:
> > We must specify the value of audmux pinctrl if we want to use pinctrl_pm().
> > Thus change bypass value 0x80000000 to what we exactly need.
> > 
> > This patch also seperately unset PUE bit for TXD so that IOMUX won't pull
> > up/down the pin after turning into tristate. When we use SSI normal mode to
> > playback monaural audio via I2S signal, there'd be a pulled curve occur to
> > its signal at the second slot if setting PUE bit for TXD. And it will make
> > the second channel to play a constant noise. So by keeping the signal level
> > in the second slot, we can get a constant high level signal (-1) or a low
> > level one (0).
> > 
> > Signed-off-by: Nicolin Chen <b42378@freescale.com>
> > ---
> >  arch/arm/boot/dts/imx6qdl.dtsi | 22 +++++++++++-----------
> >  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> We have moved all pin groups settings into
> arch/arm/boot/dts/imx6qdl-pingrp.h.  I just rebased and applied the
> patch.  Please check my imx/dt branch and ensure I applied the changes
> correctly.

Simply perfect. Thank you.
Nicolin

---


