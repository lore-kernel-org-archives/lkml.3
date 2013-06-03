Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3FCU7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:59:37 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58169 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCU7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:59:35 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: omap: convert to module_platform_driver()
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
	<1366723151-23209-2-git-send-email-grygorii.strashko@ti.com>
Date: Mon, 03 Jun 2013 13:59:31 -0700
In-Reply-To: <1366723151-23209-2-git-send-email-grygorii.strashko@ti.com>
	(Grygorii Strashko's message of "Tue, 23 Apr 2013 16:19:09 +0300")
Message-ID: <87fvwylxl8.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> The OMAP I2C driver has a relation to pinctrl-single driver. As result,
> its probe will be deferred during system boot until late init time,
> because the pinctrl-single is initizalized as moudle/device init time.
> This, in turn, will delay initialization of all I2C devices (like mfd,
> I2C regulators and etc.) and cause boot delay (more over, it can broken
> initialization of drivers which are not ready to use deferred probe
> mechanism yet, for example DSS).
>
> There are no sense to keep OMAP I2C initialization on subsys init layer
> any more, hence shift it to module/device layer where the i2c <-->
> pinctrl-single dependency is resolved in drivers/Makefile now.
>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: linux-omap@vger.kernel.org
> Cc: linux-i2c@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Testing this patch with PATCH 1/2, the twl_rtc driver fails to correctly
initialize on OMAP3:

         twl_rtc rtc.22: hctosys: invalid date/time

instead of the expected result:

          twl_rtc rtc.22: setting system clock to 2000-01-01 00:00:00 UTC (946684800)

so something is still not right for the init sequence.

Kevin
