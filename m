Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaBSLkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:40:42 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54497 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaBSLkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:40:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140219094037.GQ21483@n2100.arm.linux.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-2-git-send-email-ulf.hansson@linaro.org>
	<20140219094037.GQ21483@n2100.arm.linux.org.uk>
Date: Wed, 19 Feb 2014 12:40:39 +0100
Message-ID: <CAPDyKFqaS1H0vT8KJgmhm35X4dB9dUHsqMXee9Eg3V3t6Dn+uQ@mail.gmail.com>
Subject: Re: [PATCH 01/17] amba: Let runtime PM callbacks be available for CONFIG_PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2014 10:40, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Feb 04, 2014 at 04:58:42PM +0100, Ulf Hansson wrote:
>> Convert to the SET_PM_RUNTIME_PM macro while defining the runtime PM
>> callbacks. This means the callbacks becomes available for both
>> CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME, which is needed by drivers and
>> power domains.
>
> This patch is wrong, because it causes build errors:
>
> drivers/amba/bus.c:126:18: error: 'pm_generic_suspend_late' undeclared here (not in a function)
> drivers/amba/bus.c:127:18: error: 'pm_generic_resume_early' undeclared here (not in a function)
> drivers/amba/bus.c:128:17: error: 'pm_generic_freeze_late' undeclared here (not in a function)
> drivers/amba/bus.c:129:16: error: 'pm_generic_thaw_early' undeclared here (not in a function)
> drivers/amba/bus.c:130:19: error: 'pm_generic_poweroff_late' undeclared here (not in a function)
> drivers/amba/bus.c:131:19: error: 'pm_generic_restore_early' undeclared here (not in a function)
>
> The failing configuration is:
>
> # CONFIG_SUSPEND is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
>

Thanks for spotting this! I thought I had tested all the various
combinations, but obvisouly not.

Anyway to add some more clarify; it is not this patch that causes the
issue. It's patch 2, which introduces the late/early callbacks.

Though the problem need to be fixed in the PM core,
pm_generic_suspend_late etc is not set to NULL for !CONFIG_PM_SLEEP,
they should. I guess we should put patch 2 on hold until, right?

Kind regards
Ulf Hansson

> --
> FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
> in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
> Estimate before purchase was "up to 13.2Mbit".
