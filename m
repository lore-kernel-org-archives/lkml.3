Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaDDTSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:18:10 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60401 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbaDDTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:18:07 -0400
X-Auth-Info: w6o9tpY0LeHdNzEEcI+s9mDDH3c5mh0TJFc2N69zyi4=
Date: Fri, 4 Apr 2014 21:17:57 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>, devicetree@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/3] i2c: cadence: Document device tree bindings
Message-ID: <20140404191757.GR11339@book.gsilab.sittig.org>
References: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 10:59 -0700, Soren Brinkmann wrote:
> 
> Add device tree binding documentation for the Cadence I2C controller.
> 
> [ ... ]
> 
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> @@ -0,0 +1,21 @@
> +Binding for the Cadence I2C controller
> +
> +Required properties:
> +  compatible: Compatibility string. Must be 'cdns,i2c-r1p10'.
> +  clocks: From common clock bindings. Phandle to input clock.

the usual complaint:  'clocks' items are not just phandles (your
example even suggests this); either adjust the description to
something correct, or just refer to the common clock bindings to
not duplicate their description

but I guess the I2C controller's binding should explicitly state
which clocks are required, and you might want to consider
'clock-names', too

> +
> +Optional properties:
> +  clock-frequency: Desired operating frequency, in Hz, of the bus (actual may
> +		   be lower). Defaults to 400000 if not specified.

is the value default a feature of the Linux implementation, or
consciously designed to be in the binding spec?  and I agree that
the default should be the standard I2C speed instead of fast mode

> +
> +Example:
> +
> +	i2c@e0004000 {
> +		compatible = "cdns,i2c-r1p10";
> +		clocks = <&clkc 38>;
> +		interrupts = <0 25 4>;
> +		reg = <0xE0004000 0x1000>;
> +		clock-frequency = <400000>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +	};

use lower case hex digits, consider symbolic identifiers for
clocks and interrupt flags

the example has many more properties than the binding describes,
the additional items aren't even optional -- you might want to
refer to a few more common or general bindings


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
