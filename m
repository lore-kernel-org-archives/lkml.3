Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3FYLW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:22:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17812 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3FYLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:22:24 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-dc-51c97d6d4d29
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
Date: Tue, 25 Jun 2013 13:22:20 +0200
Message-id: <6520269.XdaOpEg0Ud@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <20130625102818.GA27646@sirena.org.uk>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
 <20130625102818.GA27646@sirena.org.uk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHeb/te/dNGn0utTehgnWiQZYo8SIhQkTfVWgXXXiRLl1quGn7
	mqZgnpI8a56wecDQsialTHNuOJUZczMwxTmR1NQ8JKk1Jyo6NadeePd7/vye53/zUBzhBNeb
	ipE/kyrkklgRdON+2+2zXZOlWEJu5FWcwbt1Di62DhkJvFNi4uHy6VmIW4umIO6r2CFwj7MD
	4L2ZPyQuqBuBeN2aTeAyZyOBNb9sJB7WV0Nc+b2LwOn2MR7+MSzA/aMOiLfHNiDO0ReReNsS
	gYc+rBG41qEjsKmyAeDF1iUCq/XOfSrs5gZ5My2ODMi8zMyHzPZWCWAKy0Yg8zpzhcfoVBM8
	5ktWD8nUdy4SjEadA5lxWydkWhtSGas5g2S6lt9DprBNDRitrZbDzG0aOMHCULdbkdLYmASp
	4npguFv07Kc9XvwufP7Z8hukAS2ZC/gUov3R8M8C3iF7ocHJZpgL3Cgh/Q6gf1u2oyGXQP2O
	nAML0peRI20GutiDvoBGNgxcF3PoIR4ay/J38Sk6GI2+HdxvoCgufQnZlrArFtBX0SvLxwP9
	JH0FrbTPES72pO+gv029Bzmf9kPti9UH54W0HI1n2eHhrjvaLJ08qjqPurrLyUMWo2ZdH1EM
	3FXHNNUxTXVMqwMcNfCUKiPi2UdRMl8fViJjlfIon4g4mQYcvsRaB6g3BRgBTQHRCYH9oTlE
	SEoS2CSZESCKI/IQGJ9YQoSCSElSslQRF6ZQxkpZIyAovnca8FGwC+159+xfH4yUsoERUdKo
	/BdLFLvVERRwt39dk51QsJqa3KKdG2etVQZDs2mxKVQnXhUo/fRT4S08SWXixrlHicPa2Hlx
	SI11Ib+8hh9T1qebMIad9Xiqc6p6573avC6mFJ9WNJKRNx9X1bwxDxRJzbcn7nsOtOylTy+L
	uGy0xFfMUbCS/4asfT7wAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for testing this series.

On Tuesday 25 of June 2013 11:28:18 Mark Brown wrote:
> On Sat, Jun 22, 2013 at 10:42:32PM +0200, Tomasz Figa wrote:
> > This is another version of my patches extending support of amba-pl08x
> > DMA engine driver to PL080S DMA engine (PL080 modified by Samsung)
> > found
> > in Samsung S3C64xx SoCs.
> 
> On my non-DT s3c64xx system I get this when trying to use SPI for the
> first time:

Could you clarify first time? Does it work on further retries?

> [    1.739385] s3c64xx-spi s3c6410-spi.0: Failed to get RX DMA channel
> [    1.743437] spi_master spi0: failed to prepare transfer hardware
> 
> though I haven't yet tried your clock patches (there were some conficts
> that I didn't get round to picking up yet).

This shouldn't really matter, as long as the pl080 drivers probes 
correctly.

Best regards,
Tomasz

