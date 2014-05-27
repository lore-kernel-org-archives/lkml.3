Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaE0PXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:23:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:44287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaE0PXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:23:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,920,1392192000"; 
   d="scan'208";a="518387969"
Message-ID: <5384AEFE.2010804@linux.intel.com>
Date: Tue, 27 May 2014 08:27:58 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org
Subject: Re: [PATCH] IIO: Added iio magn_north ABI documentation
References: <538076CA.6050809@kernel.org> <1401160821-5006-1-git-send-email-reyad.attiyat@gmail.com> <1401160821-5006-2-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1401160821-5006-2-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 08:20 PM, Reyad Attiyat wrote:
> Added documentation for HID magnometer true/magnetic north sensor.
> ---
>   Documentation/ABI/testing/sysfs-bus-iio | 76 +++++++++++++++++++++++++++++++++
>   1 file changed, 76 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 6e02c50..3305fe8 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -165,6 +165,10 @@ Description:
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_raw
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_raw
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_magnetic_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_magnetic_tilt_compensated_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_tilt_compensated_raw
These names are very long. May be we remove work "magnetic" as there 
attributes only apply to magnetometer.
>   KernelVersion:	2.6.35
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> @@ -249,6 +253,10 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_magnetic_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_magnetic_tilt_compensated_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_tilt_compensated_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
>   KernelVersion:	2.6.35
> @@ -436,6 +444,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_tilt_compensated_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_tilt_compensated_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_compensated_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_compensated_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_thresh_rising_en
> @@ -481,6 +497,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_y_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_tilt_compensated_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_magnetic_tilt_compensated_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_compensated_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_compensated_roc_falling_en
Same as above. Names are very long.

Thanks,
Srinivas
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_roc_rising_en
> @@ -527,6 +551,14 @@ What:		/sys/.../events/in_magn_y_raw_thresh_rising_value
>   What:		/sys/.../events/in_magn_y_raw_thresh_falling_value
>   What:		/sys/.../events/in_magn_z_raw_thresh_rising_value
>   What:		/sys/.../events/in_magn_z_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_magnetic_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_magnetic_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_true_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_true_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_raw_thresh_falling_value
>   What:		/sys/.../events/in_voltageY_supply_raw_thresh_rising_value
>   What:		/sys/.../events/in_voltageY_supply_raw_thresh_falling_value
>   What:		/sys/.../events/in_voltageY_raw_thresh_rising_value
> @@ -577,6 +609,18 @@ What:		/sys/.../events/in_magn_y_thresh_either_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_rising_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_falling_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_magnetic_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_magnetic_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_magnetic_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_true_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_true_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_true_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_thresh_either_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_rising_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_falling_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_either_hysteresis
> @@ -624,6 +668,14 @@ What:		/sys/.../events/in_magn_y_raw_roc_rising_value
>   What:		/sys/.../events/in_magn_y_raw_roc_falling_value
>   What:		/sys/.../events/in_magn_z_raw_roc_rising_value
>   What:		/sys/.../events/in_magn_z_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_magnetic_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_magnetic_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_true_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_true_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_raw_roc_falling_value
>   What:		/sys/.../events/in_voltageY_supply_raw_roc_rising_value
>   What:		/sys/.../events/in_voltageY_supply_raw_roc_falling_value
>   What:		/sys/.../events/in_voltageY_raw_roc_rising_value
> @@ -679,6 +731,22 @@ What:		/sys/.../events/in_magn_z_thresh_rising_period
>   What:		/sys/.../events/in_magn_z_thresh_falling_period
>   What:		/sys/.../events/in_magn_z_roc_rising_period
>   What:		/sys/.../events/in_magn_z_roc_falling_period
> +What:		/sys/.../events/in_magn_north_magnetic_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_magnetic_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_magnetic_roc_rising_period
> +What:		/sys/.../events/in_magn_north_magnetic_roc_falling_period
> +What:		/sys/.../events/in_magn_north_true_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_true_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_true_roc_rising_period
> +What:		/sys/.../events/in_magn_north_true_roc_falling_period
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_roc_rising_period
> +What:		/sys/.../events/in_magn_north_magnetic_tilt_compensated_roc_falling_period
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_roc_rising_period
> +What:		/sys/.../events/in_magn_north_true_tilt_compensated_roc_falling_period
>   What:		/sys/.../events/in_voltageY_supply_thresh_rising_period
>   What:		/sys/.../events/in_voltageY_supply_thresh_falling_period
>   What:		/sys/.../events/in_voltageY_supply_roc_rising_period
> @@ -776,6 +844,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_magnetic_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_magnetic_tilt_compensated_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_tilt_compensated_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_en
> @@ -840,6 +912,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_magnetic_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_magnetic_tilt_compensated_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_tilt_compensated_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index

