Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab3GIKJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:09:40 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:17499
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763Ab3GIKJg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:09:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I542Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Gong Yibin-B38343 <B38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Subject: RE: [PATCH v1] regulator: pfuze100: add pfuze100 regulator driver
Thread-Topic: [PATCH v1] regulator: pfuze100: add pfuze100 regulator driver
Thread-Index: AQHOfIk7QX8bab8jOkyNIGYBhE0pv5lcHQHg
Date: Tue, 9 Jul 2013 10:08:38 +0000
Message-ID: <95EEB29E288F544BAED903CDEA0C4C06010FCE61@039-SN1MPN1-005.039d.mgd.msft.net>
References: <1373351880-26982-1-git-send-email-b38343@freescale.com>
 <20130709094424.GQ27646@sirena.org.uk>
In-Reply-To: <20130709094424.GQ27646@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.252.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark. The pfuze driver refer to the mc13xxx regulator driver, so I didn't notice regulator core make some changes and some work have been done by regulator core. Sorry.. I will update the patch later.

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Tuesday, July 09, 2013 5:44 PM
To: Gong Yibin-B38343
Cc: linux-kernel@vger.kernel.org; grant.likely@linaro.org; rob.herring@calxeda.com; lgirdwood@gmail.com
Subject: Re: [PATCH v1] regulator: pfuze100: add pfuze100 regulator driver

On Tue, Jul 09, 2013 at 02:38:00PM +0800, Robin Gong wrote:

I've not fully reviewed this, the major thing here is that the driver is not making use of the regmap helpers for anything - most of the code in this driver looks like it duplicates standard code available in the core.

> @@ -45,6 +45,7 @@ obj-$(CONFIG_REGULATOR_MAX77693) += max77693.o
>  obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
>  obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
>  obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
> +obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
>  obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
>  obj-$(CONFIG_REGULATOR_TPS51632) += tps51632-regulator.o
>  obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o @@ -72,6 +73,7 @@ 
> obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
>  obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
> +obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o

This looks broken...

> +++ b/drivers/regulator/pfuze-regulator.h
> @@ -0,0 +1,110 @@

Why is this a separate file?

> +struct pfuze_regulator {
> +	struct regulator_desc desc;
> +	unsigned int reg;
> +	unsigned int stby_reg;
> +	unsigned char enable_bit;
> +	unsigned char stby_bit;
> +	unsigned char vsel_shift;
> +	unsigned char vsel_mask;
> +	unsigned char stby_vsel_shift;
> +	unsigned char stby_vsel_mask;
> +	int const *voltages;

This pretty much all looks like you are duplicating standard framework features - things like the vsels for example.

> +static const int pfuze100_sw1[] = {
> +	300000, 325000, 350000, 375000, 400000, 425000, 450000, 475000,
> +	500000, 525000, 550000, 575000, 600000, 625000, 650000, 675000,
> +	700000, 725000, 750000, 775000, 800000, 825000, 850000, 875000,
> +	900000, 925000, 950000, 975000, 1000000, 1025000, 1050000, 1075000,
> +	1100000, 1125000, 1150000, 1175000, 1200000, 1225000, 1250000, 1275000,
> +	1300000, 1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000,
> +	1500000, 1525000, 1550000, 1575000, 1600000, 1625000, 1650000, 1675000,
> +	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 
> +1875000, };

This looks like a linear map, use one if you can.  Similarly for a bunch of the other tables (possibly all of them).

> +#if defined(CONFIG_OF)
> +static const struct of_device_id pfuze_dt_ids[] = {
> +	{ .compatible = "fsl,pfuze100", .data = (void *)PFUZE_ID_PFUZE100},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pfuze_dt_ids); #endif

No need for ifdefs.

> +static int pfuze100_regulator_enable(struct regulator_dev *rdev)

You should be using the standard regmap helpers for this.

> +int pfuze100_regulator_list_voltage(struct regulator_dev *rdev,
> +				    unsigned selector)

This too (even if you need to use the tables there are helpers for that too).

> +static int pfuze100_regulator_sw_standby_enable(struct regulator_dev 
> +*rdev) {
> +	return 0;
> +}
> +static int pfuze100_regulator_sw_standby_disable(struct regulator_dev 
> +*rdev) {
> +	return 0;
> +}
> +static struct regulator_ops pfuze100_sw_regulator_ops = {

Coding style and you shouldn't have any empty functions.

> +#ifdef CONFIG_OF
> +
> +static int  pfuze_get_num_regulators_dt(struct device *dev) {

You need to document any new device tree bindings.

> +static struct regmap_config pfuze_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = PFUZE_NUMREGS,
> +
> +	.cache_type = REGCACHE_NONE,

This is the defualt, though you should consider caching for performance reasons.

> +subsys_initcall(pfuze100_regulator_init);

Use module_i2c_driver() (and watch out for coding style).

