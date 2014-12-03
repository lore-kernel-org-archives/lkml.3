Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaLCXOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:14:45 -0500
Received: from mout.gmx.net ([212.227.17.22]:60020 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaLCXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:14:44 -0500
Message-ID: <547F9958.1020807@gmx.de>
Date: Thu, 04 Dec 2014 00:14:32 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 2/5] sensorhub: Add sensorhub bindings
References: <1416593957-19788-1-git-send-email-k.wrona@samsung.com> <1416593957-19788-3-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1416593957-19788-3-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:vrwyXvmYtdzsJyvm0245k9UtL5aeBhdyDZRWWzPAbsbdKRRDmsY
 uMU/bLbLz3R34lSEQuFb7GLCDUTPTFU0aZloin94QsHDH+QubJX1ZVhIAmWjwbxlGNc+ief
 Iix3tn2GTF9iiyzljuUbZaKdeYkn4pPoEQKtISXWWHYJ3B1IXKv2hH35x2avZHnjik//sUK
 pC6rbBVi6XVisZd9aBzJw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Wrona schrieb am 21.11.2014 um 19:19:
> Add sensorhub bindings for sensorhub on Galaxy Gear 2.
Some comments inline.
> 
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/misc/sensorhub.txt         |   46 ++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/sensorhub.txt
> 
> diff --git a/Documentation/devicetree/bindings/misc/sensorhub.txt b/Documentation/devicetree/bindings/misc/sensorhub.txt
> new file mode 100644
> index 0000000..088bf32
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/sensorhub.txt
> @@ -0,0 +1,46 @@
> +Samsung Sensorhub driver
> +
> +Sensorhub is MCU which manages several sensors and also play the role
... is a MCU ... also plays the ...
> +of virtual sensor device.
of a virtual ...
> +
> +Required properties:
> +- compatible: "samsung,sensorhub-rinato" or "samsung,sensorhub-thermostat"
> +- spi-max-frequency: max SPI clock frequency
> +- interrupt-parent
Missing description.
> +- interrupts: communication interrupt
> +- ap-mcu-gpio: [out] ap to sensorhub line - used during communication
> +- mcu-ap-gpio: [in] sensorhub to ap - used during communication
> +- mcu-reset: [out] sensorhub reset
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
> +
> +Example:
> +
> +	shub_spi: shub {
> +		compatible = "samsung,sensorhub-rinato";
> +		spi-max-frequency = <5000000>;
> +		interrupt-parent = <&gpx0>;
> +		interrupts = <2 0>;
> +		ap-mcu-gpio = <&gpx0 0 0>;
> +		mcu-ap-gpio = <&gpx0 4 0>;
> +		mcu-reset = <&gpx0 5 0>;
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

