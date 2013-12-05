Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3LEQo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:44:29 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36329 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3LEQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:44:27 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-af-52a0ad697542
From: Tomasz Figa <t.figa@samsung.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Report when the watchdog reset the
 system
Date: Thu, 05 Dec 2013 17:44:16 +0100
Message-id: <35548763.UvKAOvJvxh@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <20131205164038.GA15560@roeck-us.net>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
 <42011482.56GYn1upCz@amdc1227> <20131205164038.GA15560@roeck-us.net>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xa7qZaxcEGfRNFrCYtO4Ak8XZZQfZ
	LHoXXGWz2LnlBpvFpsfXWC0u75rDZjHj/D4mixvr9rFbPFl4hsni1PXPbBardv1htLg14wWr
	A4/H7IaLLB5/V71g9tg56y67x7XNYh6bl9R7XDnRxOqx83sDu0ffllWMHp83yQVwRnHZpKTm
	ZJalFunbJXBlLFkylbFguXLFsttvWBsY90l3MXJySAiYSHxqfs8MYYtJXLi3nq2LkYtDSGAp
	o8Sh7odMEE4Xk8Ttrf9YQarYBNQkPjc8YgOxRYDs5lMtYB3MAtOYJdqvfAdyODiEBcIlGnY4
	gdSwCKhKPFlxnBHE5hXQktg56y8LiM0voC7xbttTJhBbVMBN4sW+LewgNqeAkcSnZdOgFvcw
	Smxo/8UG0Swo8WPyPbBmZgF5iX37p7JC2FoS63ceZ5rAKDgLSdksJGWzkJQtYGRexSiaWppc
	UJyUnmukV5yYW1yal66XnJ+7iRESV193MC49ZnWIUYCDUYmHN3HNgiAh1sSy4srcQ4wSHMxK
	Irz3FwCFeFMSK6tSi/Lji0pzUosPMTJxcEo1MGopnH3HyaUuaD11RrzuoZf1DxdLLuY8flB5
	7/14Ca/jD89ulbQvTXY/oiytuf3JX98KtsTzIrN0rxxt/8EyUei+kfLzuk2HGC5JiTotVAiJ
	FNxgH+sn94z1vcO1qsy9dyeWrXqZeJhP8I/wwwMzprK5sLc9jVgY0VCcVZkX9Fi/fFbhRP8T
	fkosxRmJhlrMRcWJAH87IAqJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 of December 2013 08:40:38 Guenter Roeck wrote:
