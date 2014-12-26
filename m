Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaLZRTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:19:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33878 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLZRTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:19:47 -0500
Date: Fri, 26 Dec 2014 18:19:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 1/3] DT Binding for omap3 temperature sensor
Message-ID: <20141226171944.GA24756@amd>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-2-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419597294-21487-2-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-26 13:34:52, Sebastian Reichel wrote:
> OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> which can be used to determine the SoCs temperature. This provides a
> DT binding specification for the temperature monitor.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> ---
>  .../bindings/hwmon/omap3-temperature.txt           | 25 ++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/omap3-temperature.txt
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/omap3-temperature.txt b/Documentation/devicetree/bindings/hwmon/omap3-temperature.txt
> new file mode 100644
> index 0000000..99631ad
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/omap3-temperature.txt
> @@ -0,0 +1,25 @@
> +* OMAP3 temperature sensor
> +
> +The OMAP34xx and OMAP36xx processors contain a register in the syscon area,
> +which can be used to determine the SoCs temperature.
> +
> +Requires node properties:
> +- compatible :	should contain one of
> +	- "ti,omap34xx-temperature-sensor" for OMAP34xx
> +	- "ti,omap36xx-temperature-sensor" for OMAP36xx
> +- syscon :	Should be a phandle to system configuration node which
> +		encompases the temperature register
> +- clocks :	Should contain 32KHz fclk clock specifier
> +- clock-names :	Should contain clock names
> +	- "fck" for the 32KHz fclk clock specifier

I don't quite get it. The temperature sensor is internal on the CPU,
right? Why do we need device tree to describe it? As soon as we have
CPU that is compatible to ti,omap3430, we know everything we need to
know, no?

> +Example for omap34xx:
> +
> +/ {
> +	temperature-sensor {
> +		compatible = "ti,omap34xx-temperature-sensor";
> +		syscon = <&omap3_scm_general>;
> +		clocks = <&ts_fck>;
> +		clock-names = "fck";
> +	};
> +};

Or is there something that depends on the board there? Or do we want
to do it like this to be consistent with existing bindings?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
