Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3COIGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:06:18 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40751 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3COIGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <1363207202-10858-2-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
 <1363207202-10858-1-git-send-email-dianders@chromium.org> <1363207202-10858-2-git-send-email-dianders@chromium.org>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 15 Mar 2013 13:35:52 +0530
Message-ID: <CAHfPSqC3SYAxK4vJydzabWzbLyfFXUF82WPCp6s4vr9WoeWWFw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] iio: adc: Document the regulator/clocks for exynos-adc
To: Doug Anderson <dianders@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On 14 March 2013 02:09, Doug Anderson <dianders@chromium.org> wrote:
> The exynos ADC won't work without a regulator called "vdd" and a clock
> called "adc".  Document this fact in the device tree bindings.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
Thanks for the correction. Clocks and regulator is needed.
I missed it out, as i did not submit the arch side changes
> ---
> Changes in v2: None
>
>  Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index f686378..96db940 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -20,6 +20,9 @@ Required properties:
>                         format is being dependent on which interrupt controller
>                         the Samsung device uses.
>  - #io-channel-cells = <1>; As ADC has multiple outputs
> +- clocks               From common clock binding: handle to adc clock.
> +- clock-names          From common clock binding: Shall be "adc".
> +- vdd-supply           VDD input supply.
>
>  Note: child nodes can be added for auto probing from device tree.
>
> @@ -31,6 +34,11 @@ adc: adc@12D10000 {
>         interrupts = <0 106 0>;
>         #io-channel-cells = <1>;
>         io-channel-ranges;
> +
> +       clocks = <&clock 303>;
> +       clock-names = "adc";
> +
> +       vdd-supply = <&buck5_reg>;
>  };
>
>
> --
> 1.8.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Shine bright,
(: Nav :)
