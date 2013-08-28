Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3H1NR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:17:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64758 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab3H1NR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:17:27 -0400
Date: Wed, 28 Aug 2013 14:17:24 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "srinivas.pandruvada@linux.intel.com" 
	<srinivas.pandruvada@linux.intel.com>,
        "lars@metafoo.de" <lars@metafoo.de>
Subject: Re: [PATCH v5 2/2] iio: add Bosch BMA180 acceleration sensor driver
Message-ID: <20130828131724.GE10250@e106331-lin.cambridge.arm.com>
References: <1377687678-5761-1-git-send-email-o.v.kravchenko@globallogic.com>
 <1377687678-5761-2-git-send-email-o.v.kravchenko@globallogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377687678-5761-2-git-send-email-o.v.kravchenko@globallogic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 12:01:18PM +0100, Oleksandr Kravchenko wrote:
> This patch adds IIO driver for Bosch BMA180 triaxial
> acceleration sensor.
> http://dlnmh9ip6v2uc.cloudfront.net/datasheets/
>                 Sensors/Accelerometers/BST-BMA180-DS000-07_2.pdf
> 
> Stephen Warren:
> The binding looks simple enough to me, so the binding

You can lose the above two lines, just the Acked-by is good enough. :)

> Acked-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> ---
>  .../devicetree/bindings/iio/accel/bma180.txt       |   24 +
>  drivers/iio/accel/Kconfig                          |   12 +
>  drivers/iio/accel/Makefile                         |    2 +
>  drivers/iio/accel/bma180.c                         |  676 ++++++++++++++++++++
>  4 files changed, 714 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/accel/bma180.txt
>  create mode 100644 drivers/iio/accel/bma180.c
> 
> diff --git a/Documentation/devicetree/bindings/iio/accel/bma180.txt b/Documentation/devicetree/bindings/iio/accel/bma180.txt
> new file mode 100644
> index 0000000..c593357
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/accel/bma180.txt
> @@ -0,0 +1,24 @@
> +* Bosch BMA180 triaxial acceleration sensor
> +
> +http://omapworld.com/BMA180_111_1002839.pdf
> +
> +Required properties:
> +
> +  - compatible : should be "bosch,bma180"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
> +  - interrupt-parent : should be the phandle for the interrupt controller
> +
> +  - interrupts : interrupt mapping for GPIO IRQ, it should by configured with
> +               flags IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING
> +

One thing I noticed from the datasheet is that this has a clock input
(sck) and two regulator inputs (vdd and vddio). It might not always be
the case that these are configured statically, so they may need to be
described in the dt. It's possible that they could be added later as
optional properties, though.

Thanks,
Mark.
