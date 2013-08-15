Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3HOLu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:50:56 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42392 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3HOLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:50:53 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Jaroslav Kysela <perex@perex.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>, Roland Stigge <stigge@antcom.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Rob Herring <rob.herring@calxeda.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH 00/18] ARM: s3c64xx: Let amba-pl08x driver handle DMA
Date: Thu, 15 Aug 2013 13:50:43 +0200
Message-ID: <59851253.P5uJVeRAXe@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.6-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12514744.ftxC8f7FXa"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart12514744.ftxC8f7FXa
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

[Ccing maintainers and other people responsible for spear, lpc32xx and 
versatile platforms]

On Sunday 11 of August 2013 19:59:12 Tomasz Figa wrote:
> This is first non-RFC version of my patches extending support of
> amba-pl08x DMA engine driver to PL080S DMA engine (PL080 modified by
> Samsung) found in Samsung S3C64xx SoCs.
> 
> Due to changes scattered across different areas of kernel, patches are
> based on merged 3 branches:
>  - for-next of Kgene's Samsung tree,
>  - clk-next of Mike's clock tree,
>  - next of Vinod's slave DMA tree.
> 
> To ease testing I have prepared a branch in my private tree for anyone
> willing to check the patches out:
> 	git://github.com/tom3q/linux.git v3.12-pl080
> 
> Dependencies (already applied in my branch):
>  - for patches 14 and 16 - CCF-based clock driver for s3c64xx.
> 
> Some of the patches not related to the amba-pl08x driver itself
> can be likely applied into appropriate trees separately, namely:
>  - 09/18 - ASoC: Samsung: Do not queue cyclic buffers multiple times,
>  - 14/18 - clk: samsung: s3c64xx: Add aliases for DMA clocks.
> 
> After patch 14/18, both old and new DMA drivers can be supported on
> S3C64xx, depending on Kconfig options. Patches 15-18 remove the old
> driver leaving support only for the generic pl08x driver. Feel free to
> drop those patches for now if we want more testing, but I don't suspect
> any problems.
> 
> On S3C64xx-based Mini6410 and SMDK6410 boards, with I2S audio
> playback and capture (including full duplex operation) and also SPI
> using spidev:
> 
> Tested-by: Tomasz Figa <tomasz.figa@gmail.com>

It would be nice if patches from this series touching the PL08x driver 
(01-08) could be tested on other platforms that have this DMA controller 
as well, to make sure I did not break anything. Unfortunately I do not 
have any board based on any of them.

Best regards,
Tomasz

