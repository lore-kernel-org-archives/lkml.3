Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946205Ab3FUVyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:54:00 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45712 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946146Ab3FUVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <201306212044.26677.arnd@arndb.de>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
	<201306211632.12577.arnd@arndb.de>
	<CAD=GYpbhBAaSkMtcJaPtVpWar7AcW37QpAk3A0qgwX6G5PDoZg@mail.gmail.com>
	<201306212044.26677.arnd@arndb.de>
Date: Fri, 21 Jun 2013 16:53:57 -0500
Message-ID: <CAD=GYpY4koXd9f6_ijQfDHsiULD4d53cdu=9X421WXSAit_YQg@mail.gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sekhar Nori <nsekhar@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
        Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Jun 21, 2013 at 1:44 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 21 June 2013, Joel A Fernandes wrote:
>> I think we are talking about different things, I agree the 'select
>> DMADEVICES' can be dropped but lets please keep the default y option
>> (not adding new select statements, just saying that if someone select
>> DMADEVICES in menuconfig and if they're ARCH_OMAP=1 , then default to
>> EDMA). This will simply allow people to have a default. Thanks.
>
> Yes, that's ok.

Ok, thanks. I will follow up with a patch in my next submissions that builds it.

Perhaps a:
default y if 'ARCH_OMAP2PLUS'

and leave the existing as it is...
default n if  'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2'

would make most sense to me. Basically EDMA is seen on current and all
new OMAP2PLUS.

>
> config TI_EDMA
>         tristate "TI EDMA support"
>         default m if 'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2
>         select DMA_ENGINE
>         select DMA_VIRTUAL_CHANNELS



MMC depends on EDMA specially on AM33xx there's no PIO mode AFAIK. The
'm' option will require some initramfs to load the module when needing
to MMC boot, I suggest lets leave it as y.

Thanks,
Joel
