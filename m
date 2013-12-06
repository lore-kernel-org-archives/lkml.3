Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab3LFPMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:12:13 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:5855
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab3LFPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:12:10 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Fri, 6 Dec 2013 22:52:40 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <swarren@wwwdotorg.org>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ASoC: fsl: imx-wm8962: Add headphone and microphone
 jack plugin/out detection
Message-ID: <20131206145239.GA30024@MrMyself>
References: <cover.1386322845.git.b42378@freescale.com>
 <82d3285b7efe1f98dbc3d9c0a423b2e5e454481f.1386322845.git.b42378@freescale.com>
 <20131206144256.GI29268@sirena.org.uk>
 <20131206143817.GB29975@MrMyself>
 <20131206150319.GJ29268@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131206150319.GJ29268@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 03:03:19PM +0000, Mark Brown wrote:
> On Fri, Dec 06, 2013 at 10:38:17PM +0800, Nicolin Chen wrote:
> > On Fri, Dec 06, 2013 at 02:42:56PM +0000, Mark Brown wrote:
> 
> > > What's this uevent trying to do and why is it open coded in the driver?
> 
> > That's a requirement from Android team of Freescale. By checking this
> > event they can determine whether current output is speaker or headphone
> > so as to place an icon on the notification area.
> 
> > Sir, if you think this patch is not common enough or non-community style,
> > I can try to cut it down to an common one or entirely drop it.
> 
> This isn't mainline stuff, this is the Android standard switch class.
> Someone should really contribute something to Android which backs it
> onto the back of ALSA jacks.  The mainline equivalent is extcon which
> does have switch class emulation but it's a bit broken in its generation
> of uevents and is also not yet integrated into the ALSA jack stuff.
> 
> The thing to do is ideally integrate extcon with the ALSA jack code and
> update the Android headset observer to work with extcon (or write a
> separate extcon based observer).

Thank you for the detailed explain. It looks more complicated to me with
current code base. I think I should just extract the mainline-style part
so it'll make things easy if there's gonna be some plausible integrations
afterward.

Thank you indeed,
Nicolin Chen


