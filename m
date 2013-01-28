Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3A1T6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:58:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3A1T6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:58:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v5 07/14] dmaengine: add dma_request_slave_channel_compat()
Date: Mon, 28 Jan 2013 19:57:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>
References: <1358281974-8411-1-git-send-email-mporter@ti.com> <1358281974-8411-8-git-send-email-mporter@ti.com> <CAHp75VeqikcTuOd14utb9E0P3b9t1mr=JsmkAbz5=3FJwU2kFA@mail.gmail.com>
In-Reply-To: <CAHp75VeqikcTuOd14utb9E0P3b9t1mr=JsmkAbz5=3FJwU2kFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281957.47604.arnd@arndb.de>
X-Provags-ID: V02:K0:s5Z8G+6ftbFv7demmF4vZ/7ysJuvtkans5ezT5wocdc
 iJ1Ar8ZVN/8iwkU2kd1CvFVFWlv0P4cNZNAq4EFKI21D0D6oUM
 iogTsT9L6lbtROxbd2T8fCuBNoieitxHNMzcUqH+UESnfVPZN/
 N7K+YsUiEjaQOpgTfWb+iUJi+RTYqmltZ/zrjNFlQB3ub6wZwh
 JJNlCLLH2cyDPhLX85jv46a+uyJ+XCW4Mk2AHr/1MMtbhvYfph
 0YTh1+Dn/22mYS0I1BhlEjs/607GCCx23gAIVD0JIoqP2EDZga
 eJK7DnR9u/+IZN8DvCm7+BV5vDzpud2rmdNmnjmK7hvb0Rs2ZZ
 ZpTvm9WvuVfJN1MMqvBs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2013, Andy Shevchenko wrote:
> On Tue, Jan 15, 2013 at 10:32 PM, Matt Porter <mporter@ti.com> wrote:
> > Adds a dma_request_slave_channel_compat() wrapper which accepts
> > both the arguments from dma_request_channel() and
> > dma_request_slave_channel(). Based on whether the driver is
> > instantiated via DT, the appropriate channel request call will be
> > made.
> >
> > This allows for a much cleaner migration of drivers to the
> > dmaengine DT API as platforms continue to be mixed between those
> > that boot using DT and those that do not.
> 
> Does it mean the introduced function is kinda temporary?

Some drivers can very likely get converted to use only
dma_request_slave_channel() in the long run, when all
the platforms using those drivers have been converted to
provide the channels using device tree.

However, for drivers that are used on legacy platforms
without DT support, we may still need something like
this function in the long run.

	Arnd
