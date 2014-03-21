Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbaCUOjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:39:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51821 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaCUOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:39:15 -0400
Date: Fri, 21 Mar 2014 09:36:04 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, broonie@kernel.org
Subject: Re: [PATCH] regulator: Add new driver for ST's PWM controlled
 voltage regulators
Message-ID: <20140321143604.GY18529@joshc.qualcomm.com>
References: <1395397296-8196-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395397296-8196-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 10:21:36AM +0000, Lee Jones wrote:
> +static int st_pwm_regulator_set_voltage_sel(struct regulator_dev *dev,
> +					    unsigned selector)
> +{
> +	struct st_pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
> +	int dutycycle;
> +	int ret;
> +
> +	if (selector >= dev->desc->n_voltages)
> +		return -EINVAL;

If this case is ever hit, I would argue it's a bug in the regulator
core.

> +static struct st_pwm_voltages b2105_duty_cycle_table[] = {

const?

> +	{ .uV = 1114000, .dutycycle = 0,  },
> +	{ .uV = 1095000, .dutycycle = 10, },
> +	{ .uV = 1076000, .dutycycle = 20, },
> +	{ .uV = 1056000, .dutycycle = 30, },
> +	{ .uV = 1036000, .dutycycle = 40, },
> +	{ .uV = 1016000, .dutycycle = 50, },
> +	/* WARNING: Values above 50% duty-cycle cause boot failures. */
> +};
> +
> +static const struct regulator_desc b2105_desc = {
> +	.name		= "b2105-pwm-regulator",
> +	.ops		= &st_pwm_regulator_voltage_ops,
> +	.type		= REGULATOR_VOLTAGE,
> +	.owner		= THIS_MODULE,
> +	.n_voltages	= ARRAY_SIZE(b2105_duty_cycle_table),
> +	.supply_name    = "pwm",
> +};
> +
> +static const struct st_pwm_regulator_pdata b2105_info = {
> +	.desc		  = &b2105_desc,
> +	.duty_cycle_table = b2105_duty_cycle_table,
> +};
> +
> +static struct of_device_id st_pwm_of_match[] = {

const?

Other than that:

Reviewed-by: Josh Cartwright <joshc@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
