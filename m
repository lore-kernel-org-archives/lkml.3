Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaLGRnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:43:24 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39863 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaLGRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:43:22 -0500
Message-ID: <548312D9.3070104@kernel.org>
Date: Sat, 06 Dec 2014 14:29:45 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 2/5] iio: sensorhub: Add sensorhub bindings
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-3-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1417809290-9662-3-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 19:54, Karol Wrona wrote:
> Add sensorhub bindings for sensorhub on Galaxy Gear 2.
> 
> Change-Id: I4ee25aef33c21a4662de230841de9a8684f2c26b
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Looks good to me.  Comments inline.  Note I either need a device tree
ack or a long delay before I can take this though.  Unlikely to get the
device tree ack as you haven't cc'd the maintainers or list ;)

I've added the cc's. Please make sure future versions have them or you'll
just be slowing the process down (particularly if no one notices they 
are missing!)

> ---
>  .../devicetree/bindings/iio/sensorhub.txt          |   46 ++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/sensorhub.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/sensorhub.txt b/Documentation/devicetree/bindings/iio/sensorhub.txt
> new file mode 100644
> index 0000000..2aca0c3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/sensorhub.txt
> @@ -0,0 +1,46 @@
> +Samsung Sensorhub driver
> +
> +Sensorhub is a MCU which manages several sensors and also plays the role
> +of a virtual sensor device.
> +
> +Required properties:
> +- compatible: "samsung,sensorhub-rinato" or "samsung,sensorhub-thermostat"
> +- spi-max-frequency: max SPI clock frequency
> +- interrupt-parent: interrupt parent
> +- interrupts: communication interrupt
> +- ap-mcu-gpio: [out] ap to sensorhub line - used during communication
> +- mcu-ap-gpio: [in] sensorhub to ap - used during communication
> +- mcu-reset: [out] sensorhub reset
as commented in previous patch, why do the first two have -gpio and the
third not?
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
We'll keep that under review.  Might make sense, sometimes, to unify the
drivers.  The different compatible will probably still be needed, but if
these devices proliferate I don't want two drivers for everything that
gets stuck behind them.
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

