Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaBSJky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:40:54 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42180 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752920AbaBSJkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:40:51 -0500
Date: Wed, 19 Feb 2014 09:40:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 01/17] amba: Let runtime PM callbacks be available for
	CONFIG_PM
Message-ID: <20140219094037.GQ21483@n2100.arm.linux.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org> <1391529538-21685-2-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391529538-21685-2-git-send-email-ulf.hansson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 04:58:42PM +0100, Ulf Hansson wrote:
> Convert to the SET_PM_RUNTIME_PM macro while defining the runtime PM
> callbacks. This means the callbacks becomes available for both
> CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME, which is needed by drivers and
> power domains.

This patch is wrong, because it causes build errors:

drivers/amba/bus.c:126:18: error: 'pm_generic_suspend_late' undeclared here (not in a function)
drivers/amba/bus.c:127:18: error: 'pm_generic_resume_early' undeclared here (not in a function)
drivers/amba/bus.c:128:17: error: 'pm_generic_freeze_late' undeclared here (not in a function)
drivers/amba/bus.c:129:16: error: 'pm_generic_thaw_early' undeclared here (not in a function)
drivers/amba/bus.c:130:19: error: 'pm_generic_poweroff_late' undeclared here (not in a function)
drivers/amba/bus.c:131:19: error: 'pm_generic_restore_early' undeclared here (not in a function)

The failing configuration is:

# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
