Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaCGDcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:32:10 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39858 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCGDcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:32:08 -0500
Date: Fri, 7 Mar 2014 11:32:01 +0800
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Mark Brown <broonie@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] mfd: da9063: Upgrade of register definitions to
 support production silicon
Message-ID: <20140307033201.GA17063@lee--X1>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
 <1e3f5e127c375a45b9a8e929fa99fa5c917b1dea.1394124002.git.stwiss.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e3f5e127c375a45b9a8e929fa99fa5c917b1dea.1394124002.git.stwiss.opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> This patch updates the register definitions for DA9063 to support the
> production silicon variant code ID (0x5). These changes are not backwards
> compatible with the previous register definitions and can only be used
> with the production variant of DA9063.
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> ---
> Checks performed with next-20140306/scripts/checkpatch.pl
>  registers.h               total: 0 errors, 0 warnings, 1032 lines checked
> 
> A brief summary of the changes include:
> 
> - Introduction of a new DA9063_REG_ALARM_S register (now appearing at
>   addr=0x46) allowing alarm second resolutions and which causes a shift
>   in the register map for the RTC registers;
> - Two new configuration registers DA9063_REG_CONFIG_M/N at 0x112 & 0x113;
> - Modified register ranges for MON_REG_[1-6] which now appears at the
>   addr=0x114 onwards;
> - New register addresses for the general purpose registers GP_ID_[0-19]
>   (now appearing at 0x121 onwards);
> - Renaming of some definitions to match our hardware design conventions;
> - There are also some bit-pattern additions that define some functionality
>   alterations of the registers. One notable addition is:
>   DA9063_BUCK_SLOWSTART can also be found in the CONTROL_B register and
>   enables a BUCK slow start (reduced inrush current; increased startup
>   time);
> 
> This patch applies against kernel version linux-next next-20140306
> 
>  include/linux/mfd/da9063/registers.h |  120 ++++++++++++++++++----------------
>  1 file changed, 62 insertions(+), 58 deletions(-)

What's the difference between this patch and the one you sent 2 days
ago?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
