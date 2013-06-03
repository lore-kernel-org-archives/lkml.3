Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3FCU6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:58:10 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50308 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3FCU6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:58:08 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Strashko\, Grygorii" <grygorii.strashko@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: twl-core: convert to module_init()
References: <1370033794-5357-1-git-send-email-khilman@linaro.org>
	<902E09E6452B0E43903E4F2D568737AB31F402@DNCE04.ent.ti.com>
Date: Mon, 03 Jun 2013 13:58:03 -0700
In-Reply-To: <902E09E6452B0E43903E4F2D568737AB31F402@DNCE04.ent.ti.com>
	(Grygorii Strashko's message of "Sat, 1 Jun 2013 07:59:03 +0000")
Message-ID: <87li6qlxno.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Strashko, Grygorii" <grygorii.strashko@ti.com> writes:

> Hi Kevin,
>
> It's done alreday here:
> https://patchwork.kernel.org/patch/2477541/ - mfd: twl-core: convert to module_i2c_driver()
>  (Samuel has taken this one)

Excellent, thanks for pointing it out, somehow I missed that thread.  My
patch can be ignored.

> - and -
> https://patchwork.kernel.org/patch/2477561/ - i2c: omap: convert to module_platform_driver()
>  (you can vote here - TWL can't be shifted without I2C)

This one (combined with the first one) makes twl_rtc fail to initialize
properly on OMAP3 DT boot, with an error like this:

         twl_rtc rtc.22: hctosys: invalid date/time

Reverting that you get the expected result:

          twl_rtc rtc.22: setting system clock to 2000-01-01 00:00:00 UTC (946684800)

I didn't debug any further, but for now, at least patch 2 needs a little
more work/debug.

Kevin
