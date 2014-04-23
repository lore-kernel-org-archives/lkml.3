Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaDWMiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:38:06 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51362 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaDWMhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:37:54 -0400
Date: Wed, 23 Apr 2014 13:37:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: swarren@nvidia.com, wsa@the-dreams.de, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sjg@chromium.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sameo@linux.intel.com, jdelvare@suse.de,
        shane.huang@amd.com, maxime.ripard@free-electrons.com,
        laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, bjorn.andersson@sonymobile.com,
        kevin.strasser@linux.intel.com, linux@prisktech.co.nz, andrew@lunn.ch,
        andriy.shevchenko@linux.intel.com, schwidefsky@de.ibm.com,
        matt.porter@linaro.org, ch.naveen@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 6/7] i2c: ChromeOS EC tunnel driver
Message-ID: <20140423123746.GG640@lee--X1>
References: <1398185154-19404-1-git-send-email-dianders@chromium.org>
 <1398185154-19404-7-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398185154-19404-7-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Doug Anderson wrote:

> On ARM Chromebooks we have a few devices that are accessed by both the
> AP (the main "Application Processor") and the EC (the Embedded
> Controller).  These are:
> * The battery (sbs-battery).
> * The power management unit tps65090.
> 
> On the original Samsung ARM Chromebook these devices were on an I2C
> bus that was shared between the AP and the EC and arbitrated using
> some extranal GPIOs (see i2c-arb-gpio-challenge).
> 
> The original arbitration scheme worked well enough but had some
> downsides:
> * It was nonstandard (not using standard I2C multimaster)
> * It only worked if the EC-AP communication was I2C
> * It was relatively hard to debug problems (hard to tell if i2c issues
>   were caused by the EC, the AP, or some device on the bus).
> 
> On the HP Chromebook 11 the design was changed to:
> * The AP/EC comms were still i2c, but the battery/tps65090 were no
>   longer on the bus used for AP/EC communication.  The battery was
>   exposed to the AP through a limited i2c tunnel and tps65090 was
>   exposed to the AP through a custom Linux driver.
> 
> On the Samsung ARM Chromebook 2 the scheme is changed yet again, now:
> * The AP/EC comms are now using SPI for faster speeds.
> * The EC's i2c bus is exposed to the AP through a full i2c tunnel.
> 
> The upstream "tegra124-venice2" uses the same scheme as the Samsung
> ARM Chromebook 2, though it has a different set of components on the
> other side of the bus.
> 
> This driver supports the scheme used by the Samsung ARM Chromebook 2.
> Future patches to this driver could add support for the battery tunnel
> on the HP Chromebook 11 (and perhaps could even be used to access
> tps65090 on the HP Chromebook 11 instead of using a special driver,
> but I haven't researched that enough).
> 
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Andrew Bresticker <abrestic@chromium.org>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes in v2:
> - Update tunnel binding as per swarren
> 
>  .../devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt |  39 +++
>  drivers/i2c/busses/Kconfig                         |   9 +
>  drivers/i2c/busses/Makefile                        |   1 +
>  drivers/i2c/busses/i2c-cros-ec-tunnel.c            | 304 +++++++++++++++++++++
>  drivers/mfd/cros_ec.c                              |   5 +

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
