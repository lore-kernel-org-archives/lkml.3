Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaC2LJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 07:09:51 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47734 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaC2LJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 07:09:49 -0400
Message-ID: <5336AA42.8020606@kernel.org>
Date: Sat, 29 Mar 2014 11:10:58 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Marek Belisko <marek@goldelico.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv2 2/2] Documentation: DT: Document rx51-battery binding
References: <1393375569-21751-1-git-send-email-sre@debian.org> <1393705366-32420-1-git-send-email-sre@debian.org> <1393705366-32420-3-git-send-email-sre@debian.org>
In-Reply-To: <1393705366-32420-3-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/14 20:22, Sebastian Reichel wrote:
> Add devicetree binding documentation for rx51-battery,
> which is a simple A/D converter consumer.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
Acked-by: Jonathan Cameron <jic23@kernel.org>

Clearly this set has some rather large dependencies, but its good to go
once those are in place.

Jonathan
> ---
>   .../devicetree/bindings/power/rx51-battery.txt     | 25 ++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/power/rx51-battery.txt
>
> diff --git a/Documentation/devicetree/bindings/power/rx51-battery.txt b/Documentation/devicetree/bindings/power/rx51-battery.txt
> new file mode 100644
> index 0000000..9043845
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/rx51-battery.txt
> @@ -0,0 +1,25 @@
> +Binding for Nokia N900 battery
> +
> +The Nokia N900 battery status can be read via the TWL4030's A/D converter.
> +
> +Required properties:
> +- compatible: Should contain one of the following:
> + * "nokia,n900-battery"
> +- io-channels: Should contain IIO channel specifiers
> +               for each element in io-channel-names.
> +- io-channel-names: Should contain the following values:
> + * "temp" - The ADC channel for temperature reading
> + * "bsi"  - The ADC channel for battery size identification
> + * "vbat" - The ADC channel to measure the battery voltage
> +
> +Example from Nokia N900:
> +
> +battery: n900-battery {
> +	compatible = "nokia,n900-battery";
> +	io-channels = <&twl4030_madc 0>,
> +		      <&twl4030_madc 4>,
> +		      <&twl4030_madc 12>;
> +	io-channel-names = "temp",
> +			   "bsi",
> +			   "vbat";
> +};
>

