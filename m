Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3LWL6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:58:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42727 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3LWL6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:58:05 -0500
Date: Mon, 23 Dec 2013 11:57:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        vpalatin@chromium.org, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <20131223115746.GR30815@sirena.org.uk>
References: <1387776268-23036-1-git-send-email-wenyou.yang@atmel.com>
 <1387776328-23079-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387776328-23079-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/3] regulator: act8865: add PMIC act8865 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 01:25:28PM +0800, Wenyou Yang wrote:

> +static int act8865_set_suspend_voltage(struct regulator_dev *rdev, int uV)
> +{
> +	u32	selector;
> +
> +	selector = regulator_map_voltage_iterate(rdev, uV, uV);
> +
> +	return regulator_set_voltage_sel_regmap(rdev, selector);
> +}

This looks wrong - it's going to set the normal voltage register that is
set for runtime voltage changes.  The suspend operations are only for
setting separate voltage registers, many PMICs know about system suspend
and provide separate settings for that.  If this one doesn't then it
shouldn't implement this operation.

Otherwise this looked good.
