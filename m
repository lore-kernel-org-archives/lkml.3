Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaFJNfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:35:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55248 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaFJNfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:35:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-3d-539709a28db9
Message-id: <53970994.8010400@samsung.com>
Date: Tue, 10 Jun 2014 15:35:16 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, arnd@arndb.de, Rob Herring <robh+dt@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Wolfram Sang <wsa@the-dreams.de>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/6] i2c: s3c2410: Handle i2c sys_cfg register in i2c
 driver
References: <1399706287-13919-1-git-send-email-y@samsung.com>
 <1399706419-13976-1-git-send-email-pankaj.dubey@samsung.com>
 <1399706419-13976-2-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399706419-13976-2-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xK7qLOacHGxxfxmjxd9Ixdov5R86x
	WvQuuMpmsenxNVaLhW1LWCw6/n5htLi8aw6bxYzz+5gsbl/mtVi09Qu7xds701ksWvceYbdY
	eWIWswOvR0tzD5vH71+TGD02r9Dy2LSqk81j85J6j74tqxg9Tp56wuLxeZNcAEcUl01Kak5m
	WWqRvl0CV8bnm3tYC24qV8zZO5u5gXGDTBcjJ4eEgInE4uezGCFsMYkL99azdTFycQgJLGWU
	eHD0FDuE85lR4lhjE1gVr4CWxNkjJ9lBbBYBVYlLHb9YQWw2ATWJzw2P2EBsfqCaNU3XWboY
	OThEBSIkHl8QgmgVlPgx+R4LyEwRgSmMEhd7ljGCOMwCE5kk7kw9zgxSJSwQKtG7fSMrxObd
	jBJHLs1nAUlwCnhKPP7zDmwbs4COxP7WaWwQtrzE5jVvmScwCs5CsmUWkrJZSMoWMDKvYhRN
	LU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJq687GJceszrEKMDBqMTDa+A/LViINbGsuDL3EKME
	B7OSCG/bX6AQb0piZVVqUX58UWlOavEhRiYOTqkGRoFpQmmf/3RWM0lvOy6bpv9KueBdw9o7
	57f8ZqpjKzsn3L3T9vpBnW1LKzuPnjqYsbnm2BTW4JmzX/78Gv7A+d+Go5fNn1xeemDynILf
	ghEi6irvFqu2nwvmvqc7w1v1RfuZ076sSmwTSwQEzh6d57pXQ+TCeydn12hXliir1NDeiZ51
	ScWuMUosxRmJhlrMRcWJAMUsiKaJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 10.05.2014 09:20, Pankaj Dubey wrote:
> Let's handle i2c interrupt re-configuration in i2c driver. This will
> help us in removing some soc specific checks from machine files.
> Since only Exynos5250, and Exynos5420 need to do this, added syscon
> based phandle to i2c device nodes of respective SoC DT files.
> Also handle saving and restoring of SYS_I2C_CFG register during
> suspend and resume of i2c driver. This will help in removing soc
> specific check from mach-exynos/pm.c.
> 
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Wolfram Sang <wsa@the-dreams.de>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: devicetree@vger.kernel.org
> CC: linux-doc@vger.kernel.org
> CC: linux-i2c@vger.kernel.org
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  .../devicetree/bindings/arm/samsung/sysreg.txt     |    1 +
>  arch/arm/boot/dts/exynos5.dtsi                     |    5 +++
>  arch/arm/boot/dts/exynos5250.dtsi                  |    4 +++
>  arch/arm/boot/dts/exynos5420.dtsi                  |    4 +++

What about Exynos5410 and Exynos5800?

>  drivers/i2c/busses/i2c-s3c2410.c                   |   32 ++++++++++++++++++++
>  5 files changed, 46 insertions(+)

[snip]

> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index ae44910..e707062 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -39,6 +39,8 @@
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/pinctrl/consumer.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
>  
>  #include <asm/irq.h>
>  
> @@ -91,6 +93,9 @@
>  /* Max time to wait for bus to become idle after a xfer (in us) */
>  #define S3C2410_IDLE_TIMEOUT	5000
>  
> +/* Exynos5 Sysreg offset */
> +#define EXYNOS5_SYS_I2C_CFG	0x0234
> +
>  /* i2c controller state */
>  enum s3c24xx_i2c_state {
>  	STATE_IDLE,
> @@ -127,6 +132,8 @@ struct s3c24xx_i2c {
>  #if defined(CONFIG_ARM_S3C24XX_CPUFREQ)
>  	struct notifier_block	freq_transition;
>  #endif
> +	struct regmap		*sysreg;
> +	unsigned int		sys_i2s_cfg;

typo: s/i2s/i2c/

>  };
>  
>  static struct platform_device_id s3c24xx_driver_ids[] = {
> @@ -1075,6 +1082,8 @@ static void
>  s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
>  {
>  	struct s3c2410_platform_i2c *pdata = i2c->pdata;
> +	u32 val = 0;
> +	int id;
>  
>  	if (!np)
>  		return;
> @@ -1084,6 +1093,23 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
>  	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
>  	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
>  				(u32 *)&pdata->frequency);
> +	/*
> +	 * Exynos5's legacy i2c controller and new high speed i2c
> +	 * controller have muxed interrupt sources. By default the

What do you mean by "by default"? Is it a setting from the bootloader or
reset value?

Probably to ensure that the mux is set correctly, same thing should be
also added to hsi2c driver.

> +	 * interrupts for 4-channel HS-I2C controller are enabled.
> +	 * If node for first four channels of legacy i2c controller
> +	 * are available then re-configure the interrupts via the
> +	 * system register.
> +	 */
> +	id = of_alias_get_id(np, "i2c");
> +	i2c->sysreg = syscon_regmap_lookup_by_phandle(np,
> +			"samsung,syscon-phandle");
> +	if (IS_ERR(i2c->sysreg)) {
> +		/* As this is not compulsory do not return error */
> +		pr_info("i2c-%d skipping re-configuration of interrutps\n", id);
> +		return;
> +	}
> +	regmap_update_bits(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, BIT(id), val);

As Wolfram pointed, val can be replaced with immediate 0 here.

>  }
>  #else
>  static void
> @@ -1268,6 +1294,9 @@ static int s3c24xx_i2c_suspend_noirq(struct device *dev)
>  
>  	i2c->suspended = 1;
>  
> +	if (!IS_ERR(i2c->sysreg))
> +		regmap_read(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, &i2c->sys_i2s_cfg);
> +
>  	return 0;
>  }
>  
> @@ -1276,6 +1305,9 @@ static int s3c24xx_i2c_resume(struct device *dev)
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
>  
> +	if (!IS_ERR(i2c->sysreg))
> +		regmap_write(i2c->sysreg, i2c->sys_i2s_cfg, EXYNOS5_SYS_I2C_CFG);

According to include/linux/regmap.h:

int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);

So in your code reg is swapped with val.

Best regards,
Tomasz
