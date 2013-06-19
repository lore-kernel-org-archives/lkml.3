Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3FSTBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:01:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab3FSTBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:01:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Wed, 19 Jun 2013 21:01:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com> <20130619174047.GB1403@sirena.org.uk> <3697657.tZFV7pR81Q@flatron>
In-Reply-To: <3697657.tZFV7pR81Q@flatron>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306192101.34102.arnd@arndb.de>
X-Provags-ID: V02:K0:M1hmdUDOrOAEAnWawHk5BKMwks1GI1FQLmmVV4ZSwq1
 cKl2bqEZlPYR0ZD+mdAJCCpuQ6LuPQQuqwJU0iWG9T/uUgqqiN
 AMFytVloytVx84I4BDMNXG5W44aa6zU85NFGVNN37OfdVO7BfY
 f4TyXZiSsPF4+yjLoXVC8mLILrTYEQyiPBzGrPC4QJ8WLdLM3p
 EWGqgTxXHe7X+hQ+Su/HYpclI6MzSQnRM9EsB/zu1up+taXYR6
 mxGsh7cdVSdIeFRsLnnjwbh7BOVal4ksB4C1ycHiwtQUG+1IHO
 ilT4O9Mk/IJ5ZrR6G9Idkd9uLmXqCJx2UjP5C91sEw0NjwrBGI
 p7iCUdtawMNl3VhlIQ44=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Tomasz Figa wrote:
> On Wednesday 19 of June 2013 18:40:47 Mark Brown wrote:
> > On Sun, Jun 16, 2013 at 10:54:07PM +0200, Tomasz Figa wrote:
> > > One of the biggest roadblocks on the way of S3C64xx to DeviceTree
> > > support is its DMA driver, which is completely platform-specific and
> > > provides private API (s3c-dma), not even saying that its design is
> > > completely against multiplatform-awareness.
> > 
> > I tried to test this on my s3c64xx based system but it gave me a kernel
> > that didn't boot far enough to give console output (there's some early
> > init stuff that uses SPI...).  That said, I needed:
> > 
> > diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> > index 210a893..0f49707 100644
> > --- a/drivers/dma/amba-pl08x.c
> > +++ b/drivers/dma/amba-pl08x.c
> > @@ -313,7 +313,7 @@ static int pl08x_request_mux(struct pl08x_dma_chan
> > *plchan) int ret;
> > 
> >       if (plchan->mux_use++ == 0 && pd->get_signal) {
> > -             ret = pd->get_signal(plchan->cd);
> > +             ret = (pd->get_signal)(plchan->cd);
> 
> Hmm, that's strange. The former is a completely valid piece of code...

get_signal is a macro defined in include/linux/signal.h. If that header
gets included, neither of the two is valid.

	Arnd
