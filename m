Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbbAPISn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:18:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbbAPISk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:18:40 -0500
Message-ID: <54B8C933.7020502@redhat.com>
Date: Fri, 16 Jan 2015 09:17:55 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the
 SATA port
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com> <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 15-01-15 15:09, Gregory CLEMENT wrote:
> Add the regulators to each SATA port.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>   arch/arm/boot/dts/armada-388-gp.dts | 126 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 126 insertions(+)
>
> diff --git a/arch/arm/boot/dts/armada-388-gp.dts b/arch/arm/boot/dts/armada-388-gp.dts
> index 4df22bf91683..590b383db323 100644
> --- a/arch/arm/boot/dts/armada-388-gp.dts
> +++ b/arch/arm/boot/dts/armada-388-gp.dts
> @@ -173,6 +173,16 @@
>   				status = "okay";
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> +
> +				sata0: sata-port@0 {
> +					reg = <0>;
> +					target-supply = <&reg_5v_sata0>;
> +				};
> +
> +				sata1: sata-port@1 {
> +					reg = <1>;
> +					target-supply = <&reg_5v_sata1>;
> +				};
>   			};
>
>   			sata@e0000 {
> @@ -181,6 +191,16 @@
>   				status = "okay";
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> +
> +				sata2: sata-port@0 {
> +					reg = <0>;
> +					target-supply = <&reg_5v_sata2>;
> +				};
> +
> +				sata3: sata-port@1 {
> +					reg = <1>;
> +					target-supply = <&reg_5v_sata3>;
> +				};
>   			};
>
>   			sdhci@d8000 {
> @@ -278,6 +298,112 @@
>   		regulator-always-on;
>   		gpio = <&expander0 4 GPIO_ACTIVE_HIGH>;
>   	};
> +
> +	reg_sata0: pwr-sata0 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "pwr_en_sata0";
> +		enable-active-high;
> +		regulator-always-on;
> +
> +	};
> +
> +	reg_5v_sata0: v5-sata0 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v5.0-sata0";
> +		regulator-min-microvolt = <5000000>;
> +		regulator-max-microvolt = <5000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata0>;
> +	};
> +
> +	reg_12v_sata0: v12-sata0 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v12.0-sata0";
> +		regulator-min-microvolt = <12000000>;
> +		regulator-max-microvolt = <12000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata0>;
> +	};

AFAIK the separate v5 / 12v regulators you're creating here
are not used anywhere. So I guess there just here to
accurately / completely describe the power topology ?

> +
> +	reg_sata1: pwr-sata1 {
> +		regulator-name = "pwr_en_sata1";
> +		compatible = "regulator-fixed";
> +		regulator-min-microvolt = <12000000>;
> +		regulator-max-microvolt = <12000000>;
> +		enable-active-high;
> +		regulator-always-on;


The always on here seems to a bit weird, wasn't the
whole purpose of this patch set to teach ahci_platform
to turn it on as needed ?

You do probably want to put a regulator-boot-on here so
that disks do not get an unwanted powercycle (bad for
their lifetime) when the firmware has already turned on
the disk. Downside of using regulator-boot-on is that if
the power is not actually turned on no power-on-delay is
done, but we're not using a power on delay anyways.

The same goes for reg_sata2 & reg_sata3.

> +		gpio = <&expander0 3 GPIO_ACTIVE_HIGH>;
> +	};
> +
> +	reg_5v_sata1: v5-sata1 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v5.0-sata1";
> +		regulator-min-microvolt = <5000000>;
> +		regulator-max-microvolt = <5000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata1>;
> +	};
> +
> +	reg_12v_sata1: v12-sata1 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v12.0-sata1";
> +		regulator-min-microvolt = <12000000>;
> +		regulator-max-microvolt = <12000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata1>;
> +	};
> +
> +	reg_sata2: pwr-sata2 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "pwr_en_sata2";
> +		enable-active-high;
> +		regulator-always-on;
> +		gpio = <&expander0 11 GPIO_ACTIVE_HIGH>;
> +	};
> +
> +	reg_5v_sata2: v5-sata2 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v5.0-sata2";
> +		regulator-min-microvolt = <5000000>;
> +		regulator-max-microvolt = <5000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata2>;
> +	};
> +
> +	reg_12v_sata2: v12-sata2 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v12.0-sata2";
> +		regulator-min-microvolt = <12000000>;
> +		regulator-max-microvolt = <12000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata2>;
> +	};
> +
> +	reg_sata3: pwr-sata3 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "pwr_en_sata3";
> +		enable-active-high;
> +		regulator-always-on;
> +		gpio = <&expander0 12 GPIO_ACTIVE_HIGH>;
> +	};
> +
> +	reg_5v_sata3: v5-sata3 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v5.0-sata3";
> +		regulator-min-microvolt = <5000000>;
> +		regulator-max-microvolt = <5000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata3>;
> +	};
> +
> +	reg_12v_sata3: v12-sata3 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "v12.0-sata3";
> +		regulator-min-microvolt = <12000000>;
> +		regulator-max-microvolt = <12000000>;
> +		regulator-always-on;
> +		vin-supply = <&reg_sata3>;
> +	};
>   };
>
>   &pinctrl {
>

Regards,

Hans
