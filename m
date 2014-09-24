Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaIXIt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:49:26 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:59674 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaIXItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:49:19 -0400
Date: Wed, 24 Sep 2014 09:49:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Johan Hovold <jhovold@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Acked-by: Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH v9 00/10] rtc: at91sam9: add DT support
Message-ID: <20140924084911.GI17801@lee--X1>
References: <1411483725-31532-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411483725-31532-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not acceptable.  You have sent a 10 patch patch-set 5 times in
24hrs.  To make matters worse, the only patch that has any affiliation
to me has already been accepted.

Send a patch-set to the list and don't do anything until the patch has
either been accepted or the reviews to stop coming in.  Then re-send
(only the patches that have not yet been accepted) in a week or so, if
required.

If I have to deal with another 55 repeat emails again, you'll find
yourself as an entry in my spam filter.

> This patch series adds DT support to the atmel at91sam9 RTC driver.
> 
> It also removes any machine specific inclusions to prepare the migration
> to multi platform kernel support, and retain the slow clock to prevent
> the CCF from disabling it at the end of boot.
>   
> Best Regards,
> 
> Boris
> 
> Changes since v8:
>  - fix DT documentation
>  - add missing '\n' in dev_err messages
> 
> Changes since v7:
>  - fix typo
>  - fix sclk_rate test
>  - state that RTC_DRV_AT91SAM9_RTT and RTC_DRV_AT91SAM9_GPBR are no longer
>    used when booting a DT board
> 
> Changes since v6:
>  - fix typos
>  - add missing commit messages
>  - rework the Kconfig description
> 
> Changes since v5:
>  - replace 'rtc' by 'rtt' where appropriate
>  - fix commit messages
> 
> Changes since v4:
>  - add a TODO comment to remember removing non DT board support code
> 
> Changes since v3:
>  - add GPBR DT bindings doc
>  - fix a coding style issues
>  - add Alexandre's Acked-by
>  - change RTT DT bindings
> 
> Changes since v2:
>  - make use of syscon/regmap to avoid directly requesting/mapping a GPBR
>    memory region in the RTT driver
> 
> Changes since v1:
>  - remove non CCF specific case by adding the appropriate clk_lookup
>    entries in arch/arm/mach-at91/<soc-name>.c files
> 
> Boris BREZILLON (10):
>   rtc: at91sam9: remove references to mach specific headers
>   rtc: at91sam9: use standard readl/writel functions instead of raw
>     versions
>   rtc: at91sam9: replace devm_ioremap by devm_ioremap_resource
>   rtc: at91sam9: add DT support
>   rtc: at91sam9: make use of syscon/regmap to access GPBR registers
>   rtc: at91sam9: rework the Kconfig description
>   ARM: at91: add clk_lookup entry for RTT devices
>   rtc: at91sam9: use clk API instead of relying on AT91_SLOW_CLOCK
>   rtc: at91sam9: add DT bindings documentation
>   mfd: syscon: add Atmel GPBR DT bindings documention
> 
>  .../devicetree/bindings/mfd/atmel,gpbr.txt         |  15 +++
>  .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt |  23 ++++
>  arch/arm/mach-at91/at91sam9260.c                   |   2 +
>  arch/arm/mach-at91/at91sam9261.c                   |   2 +
>  arch/arm/mach-at91/at91sam9263.c                   |   4 +
>  arch/arm/mach-at91/at91sam9g45.c                   |   2 +
>  arch/arm/mach-at91/at91sam9rl.c                    |   2 +
>  arch/arm/mach-at91/clock.c                         |   2 +-
>  arch/arm/mach-at91/clock.h                         |   1 +
>  drivers/rtc/Kconfig                                |  24 ++--
>  drivers/rtc/rtc-at91sam9.c                         | 138 ++++++++++++++++-----
>  11 files changed, 177 insertions(+), 38 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel,gpbr.txt
>  create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
