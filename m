Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3HLXuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:50:01 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46719 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3HLXt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:49:59 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 10/18] spi: s3c64xx: Do not require legacy DMA API in case of S3C64XX
Date: Tue, 13 Aug 2013 01:49:53 +0200
Message-ID: <2472314.6b8DcBdcjO@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.5-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130812233641.GL6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com> <1376243970-6489-11-git-send-email-tomasz.figa@gmail.com> <20130812233641.GL6427@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 of August 2013 00:36:41 Mark Brown wrote:
> On Sun, Aug 11, 2013 at 07:59:22PM +0200, Tomasz Figa wrote:
> > With support for amba-pl08x driver, on S3C64xx the generic DMA engine
> > API can be used instead of the private s3c-dma interface.
> 
> I'm still getting issues for SPI with this:
> 
> [   50.952845] s3c64xx-spi s3c6410-spi.0: Failed to get RX DMA channel
> [   50.953520] spi_master spi0: failed to prepare transfer hardware
> 
> when I test (with -next with this series applied on top), this is from
> the first transfer that tries to DMA - there's actually no RX data.  No
> errors are reported by the DMA controller itself.  I'm also getting
> crashes setting up the audio DMA while derferencecing the channel.
> 
> This is without DT - are there any hookups missing because of that?

Hmm, strange.

I've been testing this without any significant patches, like PWM, CCF or 
DT support, just everything from the branch I pointed to and some board-
specific patches to help in debugging.

Anyway, this is the exact branch I've been using:

git://github.com/tom3q/linux.git v3.12-pl080-devel

Best regards,
Tomasz

