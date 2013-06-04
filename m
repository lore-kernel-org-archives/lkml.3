Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3FDIoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:44:14 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56960 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab3FDIoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:44:08 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH 06/10] mmc: dw_mmc-pltfm: add Rockchip variant
Date: Tue, 4 Jun 2013 10:43:59 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        devicetree-discuss@lists.ozlabs.org
References: <201306030055.15413.heiko@sntech.de> <201306030059.03783.heiko@sntech.de> <51AD67CF.60300@samsung.com>
In-Reply-To: <51AD67CF.60300@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306041044.00128.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Juni 2013, 06:06:39 schrieb Jaehoon Chung:
> On 06/03/2013 07:59 AM, Heiko Stübner wrote:
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
> > *cmdr)
> 
> How about using "dw_mci_pltfm_prepare_command()"?
> Maybe HOLD_REG could be used at other SoC.

The problem I had when thinking about it is that every implementation using 
the HOLD_REG stuff does it differently ... on the Exynos variant it depends on 
the CLKSEL register value and on the SOCFPGA variant on other clock values.

It's only on the Rockchip variant that it seems to needed all the time.

So, doing it with a "dw_mci_pltfm_prepare_command()" would need a flag to 
signal that the implementation needs the HOLD_REG all the time, but we won't 
know yet if other implementations will have other constraints on its use - 
like only i special cases or such.

So personally I would keep it as it is for now, until more platforms using the 
HOLD_REG come along to see some sort of pattern of its use?