> On Thu, Dec 05, 2013 at 05:21:47PM +0100, Tomasz Figa wrote:
> > Hi Doug,
> > 
> > Please see my comments inline.
> > 
> > On Monday 02 of December 2013 10:14:41 Doug Anderson wrote:
> > > A good watchdog driver is supposed to report when it was responsible
> > > for resetting the system.  Implement this for the s3c2410, at least on
> > > exynos5250 and exynos5420 where we already have a pointer to the PMU
> > > registers to read the information.
> > > 
> > > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > > ---
> > > This patch is based atop Leela Krishna's recent series that ends with
> > > (ARM: dts: update watchdog device nodes for Exynos5250 and Exynos5420)
> > > AKA <https://patchwork.kernel.org/patch/3251861/>.
> > > 
> > >  drivers/watchdog/s3c2410_wdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 39 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
> > > index 47f4dcf..2c87d37 100644
> > > --- a/drivers/watchdog/s3c2410_wdt.c
> > > +++ b/drivers/watchdog/s3c2410_wdt.c
> > > @@ -62,9 +62,13 @@
> > >  #define CONFIG_S3C2410_WATCHDOG_ATBOOT		(0)
> > >  #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME	(15)
> > >  
> > > +#define RST_STAT_REG_OFFSET		0x0404
> > 
> > IMHO this should be namespaced, at least with EXYNOS5 prefix. The two
> > registers below should be as well, but I missed this in the patch adding
> > them.
> > 
> > >  #define WDT_DISABLE_REG_OFFSET		0x0408
> > >  #define WDT_MASK_RESET_REG_OFFSET	0x040c
> > >  #define QUIRK_NEEDS_PMU_CONFIG		(1 << 0)
> > > +#define QUIRK_HAS_RST_STAT		(1 << 1)
> > > +#define QUIRKS_NEED_PMUREG		(QUIRK_NEEDS_PMU_CONFIG | \
> > > +					 QUIRK_HAS_RST_STAT)
> > >  
> > >  static bool nowayout	= WATCHDOG_NOWAYOUT;
> > >  static int tmr_margin;
> > > @@ -98,6 +102,9 @@ MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
> > >   * timer reset functionality.
> > >   * @mask_bit: Bit number for the watchdog timer in the disable register and the
> > >   * mask reset register.
> > > + * @rst_stat_reg: Offset in pmureg for the register that has the reset status.
> > > + * @rst_stat_bit: Bit number in the rst_stat register indicating a watchdog
> > > + * reset.
> > >   * @quirks: A bitfield of quirks.
> > >   */
> > >  
> > > @@ -105,6 +112,8 @@ struct s3c2410_wdt_variant {
> > >  	int disable_reg;
> > >  	int mask_reset_reg;
> > >  	int mask_bit;
> > > +	int rst_stat_reg;
> > > +	int rst_stat_bit;
> > >  	u32 quirks;
> > >  };
> > >  
> > > @@ -131,14 +140,20 @@ static const struct s3c2410_wdt_variant drv_data_exynos5250  = {
> > >  	.disable_reg = WDT_DISABLE_REG_OFFSET,
> > >  	.mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
> > >  	.mask_bit = 20,
> > > -	.quirks = QUIRK_NEEDS_PMU_CONFIG
> > > +	.rst_stat_reg = RST_STAT_REG_OFFSET,
> > > +	.rst_stat_bit = 20,
> > > +	.quirks = QUIRK_NEEDS_PMU_CONFIG |
> > > +		QUIRK_HAS_RST_STAT,
> > >  };
> > >  
> > >  static const struct s3c2410_wdt_variant drv_data_exynos5420 = {
> > >  	.disable_reg = WDT_DISABLE_REG_OFFSET,
> > >  	.mask_reset_reg = WDT_MASK_RESET_REG_OFFSET,
> > >  	.mask_bit = 0,
> > > -	.quirks = QUIRK_NEEDS_PMU_CONFIG
> > > +	.rst_stat_reg = RST_STAT_REG_OFFSET,
> > > +	.rst_stat_bit = 9,
> > > +	.quirks = QUIRK_NEEDS_PMU_CONFIG |
> > > +		QUIRK_HAS_RST_STAT,
> > >  };
> > >  
> > >  static const struct of_device_id s3c2410_wdt_match[] = {
> > > @@ -423,6 +438,25 @@ static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
> > >  }
> > >  #endif
> > >  
> > > +static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wdt *wdt)
> > > +{
> > > +	unsigned int bootstatus = 0;
> > > +	int ret;
> > > +
> > > +	if (wdt->drv_data->quirks & QUIRK_HAS_RST_STAT) {
> > 
> > nit: I guess it's just a matter of taste, but to reduce code indentation
> > you could inverse the check and simply return 0 here.
> > 
> 
> nit: If so, it would make sense to to the same for the other 'quirk'
> for consistency.
> 
> static int s3c2410wdt_mask_and_disable_reset(struct s3c2410_wdt *wdt, bool mask)
> {
> 	...
> 	if (!(wdt->drv_data->quirks & QUIRK_NEEDS_PMU_CONFIG))
> 		return 0;
> 	...
> }

That's quite a bit different story, as currently the check is outside of
this function, but I agree, it would look better.

Best regards,
Tomasz

