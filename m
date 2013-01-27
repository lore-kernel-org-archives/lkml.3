Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3A0OLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:11:24 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:37142 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab3A0OLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:11:22 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Patil\, Rachna" <rachna@ti.com>
Cc: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        Benit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v4 4/8] MFD: ti_am335x_tscadc: add device tree binding information
References: <1358999112-31192-1-git-send-email-rachna@ti.com>
	<1358999112-31192-5-git-send-email-rachna@ti.com>
Date: Sun, 27 Jan 2013 15:11:14 +0100
In-Reply-To: <1358999112-31192-5-git-send-email-rachna@ti.com> (Rachna Patil's
	message of "Thu, 24 Jan 2013 09:15:08 +0530")
Message-ID: <87mwvubtrx.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "P" == Patil, Rachna <rachna@ti.com> writes:

Hi,

 P> From: "Patil, Rachna" <rachna@ti.com>
 P> Signed-off-by: Patil, Rachna <rachna@ti.com>
 P> ---
 P> Changes in v4:
 P> 	Subnodes and their properties documentation added.
 P> 	Non-standard properties prefixed with vendor name.

 P>  .../devicetree/bindings/mfd/ti_am335x_tscadc.txt   |   52 ++++++++++++++++++++
 P>  1 file changed, 52 insertions(+)
 P>  create mode 100644 Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt

 P> diff --git a/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
 P> new file mode 100644
 P> index 0000000..0100771
 P> --- /dev/null
 P> +++ b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
 P> @@ -0,0 +1,52 @@
 P> +Texas Instruments - TSC / ADC multi-functional device
 P> +
 P> +ti_tscadc is a multi-function device with touchscreen and ADC on chip.
 P> +This document describes the binding for mfd device.
 P> +
 P> +Required properties:
 P> +- compatible: "ti,ti-tscadc"

That's a very generic name (and double ti). How about ti,am3352-tsadc
instead?

No pinmux?


 P> +Sub-node device required properties:
 P> +tsc:
 P> +- ti,wires:  4/5/8 wire touchscreen support on the platform.
 P> +- ti,x-plate-resistance: X plate resistance.

In what kind of units?


 P> +- ti,steps-to-configure: A step is configured to read a single co-ordinate value,
 P> +			can be applied more number of times for better results.

So it is some kind of averaging? Doesn't tslib do that for you already?
Is there any limit to how many steps you can/will handle?


 P> +- ti,wire-config: Order for connecting wires on touchscreen.

ti,wires seems redundant given ti,wire-config (E.G. number of elements
in array). It is not clear to me what the magic values in wire-config
mean?

 P> +
 P> +adc:
 P> +- ti,adc-channels: Number of ADC channels used.

Is there ever any use case for this being something else than 8 -
ti,wires?

-- 
Bye, Peter Korsgaard
