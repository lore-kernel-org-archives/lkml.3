Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3FEOLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:11:35 -0400
Received: from gloria.sntech.de ([95.129.55.99]:43928 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3FEOLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:11:33 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Seungwon Jeon <tgih.jun@samsung.com>
Subject: Re: [PATCH 06/10] mmc: dw_mmc-pltfm: add Rockchip variant
Date: Wed, 5 Jun 2013 16:11:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'John Stultz'" <john.stultz@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de> <201306030059.03783.heiko@sntech.de> <001601ce61f5$11b37b20$351a7160$%jun@samsung.com>
In-Reply-To: <001601ce61f5$11b37b20$351a7160$%jun@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201306051611.21669.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Juni 2013, 16:00:43 schrieb Seungwon Jeon:
> On 06/03/13 7:59 AM, Heiko Stübner wrote:
> > Cortex-A9 SoCs from Rockchip use a slightly modified variant of dw_mmc
> > controllers that seems to require the SDMMC_CMD_USE_HOLD_REG bit to
> > always be set.
> > 
> > There also seem to be no other modifications (additional register etc)
> > present, so to keep the footprint low, add this small variant to the
> > pltfm driver.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > 
> >  drivers/mmc/host/dw_mmc-pltfm.c |   48
> >  +++++++++++++++++++++++++++----------- 1 files changed, 34
> >  insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/dw_mmc-pltfm.c
> > b/drivers/mmc/host/dw_mmc-pltfm.c index 0048da8..7d041b5 100644
> > --- a/drivers/mmc/host/dw_mmc-pltfm.c
> > +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> > @@ -24,6 +24,16 @@
> > 
> >  #include "dw_mmc.h"
> > 
> > +
> > +static void dw_mci_rockchip_prepare_command(struct dw_mci *host, u32
> > *cmdr) +{
> > +	*cmdr |= SDMMC_CMD_USE_HOLD_REG;
> 
> Currently, SDMMC_CMD_USE_HOLD_REG is defined in dw_mmc-exynos.c
> It should be moved to dw_mmc.h

It's already done in another patch "mmc: dw_mmc: Add support DW SD/MMC driver 
on SOCFPGA" from Dinh Nguyen <dinguyen@altera.com>, which I therefore named as 
dependency in the cover letter.

Don't know if it's better to also include the move here again and let the 
merging person sort out the conflict?


