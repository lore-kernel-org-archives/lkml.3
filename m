Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaINPps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:45:48 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55108 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaINPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:45:47 -0400
Message-ID: <5415B82A.8000205@kernel.org>
Date: Sun, 14 Sep 2014 16:45:46 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 3/6] sensorhub: Add sensorhub bindings
References: <1409756150-30889-1-git-send-email-k.wrona@samsung.com> <1409756150-30889-4-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1409756150-30889-4-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:55, Karol Wrona wrote:
> Add sensorhub bindings for sensorhub on Galaxy Gear 2.
> 
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/misc/sensorhub.txt         |   51 ++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/sensorhub.txt
> 
> diff --git a/Documentation/devicetree/bindings/misc/sensorhub.txt b/Documentation/devicetree/bindings/misc/sensorhub.txt
> new file mode 100644
> index 0000000..b43c2b7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/sensorhub.txt
> @@ -0,0 +1,50 @@
> +Samsung Sensorhub driver
> +
> +Sensorhub is MCU which manages several sensors and also play the role
> +of virtual sensor device.
> +
> +Required properties:
> +- compatible: "samsung,sensorhub-rinato" or "samsung,sensorhub-thermostat"
> +- spi-max-frequency: max SPI clock frequency
> +- interrupt-parent
> +- interrupts: communication interrupt
> +- ap-mcu-int: [out] ap to sensorhub line - used during communication
Ah, why call it int?  I assumed when reading some of the code that it was an interrupt line.

> +- mcu-ap-int: [in] sensorhub to ap - used during communication
> +- mcu-reset: [out] sensorhub reset
> +- mag-table: magnitude table
Magnitude of what?
> +
> +Optional properties:
> +- sensor's nodes:
> +  compatible = "samsung,mpu6500-accel"
> +  compatible = "samsung,mpu6500-gyro"
> +  compatible = "samsung,adpd142"
> +
> +Sensor compatibles are used to match proper sensor driver to real sensor on
> +the board. The firmware does not give such information, so it helps to specify
> +some sensors properties. Sensors have "samsung" prefixes because frequently
> +they will not have much in common with sensors used without sensorhub because
> +it can do some data processing.
I wonder if we can make the ssp bit explicit as well.  Chances are samsung might
have another device similar to this (but with a different driver) in future.

> +
> +Example:
> +
> +	shub_spi: shub {
> +		compatible = "samsung,rinato-ssp-spi";
> +		spi-max-frequency = <5000000>;
> +		interrupt-parent = <&gpx0>;
> +		interrupts = <2 0>;
> +		ap-mcu-int = <&gpx0 0 0>;
> +		mcu-ap-int = <&gpx0 4 0>;
> +		mcu-reset = <&gpx0 5 0>;
> +		mag-table = /bits/ 8 <110 85 171 71 203 195 0 67
> +				208 56 175 244 206 213 0 92 250 0
> +				55 48 189 252 171 243 13 45 250>;
> +		sensor@0 {
> +			compatible = "samsung,mpu6500-accel";
> +		};
> +		sensor@1 {
> +			compatible = "samsung,mpu6500-gyro";
> +		};
> +		sensor@2 {
> +			compatible = "samsung,adpd142";
> +		};
> +	};
> 
