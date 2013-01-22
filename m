Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3AVAcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:32:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:41767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3AVAcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:32:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,510,1355126400"; 
   d="scan'208";a="246752789"
Date: Tue, 22 Jan 2013 01:32:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v2 2/2] backlight: add new lp8788 backlight driver
Message-ID: <20130122003240.GD7409@sortiz-mobl>
References: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 21, 2012 at 07:55:23AM +0000, Kim, Milo wrote:
> TI LP8788 PMU supports regulators, battery charger, RTC, ADC, backlight driver
> and current sinks.
> This patch enables LP8788 backlight module.
> 
> (Brightness mode)
> The brightness is controlled by PWM input or I2C register.
> All modes are supported in the driver.
> 
> (Platform data)
> Configurable data can be defined in the platform side.
>  name                  : backlight driver name. (default: "lcd-backlight")
>  initial_brightness    : initial value of backlight brightness
>  bl_mode               : brightness control by PWM or lp8788 register
>  dim_mode              : dimming mode selection
>  full_scale            : full scale current setting
>  rise_time             : brightness ramp up step time
>  fall_time             : brightness ramp down step time
>  pwm_pol               : PWM polarity setting when bl_mode is PWM based
>  period_ns             : platform specific PWM period value. unit is nano.
> 
> The default values are set in case no platform data is defined.
> 
> Patch v2.
>  use generic PWM functions rather than lp8788 platform data function calls.
>  add configurable PWM period in the platform data.
>  replace module_init() and module_exit() with module_platform_driver().
> 
> Patch v1.
>  initial patch
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/video/backlight/Kconfig     |    6 +
>  drivers/video/backlight/Makefile    |    1 +
>  drivers/video/backlight/lp8788_bl.c |  350 +++++++++++++++++++++++++++++++++++
>  include/linux/mfd/lp8788.h          |   16 +-
For the MFD parts:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
