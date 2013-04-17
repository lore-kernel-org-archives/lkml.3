Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966678Ab3DQTTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:19:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56963 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966643Ab3DQTTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:19:47 -0400
Date: Wed, 17 Apr 2013 20:19:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V5 1/7] drivers/mfd: DA9058 MFD core driver
Message-ID: <20130417191944.GB19873@opensource.wolfsonmicro.com>
References: <201304171650.r3HGo6YZ023894@latitude>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304171650.r3HGo6YZ023894@latitude>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:33:33PM +0100, Anthony Olech wrote:

> +static struct regulator_consumer_supply platform_vddarm_consumers[] = {
> +	{.supply = "vcc",}
> +};
> +

This looks very system specific and should be done by the system
integration for the board not the MFD.

> +static struct da9058_regulator_pdata buck1_pdata = {
> +	.regulator_name = "DA9058_BUCK1",
> +	.regulator_id = DA9058_BUCK_1,
> +	.min_uv = DA9058_BUCK12_VOLT_LOWER * 1000,
> +	.max_uv = DA9058_BUCK12_VOLT_UPPER * 1000,
> +	.control_voltage_step = DA9058_BUCK_VOLT_STEP * 1000,
> +	.control_register = DA9058_BUCK1_REG,
> +	.control_step_mask = DA9058_MAX_VSEL,
> +	.control_enable_mask = DA9058_BUCK_LDO_EN,
> +	.ramp_register = DA9058_SUPPLY_REG,
> +	.ramp_enable_mask = DA9058_SUPPLY_VBUCK1GO,
> +	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_MODE |
> +				REGULATOR_CHANGE_STATUS,
> +	.valid_modes_mask = REGULATOR_MODE_NORMAL,
> +	.boot_on = 1,
> +	.num_consumer_supplies = ARRAY_SIZE(platform_vddarm_consumers),
> +	.consumer_supplies = platform_vddarm_consumers,
> +};

The regulators might be used for some totally different purpose on
another system, and the configuration may be different even if the
purpose is the same.  The above also doesn't make much sense, you allow
changing modes but only support one mode.

You need to split out the regulator_init_data and let the board set it
up.
