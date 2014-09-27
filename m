Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaI0KXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 06:23:11 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36090 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaI0KXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 06:23:08 -0400
Message-ID: <54269007.9000709@kernel.org>
Date: Sat, 27 Sep 2014 11:23:03 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-api@vger.kernel.org
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH 8/8] iio: Add ABI documentation for input current readings
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <b578cdd53527bb71c271eefadd1ce1bac175b5a7.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <b578cdd53527bb71c271eefadd1ce1bac175b5a7.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/14 11:53, Adam Thomson wrote:
> Add information on in_current related readings.
> 
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
This crossed with a similar patch also adding some docs for current channels.
That just missed this cycle anyway so I'll probably just merge this in as
an extension of that patch when we are happy with the rest of the series.
That patch covers the raw attribute but doesn't add the other entries..
(in the togreg branch of iio.git)

Jonathan
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index d760b02..37cd4d4 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -92,6 +92,18 @@ Description:
>  		is required is a consistent labeling.  Units after application
>  		of scale and offset are millivolts.
> 
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_raw
> +KernelVersion:	3.17
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Raw (unscaled no bias removal etc.) current measurement from
> +		channel Y. In special cases where the channel does not
> +		correspond to externally available input one of the named
> +		versions may be used. The number must always be specified and
> +		unique to allow association with event codes. Units after
> +		application of scale and offset are milliamps.
> +
>  What:		/sys/bus/iio/devices/iio:deviceX/in_capacitanceY_raw
>  KernelVersion:	3.2
>  Contact:	linux-iio@vger.kernel.org
> @@ -227,6 +239,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_z_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_offset
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_offset
> +What:		/sys/bus/iio/devices/iio:deviceX/in_current_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_tempY_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_temp_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_offset
> @@ -249,8 +263,11 @@ Description:
>  		to the _raw output.
> 
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_supply_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_current_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/out_voltageY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
