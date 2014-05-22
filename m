Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaEVKcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:32:25 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:51148 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaEVKcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:32:23 -0400
Date: Thu, 22 May 2014 12:32:40 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>, kernel@pengutronix.de,
        Russell King <linux@arm.linux.org.uk>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] ARM: imx: convert camera init to use
 platform_device_register_full()
Message-ID: <20140522103240.GB4804@lianli>
References: <1400446261-27085-1-git-send-email-emilgoode@gmail.com>
 <1400446261-27085-3-git-send-email-emilgoode@gmail.com>
 <20140519062722.GE16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140519062722.GE16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Uwe,

On Mon, May 19, 2014 at 08:27:22AM +0200, Uwe Kleine-König wrote:
> Hello Emil,
> 
> thanks for your effort.
> 
> On Sun, May 18, 2014 at 10:51:00PM +0200, Emil Goode wrote:
> > This converts the imx camera allocation and initialization functions
> > to use platform_device_register_full() thus simplifying the code.
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> > Only build tested, unfortunately I currently don't have the hardware.
> > 
> >  arch/arm/mach-imx/devices/platform-ipu-core.c |   43 +++++++++----------------
> >  arch/arm/mach-imx/mach-mx31_3ds.c             |    5 ++-
> >  arch/arm/mach-imx/mach-mx31moboard.c          |    6 ++--
> >  arch/arm/mach-imx/mach-mx35_3ds.c             |    5 ++-
> >  arch/arm/mach-imx/mach-pcm037.c               |    5 ++-
> >  5 files changed, 23 insertions(+), 41 deletions(-)
> > 
> > diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > index 6bd7c3f..13ea542 100644
> > --- a/arch/arm/mach-imx/devices/platform-ipu-core.c
> > +++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > @@ -69,42 +69,29 @@ struct platform_device *__init imx_alloc_mx3_camera(
> IMHO you should better rename the function because now it doesn't only
> allocate the device, but also registers it.
> 
> Also I doubt that it's OK to call dma_declare_coherent_memory after the
> device is added. In this case maybe extend
> platform_device_register_full? And also add a warning to
> dma_declare_coherent_memory if it is called for an already added device?
> (Added a few people to Cc: that might be able to comment this. I don't
> even know if there is a reliable way to check if a device is already
> added.)

According to the documentation dma_declare_coherent_memory() is only used
in unlikely corner cases, so I concluded that it is probably better not to
include it in platform_device_register_full().

Best regards,

Emil Goode
