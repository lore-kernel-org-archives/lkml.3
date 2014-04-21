Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaDURxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:53:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47031 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaDURxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:53:09 -0400
Message-ID: <53555AFC.5020203@wwwdotorg.org>
Date: Mon, 21 Apr 2014 11:53:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, lee.jones@linaro.org,
        swarren@nvidia.com, wsa@the-dreams.de
CC: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
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
Subject: Re: [RESEND PATCH 6/7] i2c: ChromeOS EC tunnel driver
References: <1397759814-3588-1-git-send-email-dianders@chromium.org> <1397759814-3588-7-git-send-email-dianders@chromium.org>
In-Reply-To: <1397759814-3588-7-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 12:36 PM, Doug Anderson wrote:
> On ARM Chromebooks we have a few devices that are accessed by both the
> AP (the main "Application Processor") and the EC (the Embedded
> Controller).  These are:
> * The battery (sbs-battery).
> * The power management unit tps65090.
...
> On the Samsung ARM Chromebook 2 the scheme is changed yet again, now:
> * The AP/EC comms are now using SPI for faster speeds.
> * The EC's i2c bus is exposed to the AP through a full i2c tunnel.
...
> This driver supports the scheme used by the Samsung ARM Chromebook 2.
> Future patches to this driver could add support for the battery tunnel
> on the HP Chromebook 11 (and perhaps could even be used to access
> tps65090 on the HP Chromebook 11 instead of using a special driver,
> but I haven't researched that enough).

> diff --git a/Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt b/Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt

> +I2C bus that tunnels through the ChromeOS EC (cros-ec)
> +======================================================
> +On some ChromeOS board designs we've got a connection to the EC (embedded
> +controller) but no direct connection to some devices on the other side of
> +the EC (like a battery and PMIC).  To get access to those devices we need
> +to tunnel our i2c commands through the EC.
> +
> +The node for this device should be under a cros-ec node like google,cros-ec-spi
> +or google,cros-ec-i2c.
> +
> +
> +Required properties:
> +- compatible: google,cros-ec-i2c-tunnel
> +- google,remote-bus: The EC bus we'd like to talk to.

It's probably worth mentioning here that the node represents a single
I2C bus, and hence is expected to contain child nodes representing I2C
devices. Perhaps:

Optional child nodes:
- One node per I2C device connected to the tunnelled I2C bus.

