Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbbATKpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:45:52 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:64295 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbATKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:45:50 -0500
Date: Tue, 20 Jan 2015 10:45:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        DT <devicetree@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Support Opensource <support.opensource@diasemi.com>
Subject: Re: [PATCH V2 1/2] mfd: da9063: Add device tree support
Message-ID: <20150120104544.GS5767@x1>
References: <cover.1421684991.git.stwiss.opensource@diasemi.com>
 <d765ef11de06a4ac5721ecf3283ba1333a6d0c8c.1421684991.git.stwiss.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d765ef11de06a4ac5721ecf3283ba1333a6d0c8c.1421684991.git.stwiss.opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Steve Twiss wrote:

> From: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> Add device tree support for DA9063 regulators; Real-Time Clock
> and Watchdog.
> 
> This patch is dependent on PATCH V2 2/2 
> 
> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> ---
> This patch applies against linux-next and v3.19-rc4 
> 
>  drivers/mfd/da9063-core.c       |  2 ++
>  drivers/mfd/da9063-i2c.c        | 11 +++++++++++
>  include/linux/mfd/da9063/core.h |  1 +
>  3 files changed, 14 insertions(+)
> 
> diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
> index f38bc98..facd361 100644
> --- a/drivers/mfd/da9063-core.c
> +++ b/drivers/mfd/da9063-core.c
> @@ -86,6 +86,7 @@ static const struct mfd_cell da9063_devs[] = {
>  	},
>  	{
>  		.name		= DA9063_DRVNAME_WATCHDOG,
> +		.of_compatible	= "dlg,da9063-watchdog",
>  	},
>  	{
>  		.name		= DA9063_DRVNAME_HWMON,
> @@ -101,6 +102,7 @@ static const struct mfd_cell da9063_devs[] = {
>  		.name		= DA9063_DRVNAME_RTC,
>  		.num_resources	= ARRAY_SIZE(da9063_rtc_resources),
>  		.resources	= da9063_rtc_resources,
> +		.of_compatible	= "dlg,da9063-rtc",
>  	},
>  	{
>  		.name		= DA9063_DRVNAME_VIBRATION,
> diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
> index 21fd8d9..0e94b20 100644
> --- a/drivers/mfd/da9063-i2c.c
> +++ b/drivers/mfd/da9063-i2c.c
> @@ -25,6 +25,9 @@
>  #include <linux/mfd/da9063/pdata.h>
>  #include <linux/mfd/da9063/registers.h>
>  
> +#include <linux/of.h>
> +#include <linux/regulator/of_regulator.h>
> +
>  static const struct regmap_range da9063_ad_readable_ranges[] = {
>  	{
>  		.range_min = DA9063_REG_PAGE_CON,
> @@ -203,6 +206,13 @@ static struct regmap_config da9063_regmap_config = {
>  	.cache_type = REGCACHE_RBTREE,
>  };
>  
> +static const struct of_device_id da9063_dt_ids[] = {
> +	{ .compatible = "dlg,da9063-ad", },
> +	{ .compatible = "dlg,da9063-bb", },
> +	{ .compatible = "dlg,da9063-ca", },

I'm still a bit bemused as to why these require their own compatible
strings?  They are never matched (of_match_device()) on and it appears
they can be dynamically told apart by poking.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