> Changes since RFC v2:
>  - Added clkdev lookups to old clock driver.
>  - Added patches removing the old DMA driver and any remaining code
>    needed by it.
>  - Fixed DMA support for SPI.
>  - Added a word about PL080S to amba-pl08x.c file header.
>  - Changed definition of LLI words from enums to macros.
>  - Extended debugging messages to handle PL080S variant as well.
>  - Little cleanup of LLI dumping code.
>  - Added check for peripheral flow control, which is unsupported by
>    PL080S to dma_set_runtime_config.
>  - Corrected transfer size mask of PL080S.
> 
> Changes since RFC v1:
>  - Returned to original way of storing quirks as booleans, as suggested
>    by Russell, Linus and Arnd.
>  - Added reg_config field to pl08x_phy_chan struct, which stores
>    variant-specific address of channel config register, as suggested
>    by Russell.
>  - Simplified handling of extended maximum transfer size of PL080S
>    (no more conditional passing of 0 as length to pl08x_cctl_bits()).
>  - Reworked LLI handling in the driver to stop casting arbitrary memory
>    to a struct and allow different word count of LLI entry, as suggested
> by Linus.
>  - Removed AMBA ID override from S3C64xx PL080 initialization code.
>  - Fixed brokenness of Samsung DMA wrapper API, which caused cyclic
> buffers to be queued multiple times when DMA engine is used.
>  - Included patch adding clock aliases for DMA engines (depends on
>    Common Clock Framework driver for S3C64xx).
>  - Fixed several minor stylistic issues.
> 
> For reference, here is the original description of the series:
> 
> One of the biggest roadblocks on the way of S3C64xx to DeviceTree
> support is its DMA driver, which is completely platform-specific and
> provides private API (s3c-dma), not even saying that its design is
> completely against multiplatform-awareness.
> 
> The DMA controller present on this SoC series is a custom variant
> of ARM PrimeCell PL080 modified by Samsung to add some extra features.
> It is mostly compatible with original PL080, except:
>  - CH_CONTROL2 register is added between CH_CONTROL and CH_CONFIG,
>  - offset of CH_CONFIG register is different,
>  - transfer size field is moved from CH_CONTROL to CH_CONTROL2,
>  - transfer size field is extended to 24 bits, allowing much bigger
>      single transfer,
>  - LLI consists of one more word, to account for CH_CONTROL2 register.
> 
> Since all the rest is fully compatible with standard PL080 there is no
> point in having separate driver just for this single variant, so I
> decided to look into adding support for it to the amba-pl08x driver.
> 
> There was already some attempt to achieve this before, but this was
> before Russel's big rework of the driver to use virtual channels,
> making the old patches being not much of use.
> 
> This RFC series is a proof of concept that I managed to make during last
> days of hacking. Except one patch adding clkdev lookup to clock driver
> (which is being replaced with a CCF-compliant driver ATM), this is
> enough to get memcpy and slave transfers to work on S3C64xx.
> 
> I have tested this on Mini6410 and SMDK6410 boards using dmatest for
> memcpy and Samsung I2S with madplay/aplay for slave transfers.
> Unfortunately I do not have access to other platforms with PL08x so
> I could not test for any regressions introduced on them.
> 
> Credits for two patches go to Alban Bedel, who made a series fixing this
> driver to make it usable with audio drivers. I rebased his patches on
> top of mine and corrected coding style a bit.
> 
> OK, that's all. Any comments are welcome. Feel free to start throwing
> eggs and tomatoes if you find this awful, but I won't be upset if I get
> some Tested-by or Acked-by as well. ;)
> 
> Alban Bedel (2):
>   dmaengine: PL08x: Fix reading the byte count in cctl
>   dmaengine: PL08x: Add cyclic transfer support
> 
> Tomasz Figa (16):
>   dmaengine: PL08x: Refactor pl08x_getbytes_chan() to lower indentation
>   dmaengine: PL08x: Add support for different offset of CONFIG register
>   dmaengine: PL08x: Rework LLI handling to be less fragile
>   dmaengine: PL08x: Move LLI dumping code into separate function
>   dmaengine: PL08x: Add support for PL080S variant
>   dmaengine: PL08x: Add support for different maximum transfer size
>   ASoC: Samsung: Do not queue cyclic buffers multiple times
>   spi: s3c64xx: Do not require legacy DMA API in case of S3C64XX
>   ASoC: Samsung: Do not require legacy DMA API in case of S3C64XX
>   ARM: s3c64xx: Add support for DMA using generic amba-pl08x driver
>   ARM: s3c64xx: clock: Add clkdev lookup for DMA clocks
>   clk: samsung: s3c64xx: Add aliases for DMA clocks
>   ARM: s3c64xx: Remove legacy DMA driver
>   clk: samsung: s3c64xx: Remove clock aliases of old DMA driver
>   spi: s3c64xx: Always select S3C64XX_PL080 when ARCH_S3C64XX is enabled
> ASoC: Samsung: Always select S3C64XX_PL080 when ARCH_S3C64XX is enabled
> 
>  arch/arm/Kconfig                         |   1 +
>  arch/arm/mach-s3c64xx/Kconfig            |   7 +-
>  arch/arm/mach-s3c64xx/Makefile           |   2 +-
>  arch/arm/mach-s3c64xx/clock.c            |  28 +-
>  arch/arm/mach-s3c64xx/common.h           |   5 +
>  arch/arm/mach-s3c64xx/dma.c              | 753
> -------------------------------
> arch/arm/mach-s3c64xx/include/mach/dma.h | 144 ++----
>  arch/arm/mach-s3c64xx/pl080.c            | 244 ++++++++++
>  arch/arm/plat-samsung/devs.c             |   6 +-
>  arch/arm/plat-samsung/s3c-dma-ops.c      |  13 +-
>  drivers/clk/samsung/clk-s3c64xx.c        |   4 +-
>  drivers/dma/amba-pl08x.c                 | 501 ++++++++++++++------
>  drivers/spi/Kconfig                      |   2 +-
>  include/linux/amba/pl080.h               |   1 +
>  sound/soc/samsung/Kconfig                |   2 +-
>  sound/soc/samsung/dma.c                  |   7 +
>  16 files changed, 705 insertions(+), 1015 deletions(-)
>  delete mode 100644 arch/arm/mach-s3c64xx/dma.c
>  create mode 100644 arch/arm/mach-s3c64xx/pl080.c
--nextPart12514744.ftxC8f7FXa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABAgAGBQJSDMCXAAoJEIv3Hb8G/XruurEQAI5MZZZOXGQLios4lb3lAT3p
Y3GQLErlJmozSQNzgdlGsiI2Ot+7J8w9aFR1jud6YF6yU8oU+xWoqfDwANxrKHXr
dWEhXaK2K2rtAJKFwK8ezG2FgBprDEmMPOI8LIc8m3IuocMwtqxyBaILr8YEe20z
HrzrEPGNdIEHUmYQgP/K6SLJ8HUZ2IJP5Lf6JTRGQD83SOy21uhcASgIg5h6+JY7
3XNJpNg6TC+nxlZHhJMVbDbblLtAiMpq08UqQwQpdGugWGuuYhOavhhpmM2d/gZm
YBha93AdkvGAGOdoom0luvqbpEvsiKyD7mYape8b0uhy58hDdR1MbQEITLhPkV8e
8s+pffZh3owWjmRc513MZi28rXNF5BsJ64KMAM5NnMIMqj5Ez6RfIAeUZ3pQAGzH
lwWnXbGzDC0LXNDxI2M3az3odWQcuCwWodfOeX2VXgjAXQJOzV8g9QVqP/PMDIaS
ZD/2fDcv5j3MX2J4bQL7umEIYQG/xvmjYJXYYOFBNBby4GzEIUHjE7gY7BtkWhXx
FTWZ+yEgmSpri5VImftIP2Z4X87khS36bGVeK6DgpRRTWOLdLImXxwilPLPjaPse
Y26CZGOCFOCKfcgFjpO+668c6ZntlL488BuKFm467tCqVA9NlJZOJVubHFUPNxRK
HKNmER3pxfdCSvYNkFr+
=oYwl
-----END PGP SIGNATURE-----

--nextPart12514744.ftxC8f7FXa--

