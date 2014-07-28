Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaG1Gw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:52:59 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:60131 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaG1Gw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:52:57 -0400
Date: Mon, 28 Jul 2014 07:52:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        RTC-LINUX <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Support Opensource <support.opensource@diasemi.com>
Subject: Re: [RFC V2] mfd: da9063: Add support for AD silicon variant
Message-ID: <20140728065251.GA5273@lee--X1>
References: <201407211058.s6LAwtk8003839@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201407211058.s6LAwtk8003839@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Opensource [Steve Twiss] wrote:

> 
> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> Add register definitions for DA9063 AD (0x3) silicon variant ID
> the ability to choose the silicon variant at run-time using regmap
> configuration. This patch also adds RTC support for the AD silicon
> changes.
> 
> It adds both BB and AD support as regmap ranges and then makes the
> distinction between the two tables at run-time. This allows both AD
> and BB silicon variants to be supported at the same time.
> 
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> ---
> Checks performed with linux-next/v3.16-rc5/scripts/checkpatch.pl
>  rtc-da9063.c              total: 0 errors, 0 warnings, 353 lines checked
>  da9063-core.c             total: 0 errors, 0 warnings, 188 lines checked
>  da9063-i2c.c              total: 0 errors, 0 warnings, 266 lines checked
>  core.h                    total: 0 errors, 0 warnings, 98 lines checked
>  registers.h               total: 0 errors, 0 warnings, 1073 lines checked
> 
> Thank you for your quick responses to my RFC-V1.
> 
> This is in reply to comments made by Lee Jones, Alessandro Zummo and
> Philipp Zabel. Please see the RFC-V1 thread for further details on
> these discussions: https://lkml.org/lkml/2014/7/16/478
> 
> Adding AD support using a compile-time flag under a new menu item in
> Kconfig proved very unpopular for two main reasons.
> 
> - Using ifdef else statements throughout the code
> - Not supporting AD and BB silicon variants at the same time
> 
> This RFC-V2 patch uses the method proposed by Philipp Zabel in his
> reply e-mail: https://lkml.org/lkml/2014/7/18/219
> and makes use of the regmap configuration method in da9063-i2c.c
> 
> This patch applies against linux-next and v3.16-rc5
> 
> Regards,
> Steve Twiss, Dialog Semiconductor Ltd.
> 
>  drivers/mfd/da9063-core.c            |    6 +-
>  drivers/mfd/da9063-i2c.c             |  134 +++++++++++++++++++++++++++-------
>  drivers/rtc/rtc-da9063.c             |   54 +++++++++-----
>  include/linux/mfd/da9063/core.h      |    3 +-
>  include/linux/mfd/da9063/registers.h |  129 +++++++++++++++++++++-----------
>  5 files changed, 236 insertions(+), 90 deletions(-)

Patch looks good to me.  Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
