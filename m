Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaBYD6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:58:09 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:57149
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbaBYD6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:58:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371Ie0eah1432Ic540Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hz8dhz1de098h8275bh8275dh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 11:55:59 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Mark Brown <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Austin, Brian" <Brian.Austin@cirrus.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: cs42888: Add codec driver support
Message-ID: <20140225035558.GA7393@MrMyself>
References: <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
 <20140225000027.GI25940@sirena.org.uk>
 <20140225023840.GB7229@MrMyself>
 <20140225030947.GO25940@sirena.org.uk>
 <20140225031313.GA7343@MrMyself>
 <20140225033929.GP25940@sirena.org.uk>
 <20140225034635.GB7343@MrMyself>
 <CAOMZO5B8J-Fsv6BkeAQAneu1yf6vC-tV74VB-D6JPA1PPjd99Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOMZO5B8J-Fsv6BkeAQAneu1yf6vC-tV74VB-D6JPA1PPjd99Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 12:54:04AM -0300, Fabio Estevam wrote:
> Hi Nicolin,
> 
> On Tue, Feb 25, 2014 at 12:46 AM, Nicolin Chen
> <Guangyu.Chen@freescale.com> wrote:
> >> So register it from the ESAI driver then.
> >
> > Then I think I need to find a way to pass the clock to CODEC driver...
> 
> Does this example from mxs-saif help?

Absolutely yes! Thank you in advance :)

> 
> commit 7c9e6150f2e7cbd60e0bc9a19118ca1dc97d2780
> Author: Shawn Guo <shawn.guo@linaro.org>
> Date:   Mon Jul 1 16:16:10 2013 +0800
> 
>     ASoC: mxs: register saif mclk to clock framework
> 
>     Mostly the mxs system design uses saif0 mclk output as the clock source
>     of codec.  Since the mclk is implemented as a general divider with the
>     saif clk as the parent clock, let's register the mclk as a basic
>     clk-divider to common clock framework.  Then with it being a clock
>     provdier, clk_get() call in codec driver probe function will just work.
> 
>     Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>     Signed-off-by: Mark Brown <broonie@linaro.org>
> 
> 


