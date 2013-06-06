Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3FFQu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:50:59 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:42787 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3FFQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:50:58 -0400
Date: Thu, 6 Jun 2013 17:50:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 4/4] ARM: ux500: Remove call to u8500_of_init_devices() -
 again
Message-ID: <20130606165053.GU3370@gmail.com>
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
 <1370517676-10909-5-git-send-email-lee.jones@linaro.org>
 <201306061758.25106.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306061758.25106.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun 2013, Arnd Bergmann wrote:

> On Thursday 06 June 2013, Lee Jones wrote:
> > Somehow, probably due to a merge error the call to u8500_of_init_devices()
> > has re-appeared in next, causing this error:
> > 
> > arch/arm/mach-ux500/cpu-db8500.c: In function ‘u8500_init_machine’:
> > arch/arm/mach-ux500/cpu-db8500.c:268:2: error: implicit declaration of     \
> >   function ‘u8500_of_init_devices’ [-Werror=implicit-function-declaration]
> > arch/arm/mach-ux500/cpu-db8500.c:268:9: warning: assignment makes pointer  \
> >   from integer without a cast [enabled by default]
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/mach-ux500/cpu-db8500.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> > index d8ee616..f391d08 100644
> > --- a/arch/arm/mach-ux500/cpu-db8500.c
> > +++ b/arch/arm/mach-ux500/cpu-db8500.c
> > @@ -264,9 +264,6 @@ static void __init u8500_init_machine(void)
> >  	else if (of_machine_is_compatible("st-ericsson,ccu9540")) {}
> >  		/* TODO: Add pinmaps for ccu9540 board. */
> >  
> > -	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
> > -	parent = u8500_of_init_devices();
> > -
> >  	/* automatically probe child nodes of dbx5x0 devices */
> >  	if (of_machine_is_compatible("st-ericsson,u8540"))
> >  		of_platform_populate(NULL, u8500_local_bus_nodes,
> 
> In the code I'm looking at, the definition for that function is
> 
> /* TODO: Once all pieces are DT:ed, remove completely. */
> static struct device * __init u8500_of_init_devices(void)
> {
>         struct device *parent = db8500_soc_device_init();
>         db8500_add_usb(parent, usb_db8500_dma_cfg, usb_db8500_dma_cfg);
>         return parent;
> }
> 
> I'm not sure about the db8500_add_usb() call, but I think at least
> db8500_soc_device_init() is required to get the root device for all
> other devices.

Right:

https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-stericsson.git/commit/arch/arm/mach-ux500/cpu-db8500.c?h=next&id=1e74043a29cdec67279d6e4f494dd1674a1b2365

For some reason (I suspect a merge error), u8500_of_init_devices
reappeared.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
