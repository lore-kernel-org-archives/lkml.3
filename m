Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaLHNSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:18:08 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:55674 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaLHNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:18:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Mark Brown <broonie@kernel.org>,
        linux@arm.linux.org.uk, nsekhar@ti.com, khilman@deeprootsystems.com,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, chris@printf.net,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: edma: Split up header file to platform_data and API file
Date: Mon, 08 Dec 2014 14:16:59 +0100
Message-ID: <5296454.gCL6SxI1xr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141208124917.GI16827@intel.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <1417084891-17990-4-git-send-email-peter.ujfalusi@ti.com> <20141208124917.GI16827@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:qOoBWplELj48yikdIRXjlEiQ7cAHHx3Sw6afNNTo2zzbCw90PZp
 98o7J39sHUIroTzKlu1pwQWlBPoUQ9lQ2vSv9BCDhXRrCaiEzMz5fhWHQSmfVKngI8XYs9E
 ZVQsjuUuJVXJT7mV7hGqlH4W02wGADp1yqWY6Izwt4BADujNd4vmCuzCikaYHk9OK78TfrY
 +d4tbmU6qNl1IIBCvAUoA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 18:19:17 Vinod Koul wrote:
> On Thu, Nov 27, 2014 at 12:41:31PM +0200, Peter Ujfalusi wrote:
> > include/linux/platform_data/ is not a correct place to keep the API
> > definitions for edma, it is meant to be only for the pdata for the device.
> > Clean up this by moving the API to include/linux/edma.h
> > 
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > ---
> >  arch/arm/common/edma.c                     |   3 +-
> >  arch/arm/mach-davinci/devices.c            |   1 +
> >  arch/arm/mach-davinci/include/mach/da8xx.h |   1 +
> >  drivers/dma/edma.c                         |   2 +-
> >  include/linux/edma.h                       | 153 +++++++++++++++++++++++++++++
> >  include/linux/platform_data/edma.h         | 148 ++--------------------------
> >  sound/soc/davinci/davinci-pcm.h            |   1 +
> >  7 files changed, 165 insertions(+), 144 deletions(-)
> >  create mode 100644 include/linux/edma.h
> I was hoping that this will have delete for platform_data/edma.h, do we
> still need that and why shouldn't we get rid of this 

I think the platform_data/edma.h file is needed for as long as we have
mach-davinci systems that are not converted to boot using DT. At the current
pace of development in that area, I would expect that to take a few more
years at least: da850 support is slowly proceeding (since 2012), da830 should
be fairly straightforward to add once da850 is done, but I haven't seen
anybody start working on the dm* socs for DT.

	Arnd
