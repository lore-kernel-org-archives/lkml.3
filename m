Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3LEH5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:57:42 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50176 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3LEH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:57:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131202213654.GA4059@roeck-us.net>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
 <20131202202120.GA23611@roeck-us.net> <CAOesGMi-P6LG1-XKVizUS_qX-gfZi_iXBO5r+=6a2nfvBS60mw@mail.gmail.com>
 <20131202213654.GA4059@roeck-us.net>
From: Leela Krishna Amudala <l.krishna@samsung.com>
Date: Thu, 5 Dec 2013 13:27:13 +0530
X-Google-Sender-Auth: Foku6HlA0xsJTqSWPvlEayW-xcg
Message-ID: <CAL1wa8cQcvRzXgaEP3kzkvzogqyeM2eJt_oRZfu6NbWxfP3zAg@mail.gmail.com>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Report when the watchdog reset the system
To: Guenter Roeck <linux@roeck-us.net>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter Roeck,

On Tue, Dec 3, 2013 at 3:06 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Dec 02, 2013 at 12:47:53PM -0800, Olof Johansson wrote:
> > On Mon, Dec 2, 2013 at 12:21 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > > On Mon, Dec 02, 2013 at 10:14:41AM -0800, Doug Anderson wrote:
> > >> A good watchdog driver is supposed to report when it was responsible
> > >> for resetting the system.  Implement this for the s3c2410, at least on
> > >> exynos5250 and exynos5420 where we already have a pointer to the PMU
> > >> registers to read the information.
> > >>
> > >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> > >> ---
> > >> This patch is based atop Leela Krishna's recent series that ends with
> > >> (ARM: dts: update watchdog device nodes for Exynos5250 and Exynos5420)
> > >> AKA <https://patchwork.kernel.org/patch/3251861/>.
> > >>
> > >>  drivers/watchdog/s3c2410_wdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
> > >>  1 file changed, 39 insertions(+), 3 deletions(-)
> > >>
> > >> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
> > >> index 47f4dcf..2c87d37 100644
> > >> --- a/drivers/watchdog/s3c2410_wdt.c
> > >> +++ b/drivers/watchdog/s3c2410_wdt.c
> > >> @@ -62,9 +62,13 @@
> > >>  #define CONFIG_S3C2410_WATCHDOG_ATBOOT               (0)
> > >>  #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME (15)
> > >>
> > >> +#define RST_STAT_REG_OFFSET          0x0404
> > >>  #define WDT_DISABLE_REG_OFFSET               0x0408
> > >>  #define WDT_MASK_RESET_REG_OFFSET    0x040c
> > >>  #define QUIRK_NEEDS_PMU_CONFIG               (1 << 0)
> > >> +#define QUIRK_HAS_RST_STAT           (1 << 1)
> > >> +#define QUIRKS_NEED_PMUREG           (QUIRK_NEEDS_PMU_CONFIG | \
> > >> +                                      QUIRK_HAS_RST_STAT)
> > >>
> > > I am not really happy about the NEED (both of them, really) here.
> > > How about HAS instead ?
> >
> > Ah, I just commented on these things on our internal review site too
> > on this patch. I don't even think a quirk is needed -- just use the
> > presence of a non-0 rst_stat_reg to tell if you need to use regmap.
> >
> Agreed; same is true for the QUIRK_NEEDS_PMU_CONFIG related registers
> as well.
>

As Tomasz Figa suggested I introduced quirks,

Tomasz,
Any comments from you here...??


Best wishes,
Leela Krishna


> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
