Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBYCzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:55:45 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:10735 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbaBYCzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:55:43 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 10:38:41 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "Austin, Brian" <Brian.Austin@cirrus.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
Message-ID: <20140225023840.GB7229@MrMyself>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
 <20140225000027.GI25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140225000027.GI25940@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:00:27AM +0900, Mark Brown wrote:
> On Tue, Feb 25, 2014 at 12:06:49AM +0800, Nicolin Chen wrote:
> > On Mon, Feb 24, 2014 at 03:52:24PM +0000, Austin, Brian wrote:
> 
> > Wait...Regarding this clock part, I just forgot the reason I put the code:
> 
> > 385         cs42888->clk = devm_clk_get(&i2c->dev, "mclk");
> > 386         if (IS_ERR(cs42888->clk))
> > 387                 dev_warn(&i2c->dev, "failed to get the clock: %ld\n",
> > 388                                 PTR_ERR(cs42888->clk));
> 
> > was because the MCLK might be provided from SoC (DAI master) so it could
> > be totally controlled by CPU DAI driver, ESAI for example has its own
> > dividers to derive the HCKT clock (MCLK for Tx) from ahb clock in SoC
> > clock tree, in which case we might not easily pass a valid clock phandle
> > via DT. (RFC to this thought.)
> 
> We should be getting those clocks visible in the clock API rather than
> doing this.

Hmm...my words might not be so clear last time: we have to handle the dividers
of ESAI in ESAI driver because the dividers is in the ESAI's IP, not in the SoC
clock controlling unit. So it's hard to get them visible in the clock tree.

Thank you,
Nicolin



