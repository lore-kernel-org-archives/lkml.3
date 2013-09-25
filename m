Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3IYT0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:26:20 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:48489 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3IYT0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:26:19 -0400
Date: Wed, 25 Sep 2013 15:26:13 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Wendy Ng <wendy.ng@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>,
        Markus Mayer <mmayer@broadcom.com>
Subject: Re: [PATCH 1/3] thermal: bcm281xx: Add thermal driver
Message-ID: <20130925192609.GB25191@ohporter.com>
References: <1379958698-7554-1-git-send-email-wendy.ng@broadcom.com>
 <1379958698-7554-2-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379958698-7554-2-git-send-email-wendy.ng@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:51:36AM -0700, Wendy Ng wrote:
> This adds the support for reading out temperature from Broadcom bcm281xx
> SoCs.
> 
> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> ---
>  .../bindings/thermal/bcm-kona-thermal.txt          |   18 +++
>  drivers/thermal/Kconfig                            |   10 ++
>  drivers/thermal/Makefile                           |    1 +
>  drivers/thermal/bcm_thermal.c                      |  170 ++++++++++++++++++++
>  4 files changed, 199 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>  create mode 100644 drivers/thermal/bcm_thermal.c
> 
> diff --git a/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
> new file mode 100644
> index 0000000..acca99e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
> @@ -0,0 +1,18 @@
> +* Broadcom Kona Thermal Management Unit
> +
> +This version is for the BCM281xx family of SoCs.
> +
> +Required properties:
> +- compatible : "brcm,bcm11351-thermal", "brcm,kona-thermal"
> +- reg : Address range of the thermal register
> +- thermal-name: this entry must be specified and it will be passed into
> +thermal_zone_device_register().  This name will also be reported under Hwmon
> +sysfs 'name' attribute.
> +
> +Example:
> +	thermal@34008000 {
> +		compatible = "brcm,bcm11351-thermal", "brcm,kona-thermal";
> +		reg = <0x34008000 0x0024>;
> +		thermal-name = "bcm_kona_therm";
> +		status = "disabled";
> +	};
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index dbfc390..7f823f0 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -134,6 +134,16 @@ config KIRKWOOD_THERMAL
>  	  Support for the Kirkwood thermal sensor driver into the Linux thermal
>  	  framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
>  
> +config BCM_THERMAL
> +	tristate "Temperature sensor on Broadcom BCM281xx family of SoCs"
> +	depends on ARCH_BCM

Hi Wendy,

I just noticed that, depending on acceptance, this could collide with
Christian's ARCH_BCM->ARCH_BCM_MOBILE rename that is expected to go into
3.13. I'm not sure if this series is targeted for 3.13 (due to the discussion
about Eduardo's subsystem changes that impact it). If it is, you might
want to rebase on Christian's rename series
http://www.spinics.net/lists/arm-kernel/msg274963.html and use
ARCH_BCM_MOBILE here.

-Matt

> +	default y
> +	help
> +	  If you say yes here you get support for TMU (Thermal Management
> +	  Unit) on Broadcom BCM281xx family of SoCs. This provides thermal
> +	  monitoring of CPU clusters, graphics, and SoC glue, but does not
> +	  include monitoring of charger temperature.

