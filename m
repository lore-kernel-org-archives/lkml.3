Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371Ab3JPJLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:11:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49677 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760044Ab3JPJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:11:03 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-d7-525e582445dc
From: Tomasz Figa <t.figa@samsung.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] clk: s3c64xx: Correct spi bus clock hookups
Date: Wed, 16 Oct 2013 11:10:59 +0200
Message-id: <1625192.kcLGqB93c8@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <20131016081035.GD20219@opensource.wolfsonmicro.com>
References: <1381839982-3026-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1785136.Xbc2LARBDy@flatron>
 <20131016081035.GD20219@opensource.wolfsonmicro.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xy7oqEXFBBr+uqVr8m3KD3WLT42us
	Fpd3zWGzmHF+H5PF0wkX2SyWv/3P5sDmcefaHjaPzUvqPV5O/M3m8XmTXABLFJdNSmpOZllq
	kb5dAlfGxukz2Apu8lcsfriBsYHxFU8XIweHhICJxPyleV2MnECmmMSFe+vZuhi5OIQEljJK
	HNy9iRXC6WKSeLBqBTNIFZuAmsTnhkdsILaIgIXElCW3mEGKmAVWMkos6jsNlhAWcJCY9qCJ
	BcRmEVCVaFk3lxXE5hXQlLh0YDrYIH4BdYl3254ygdiiAm4S038cBItzCjhK9N//zAKxeRWj
	xIOLi9kgmgUlfky+BzaUWUBeYt/+qawQtpbE+p3HmSYwCs5CUjYLSdksJGULGJlXMYqmliYX
	FCel5xrqFSfmFpfmpesl5+duYoSE+pcdjIuPWR1iFOBgVOLhPREVGyTEmlhWXJl7iFGCg1lJ
	hDciOC5IiDclsbIqtSg/vqg0J7X4ECMTB6dUA6P5sRmTiyN7GZf9PHe+17cu4cK6SlMJRxln
	3k6LGtMH2/WvFjz/wS0ps61mTY9Pe6fM+sqSjVvFL58Qijr7kfV+gvX1QyIVqvKRT7VVn3sc
	MHjUvIolvPTH4osXNO7VHwrj585zS9pzqHDd8qkrK1XPqrLmrYmyerB528kEG9kzHwrVL0XO
	f6fEUpyRaKjFXFScCAAZEoi9UwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 of October 2013 09:10:35 Charles Keepax wrote:
> + samsung soc mailing list
> 
> On Wed, Oct 16, 2013 at 12:52:42AM +0200, Tomasz Figa wrote:
> > Hi Charles,
> > 
> > On Tuesday 15 of October 2013 13:26:22 Charles Keepax wrote:
> > >  	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
> > >  	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
> > > -	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi-bus"),
> > > -	ALIAS(SCLK_SPI0, "s3c6410-spi.0", "spi-bus"),
> > > +	ALIAS(PCLK_SPI1, "s3c6410-spi.1", "spi_busclk0"),
> > > +	ALIAS(SCLK_SPI1, "s3c6410-spi.1", "spi_busclk1"),
> > > +	ALIAS(SCLK_SPI1_48, "s3c6410-spi.1", "spi_busclk2"),
> > 
> > ...according to the documentation, the order is different. The SPI_CLKSEL 
> > field of CLK_CFG register of the SPI block can have following values:
> > 0 - PCLK (aka PCLK_SPIx)
> > 1 - USBCLK (aka SCLK_SPIx_48)
> > 2 - Epll clock (aka SCLK_SPIx)
> > 
> > The index after spi_busclk corresponds to the value written to SPI_CLKSEL 
> > field, so your patch should be adjusted accordingly.
> 
> Hmm... will probably need to test this to see what happens the
> old clock setup was this:
> 
> 	CLKDEV_INIT(NULL, "spi_busclk0", &clk_p),
> 	CLKDEV_INIT("s3c6410-spi.0", "spi_busclk1", &clk_sclk_spi0.clk),
> 	CLKDEV_INIT("s3c6410-spi.0", "spi_busclk2", &clk_48m_spi0),
> 	CLKDEV_INIT("s3c6410-spi.1", "spi_busclk1", &clk_sclk_spi1.clk),
> 	CLKDEV_INIT("s3c6410-spi.1", "spi_busclk2", &clk_48m_spi1),
> 
> Which appears to differ from the documentation, that said though
> I would wager that only the first of those has really had much
> testing.

I believe in 90% cases the driver simply used first available clock,
which would be the PCLK, so I wouldn't be really surprised if operation
on other clock sources weren't even tested.

If you have hardware to test this, especially with possibility of checking
the SPI frequency I would really appreciate this, as I unfortunately don't
have such.

Best regards,
Tomasz
