Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3ISSFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:05:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44764 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3ISSFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:05:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
Message-ID: <20130919180512.5246.73360@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
Date: Thu, 19 Sep 2013 11:05:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Soren Brinkmann (2013-09-18 15:43:38)
> diff --git a/Documentation/devicetree/bindings/clock/silabs,si570.txt b/Documentation/devicetree/bindings/clock/silabs,si570.txt
> new file mode 100644
> index 0000000..7ab5c8b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/silabs,si570.txt
> @@ -0,0 +1,38 @@
> +Binding for Silicon Labs 570, 571, 598 and 599 programmable
> +I2C clock generators.
> +
> +Reference
> +This binding uses the common clock binding[1]. Details about the devices can be
> +found in the data sheets[2][3].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +[2] Si570/571 Data Sheet
> +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si570.pdf
> +[3] Si598/599 Data Sheet
> +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si598-99.pdf
> +
> +Required properties:
> + - compatible: Shall be one of "silabs,si570", "silabs,si571",
> +                              "silabs,si598", "silabs,si599"
> + - reg: I2C device address.
> + - #clock-cells: From common clock bindings: Shall be 0.
> + - factory-fout: Factory set default frequency. This frequency is part specific.
> +                The correct frequency for the part used has to be provided in
> +                order to generate the correct output frequencies. For more
> +                details, please refer to the data sheet.
> +
> +Optional properties:
> + - clock-output-names: From common clock bindings. Recommended to be "si570".
> + - clock-frequency: Output frequency to generate. This defines the output
> +                   frequency set during boot. It can be reprogrammed during
> +                   runtime using the common clock framework.
> + - temperature-stability-7ppm: Indicate a device with a temperature stability
> +                              of 7ppm

Some DT binding bike-shedding:

Should this be "temperature-stability-ppm = <7>;" ? Do you think that
this value might change in the future?

> diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
> new file mode 100644
> index 0000000..c20dfce
> --- /dev/null
> +++ b/drivers/clk/clk-si570.c
> @@ -0,0 +1,517 @@
<snip>
> +static bool si570_regmap_is_volatile(struct device *dev, unsigned int reg)
> +{
> +       switch (reg) {
> +       case 135:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
> +static bool si570_regmap_is_writeable(struct device *dev, unsigned int reg)
> +{
> +       switch (reg) {
> +       case 7 ... 18:
> +       case 135:
> +       case 137:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}

Should magic numbers above be symbolic constants?

Regards,
Mike
