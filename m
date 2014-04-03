Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbaDCD0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 23:26:05 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:53414
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758899AbaDCD0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 23:26:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Thu, 3 Apr 2014 11:11:18 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH] ASoC: fsl_sai: Add imx6sx platform support
Message-ID: <20140403031116.GA31246@MrMyself>
References: <1396352049-23554-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140402195208.GM14763@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140402195208.GM14763@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 08:52:08PM +0100, Mark Brown wrote:
> On Tue, Apr 01, 2014 at 07:34:09PM +0800, Nicolin Chen wrote:
> > The next coming i.MX6 Solo X SoC also contains SAI module while we use
> > imp_pcm_init() for i.MX platform.
> 
> I've applied this, though obviously it'd be better if we had dmaengine
> support for this SoC so that it was just a compatible string update and
> didn't require any code.

Hmm...actually imx_pcm_init() is just a shell calling dmaengine while it
has its own config and flags. So we still need to extinguish these two
elements for them even if using devm_snd_dmaengine_pcm_register() eventually.

But the idea to merge them into one entry should be great for 3rd platform
or even further one. And a patch for imx-pcm-dma and all callers of it
would be needed then.

Thank you,
Nicolin

