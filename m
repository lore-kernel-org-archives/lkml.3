Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3HKXD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 19:03:29 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40374 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab3HKXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 19:03:26 -0400
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
Subject: Re: [PATCH 17/18] spi: s3c64xx: Always select S3C64XX_PL080 when ARCH_S3C64XX is enabled
Date: Mon, 12 Aug 2013 01:03:19 +0200
Message-ID: <2033369.1oHkX7kdGa@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.5-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130811191140.GI6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com> <1376243970-6489-18-git-send-email-tomasz.figa@gmail.com> <20130811191140.GI6427@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sunday 11 of August 2013 20:11:40 Mark Brown wrote:
> On Sun, Aug 11, 2013 at 07:59:29PM +0200, Tomasz Figa wrote:
> > @@ -366,7 +366,7 @@ config SPI_S3C24XX_FIQ
> > 
> >  config SPI_S3C64XX
> >  
> >  	tristate "Samsung S3C64XX series type SPI"
> >  	depends on (ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5P64X0 ||
> >  	ARCH_EXYNOS)> 
> > -	select S3C64XX_DMA if ARCH_S3C64XX && !S3C64XX_PL080
> > +	select S3C64XX_PL080 if ARCH_S3C64XX
> > 
> >  	help
> >  	
> >  	  SPI driver for Samsung S3C64XX and newer SoCs.
> 
> Do we need the select here (or should we have other selects for the
> Exynos SoCs)?

The driver would build fine without this symbol selected, but since it 
relies on availability of DMA, it doesn't make too much sense to build it 
this way. This kind of selects makes kernel configuration more user 
friendly IMHO.

Possibly adding appropriate selects (PL330) for s5p* and exynos could make 
sense.

Best regards,
Tomasz

