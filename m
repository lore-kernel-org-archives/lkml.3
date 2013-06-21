Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423695Ab3FUSok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:44:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FUSoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:44:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel A Fernandes <agnel.joel@gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
Date: Fri, 21 Jun 2013 20:44:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
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
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <201306211632.12577.arnd@arndb.de> <CAD=GYpbhBAaSkMtcJaPtVpWar7AcW37QpAk3A0qgwX6G5PDoZg@mail.gmail.com>
In-Reply-To: <CAD=GYpbhBAaSkMtcJaPtVpWar7AcW37QpAk3A0qgwX6G5PDoZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306212044.26677.arnd@arndb.de>
X-Provags-ID: V02:K0:jclk5W1ehbhhMyw2zvVTYx3aoPeO0KK7QQ3KXh/6N1s
 XFfKve1sD9un60KWfeavw70c+Uzi6aqJSy7ttvJjFqsL/9YDoK
 XAeAeZ37YdGRjVUCPJglwRlmlQ4EgVsXqWAhxHfdsPMHZ+ma0a
 rIYM8SkKfYQ12aP4ubaDxWNM+YoEr7YSgxqcCsn2JuuKEu58WN
 UHk6zSO5oovjN5YAU03pYzMEfbrzcH5cds8mwsAKI23cr8LpCB
 vp1C6yFcBhuXVfJrqztm8/I/bD5hjpADQXflS1hIqTDWq8IsmC
 nveYIhbNA7QGzAUIEEyGBn4R1OAYVLjSdDV9I0bUH5g7AqpWcu
 nBbQmJ5UiTf2kWkTsNJ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013, Joel A Fernandes wrote:
> I think we are talking about different things, I agree the 'select
> DMADEVICES' can be dropped but lets please keep the default y option
> (not adding new select statements, just saying that if someone select
> DMADEVICES in menuconfig and if they're ARCH_OMAP=1 , then default to
> EDMA). This will simply allow people to have a default. Thanks.

Yes, that's ok.

Also, if the driver doesn't strictly depend on these platforms but
can build on anything, I would write it as

config TI_EDMA
        tristate "TI EDMA support"
        default m if 'ARCH_DAVINCI || ARCH_OMAP1 || ARCH_OMAP2
        select DMA_ENGINE
        select DMA_VIRTUAL_CHANNELS

	Arnd
