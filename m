Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935402Ab3BTNTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:19:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50870 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934923Ab3BTNTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:19:15 -0500
Date: Wed, 20 Feb 2013 13:19:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, arnd@arndb.de, linus.walleij@stericsson.com,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [PATCH 01/35] mfd: ab8500-gpadc: Implemented suspend/resume
Message-ID: <20130220131912.GB13049@sirena.org.uk>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360933026-30325-2-git-send-email-lee.jones@linaro.org>
X-Cookie: That's what she said.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:56:32PM +0000, Lee Jones wrote:

> +static int ab8500_gpadc_suspend(struct device *dev)
> +{
> +	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> +
> +	mutex_lock(&gpadc->ab8500_gpadc_lock);
> +
> +	pm_runtime_get_sync(dev);
> +
> +	regulator_disable(gpadc->regu);
> +	return 0;
> +}

This doesn't look especially sane...  You're doing a runtime get, taking
the lock without releasing it and disabling the regulator.  This is
*very* odd, both the changelog and the code need to explain what's going
on and why it's safe in a lot more detail here.
