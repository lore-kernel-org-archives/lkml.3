Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbbAYK7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 05:59:10 -0500
Received: from mail.kernel.org ([198.145.29.136]:39127 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbbAYK7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 05:59:05 -0500
Date: Sun, 25 Jan 2015 11:58:58 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, todd.e.brandt@intel.com,
        jacob.jun.pan@linux.intel.com, sameo@linux.intel.com,
        lee.jones@linaro.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        david.woodhouse@intel.com
Subject: Re: [PATCH v2 3/3] X-Power AXP288 PMIC Fuel Gauge Driver
Message-ID: <20150125105857.GA16570@earth.universe>
References: <cover.1421957474.git.todd.e.brandt@linux.intel.com>
 <bdb977f4734a257f88b44f65c2554f30a247891e.1421957474.git.todd.e.brandt@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <bdb977f4734a257f88b44f65c2554f30a247891e.1421957474.git.todd.e.brandt@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Jan 22, 2015 at 12:52:07PM -0800, Todd Brandt wrote:
> New power_supply driver at driver/power which interfaces with the
> axp20x mfd driver as a cell. Provides battery info, monitors for
> changes, and generates alerts on temperature and capacity issues

Apart from two issues the driver looks fine to me.

> [...]
>
> +static void fuel_gauge_init_irq(struct axp288_fg_info *info)
> +{
> +	int ret, i, pirq;
> +
> +	for (i = 0; i < AXP288_FG_INTR_NUM; i++) {
> +		pirq = platform_get_irq(info->pdev, i);
> +		info->irq[i] = regmap_irq_get_virq(info->regmap_irqc, pirq);
> +		if (info->irq[i] < 0) {
> +			dev_warn(&info->pdev->dev,
> +				"regmap_irq get virq failed for IRQ %d: %d\n",
> +				pirq, info->irq[i]);
> +			info->irq[i] = -1;
> +			goto intr_failed;
> +		}
> +		ret = request_threaded_irq(info->irq[i],
> +				NULL, fuel_gauge_thread_handler,
> +				IRQF_ONESHOT, DEV_NAME, info);
> +		if (ret) {
> +			dev_warn(&info->pdev->dev,
> +				"request irq failed for IRQ %d: %d\n",
> +				pirq, info->irq[i]);
> +			info->irq[i] = -1;
> +			goto intr_failed;
> +		} else {
> +			dev_info(&info->pdev->dev, "HW IRQ %d -> VIRQ %d\n",
> +				pirq, info->irq[i]);
> +		}
> +	}
> +	return;
> +
> +intr_failed:
> +	for (; i > 0; i--) {
> +		free_irq(info->irq[i - 1], info);
> +		info->irq[i - 1] = -1;
> +	}

This is missing in axp288_fuel_gauge_remove().

> +}
>
> [...]
>
> +static int axp288_fuel_gauge_remove(struct platform_device *pdev)
> +{
> +	struct axp288_fg_info *info = platform_get_drvdata(pdev);
> +
> +	cancel_delayed_work_sync(&info->status_monitor);
> +	power_supply_unregister(&info->bat);
> +	fuel_gauge_remove_debugfs(info);
> +
> +	return 0;
> +}
>
> [...]
>
> +static struct platform_driver axp288_fuel_gauge_driver = {
> +	.probe = axp288_fuel_gauge_probe,
> +	.remove = axp288_fuel_gauge_remove,
> +	.id_table = axp288_fg_id_table,
> +	.driver = {
> +		.name = DEV_NAME,
> +		.owner = THIS_MODULE,

please remove .owner, it will be set automatically by
module_platform_driver.

> [...]

-- Sebastian

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUxMxuAAoJENju1/PIO/qaAgUP/00uKzv57kIv7NSyBCnV6VLr
hl16/qf2OI5fs3bqQxHOskz3WuHfKitNkPLHPwehJjj9xio7QnV3ViECYXXPG5rH
Md0XgswkwDTF0wFQnlYzWUPimeBdxdJIgvYyU82m5isW1Zp8+WRiVv0iOPT65qKw
hrGp+Hpn5nuzdoH3sT1r7m6Aj+2P/L/ixhk3zTaqNBV3+J1HoE9do09ihXJSpyng
pBd4xtgZgD36T8+uN4/2xQyk6hiGFYecTKC0fUmT8IPvKP8x+r8/9H92/piIrFI4
/NxVIhLd5aROlnEV3SGgr4fKhDT37PMOxGjOn+g9UwDiaeOun99pFlzTlOKeQ7EP
O8h2h+W3OezYD9mEf8XMOy8iG3pX80dhTerrG7Q0ACP/xjFK8L/HIZSFMo4nT8vY
CzZ+y1cK8A2Dpun79R9kI611alPJYspGfRrxRMt9AIJjnf1u8fR9miNN9RTTjrHr
xAsUsFeY8AZq56RkJEaB6s2rcuNX+hdrT3SS1/tc7SWTLbOYhpa8uEIjx96nxpGv
iU7PWJr4CtMk1NMGJz3pw4Rqpr7bjvxMDDYLUrE+AbELKYk913AYmazEGwl/QJDZ
74nihZyH1EW3xthO3XDhDZxlw/wPCSYg6uUMCxgEh7uV1qrB1c2B9CIhVuAPqcqA
LzKkbSSOzrIM3a73ZY+i
=FDpg
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
