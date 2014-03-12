Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbaCLCLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:11:32 -0400
Received: from [207.46.163.27] ([207.46.163.27]:6748 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756601AbaCLCL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:11:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 10:01:24 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: Re: [PATCH] ASoC: simple-card: overwrite DAIFMT_MASTER of
 cpu_dai->fmt
Message-ID: <20140312020123.GC1177@MrMyself>
References: <1394542472-16580-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140311132553.GR28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140311132553.GR28112@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 01:25:53PM +0000, Mark Brown wrote:
> On Tue, Mar 11, 2014 at 08:54:32PM +0800, Nicolin Chen wrote:
> 
> Adding Jyri who's been looking at this as well but not added anyone else
> working on simple-card so you might've missed his mails.
> 
> > It's pretty fair to do it for DAIFMT_INV since two dais might have differnt
> > definitions in their drivers even though it'd be better to keep it same if
> > we could.
> 
> No, that's not at all OK - anything that requires this is broken.  The
> same DAI format should be usable by both ends of the link unless the
> board itself is inverting one of the signals or something.

That makes sense to me. Okay, I'll overwrite them all...

> 
> > Thus this patch fixes it by overwriting the DAIFMT_MASTER bit of cpu_dai->fmt
> > with the one of codec_dai->fmt since we defined DAIFMT_MASTER basing on CODEC
> > at the first place.
> 
> This seems closer to what I'd expect for something like this but it does
> mean that any format settings on the CPU DAI will be ignored (rather
> than say warning or something).  I'm not sure this is a bad thing
> though, probably wants the binding documenting at least.

...along with the binding doc.


