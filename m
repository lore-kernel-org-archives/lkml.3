Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab3FSTcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:32:53 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42410 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935087Ab3FSTcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:32:51 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Wed, 19 Jun 2013 21:32:44 +0200
Message-ID: <5443580.A5iCQBtp1T@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.6-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <20130619192211.GH1403@sirena.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com> <3697657.tZFV7pR81Q@flatron> <20130619192211.GH1403@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 of June 2013 20:22:11 Mark Brown wrote:
> On Wed, Jun 19, 2013 at 08:26:12PM +0200, Tomasz Figa wrote:
> > On Wednesday 19 of June 2013 18:40:47 Mark Brown wrote:
> > > -		ret = pd->get_signal(plchan->cd);
> > > +		ret = (pd->get_signal)(plchan->cd);
> > 
> > Hmm, that's strange. The former is a completely valid piece of code...
> 
> I know, hence...
> 
> > > to get it to build which makes me suspect the compiler a bit as
> > > well...
> 
> ...my comment about suspecting the compiler.
> 
> > > I was applying this to -next, are there any other dependencies I
> > > need or anything?
> > 
> > Hmm, I've been testing this on top of my common clock framework and
> > device tree patches, but I don't think this had any effect. Did you
> > add necessary clkdev lookups to the clock driver?
> 
> No, I didn't - that's most likely it, I didn't really investigate.  I
> didn't test the watchdog stuff as the clocks didn't get sent to me.

I always try to keep you on Cc of my patches for s3c64xx, as you are the 
most active user of this platform (if not the only one other than me) and 
this was the case for clock patches as well, just checked that.

Seems like I forgot to add you to watchdog patches, sorry. But you didn't 
miss anything, since they were rather trivial ones.

> > In Samsung CCF alias notation it looks like this:
> > 
> > +       ALIAS(HCLK_DMA1, "dma-pl080s.1", "apb_pclk"),
> > +       ALIAS(HCLK_DMA0, "dma-pl080s.0", "apb_pclk"),
> > 
> > Not sure how hard it will be to add such lookups to the old clock
> > driver, though.
> 
> It's pretty much the same providing you know which clock needs to be
> used.
> 
> > I will test this applied directly on top of current linux-next when I
> > find some time, but for now you might check out my v3.11-devel branch
> > on my github:
> > 
> > https://github.com/tom3q/linux.git
> 
> Will try to get round to it.

OK.

Best regards,
Tomasz

