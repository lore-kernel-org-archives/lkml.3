Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbaAJRHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:07:05 -0500
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:18885
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757593AbaAJRG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:06:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h1155h)
Date: Sat, 11 Jan 2014 00:45:44 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <timur@tabi.org>, <alsa-devel@alsa-project.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <grant.likely@linaro.org>, <shawn.guo@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2] ASoC: fsl_esai: Add ESAI CPU DAI driver
Message-ID: <20140110164543.GB17609@MrMyself>
References: <1389265078-16256-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109184453.GP12858@sirena.org.uk>
 <20140110023252.GA16467@MrMyself>
 <20140110023537.GB16467@MrMyself>
 <20140110120439.GG29039@sirena.org.uk>
 <20140110130338.GA17392@MrMyself>
 <20140110132642.GM29039@sirena.org.uk>
 <20140110154824.GA17609@MrMyself>
 <20140110165229.GP29039@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140110165229.GP29039@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:52:29PM +0000, Mark Brown wrote:
> On Fri, Jan 10, 2014 at 11:48:25PM +0800, Nicolin Chen wrote:
> 
> > I think I start to understand the point here: If a user only needs to playback
> > the default case - 44.1KHz for example, the driver can just configure all the
> > dividers once at the beginning, not every time, so that we can save further
> > register overriding operation or even complicated clock selection and divisor
> > calculation, which obviously makes the procedure clean and reduces the system
> > loading even if it might be just in a slight level.
> 
> > Is this the reason, or maybe one of the reasons, to the defaults providing?
> 
> The main thing is that if the DAI driver does it then it's less code in
> the machine drivers using it - what tends to happen otherwise is that
> quite a few machine drivers end up replicating the same logic.  Hardware
> designers tend to do a lot of cut'n'paste with these things so even if
> the CODEC is different the clocking is often very similar.

Point taken. And it also depends on how common the defaults would be.
I think I should try to figure out a comparably generic template for
the clock selection and its rate settings here and also check other
redundant places.

I learned another lesson today. Thank you indeed.
Nicolin

