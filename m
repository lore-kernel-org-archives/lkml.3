Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3FYPoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:44:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10096 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:44:10 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-a8-51c9bac7f2ba
From: Tomasz Figa <t.figa@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
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
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [RFC PATCH v2 00/12] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Tue, 25 Jun 2013 17:44:06 +0200
Message-id: <1486283.2pMLZtfT9J@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <20130625153843.GF27646@sirena.org.uk>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
 <6520269.XdaOpEg0Ud@amdc1227> <20130625153843.GF27646@sirena.org.uk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA02SXUhTYRjHec/ZOTuOVsel9iJKNj9KSUsyeI2QLhRekUJvivLClg5dOB2b
	mprQ1DQnpmaaMkQmWpldqLNyijpZsakRfswptpLSLMSP0kl+a8514d3vefg9///Nw5CCKY47
	I0lJE8tTRMlCmsf5uGuyBJq6BmLO/5n1R7saGweNjRgItFNh5KKq7z9o1F72jUamZzsE6tvW
	AbQ3PU+hxxoLjf6OFRGocvslgbQz4xQyd9XSqGaol0C5y5NcZDXz0eCEjUZbk2s0UnWVUWhr
	IB6NNK0SqM7WSSBjTSNAc+0LBGru2t6nUj3nijtuteXR+GF+CY23NisALq200PhJ/hIXd6q/
	cvHbgj4KN3TPEVjbrKLxl/FuGrc3PsBj/XkU7l18QePSN80Ad4zXkXh2vYeMFtziXU4QJ0sy
	xPJzYbd5Sb8+qShZrVNmtcpKKUEetxg4MZANgTOvNjgOdoPDUy10MeAxAvY5gMrqUa5jKCbg
	Rp2etFs06wdtymnazi6sN7Ss9Rxck+wIF04WhNj5OBsNJ+qHKTtzWF+4smDYD2IYPusPO8w5
	9vUx9jRcejdL2NmVjYC/X78/iHFiL8Aemw44eksAnDc8Oujis85w/enU/66TsFdfRTk4ALZ0
	mohy4Kw+pKkPaepDmgaQzcBVnB4vU9xJlAYHKURSRXpKYlB8qlQLHD+xqgMNxksGwDJAeITf
	rx2IEVCiDEWW1AAgQwpd+Ia7+yt+gigrWyxPjZOnJ4sVBkAwTu5KIPmwwho9Tsj02UOecRt7
	c7jIK7Y/82brjUk/r4vofuRQOFV4ZrOW1H8uD4wyVoUGli3qIljeWatPfdpem6RvwmoLW7oe
	PqbJ9fGsDCr0LRwFy3JJlKjc0210NRetaSNJ33lh2ymuounq4D1NqN4c600KZddERz2sP6uE
	OUKOIkkUHEDKFaJ/MnTjSPECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 of June 2013 16:38:43 Mark Brown wrote:
> On Tue, Jun 25, 2013 at 01:22:20PM +0200, Tomasz Figa wrote:
> > On Tuesday 25 of June 2013 11:28:18 Mark Brown wrote:
> > > On my non-DT s3c64xx system I get this when trying to use SPI for the
> > 
> > > first time:
> > Could you clarify first time? Does it work on further retries?
> 
> No, the system appears to lock up fairly solidly - I suspect poor error
> handling in the SPI driver.
> 
> > > [    1.739385] s3c64xx-spi s3c6410-spi.0: Failed to get RX DMA
> > > channel
> > > [    1.743437] spi_master spi0: failed to prepare transfer hardware
> > > 
> > > though I haven't yet tried your clock patches (there were some
> > > conficts
> > > that I didn't get round to picking up yet).
> > 
> > This shouldn't really matter, as long as the pl080 drivers probes
> > correctly.
> 
> Indeed, I was wondering if it was failing to probe due to not getting
> its clocks though since that's another area you've been actively working
> on.

Let me check if I can get something with SPI interface that I would be able 
to connect to my board at home and do some testing.

Best regards,
Tomasz

